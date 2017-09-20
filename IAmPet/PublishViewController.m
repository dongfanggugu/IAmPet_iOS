//
//  PublishViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/19.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "PublishViewController.h"
#import <TZImagePickerController.h>
#import <RSKImageCropper.h>
#import <Photos/Photos.h>
#import "PhotosView.h"
#import "VideoRecordController.h"
#import "VideoPlayerController.h"
#import "VoiceRecordView.h"
#import "VoicePlayView.h"


@interface PublishViewController () <TZImagePickerControllerDelegate, PhotosViewDelegate, AVAudioRecorderDelegate, VideoRecordControllerDelegate, VoicePlayViewDelegate>

- (IBAction)close:(id)sender;

- (IBAction)showPhotoPicker:(id)sender;

- (IBAction)recordVideo:(id)sender;

@property (nonatomic, weak) IBOutlet UIButton *btnClose;

@property (nonatomic, weak) IBOutlet UIButton *btnPhoto;

@property (nonatomic, weak) IBOutlet UIButton *btnVoice;

@property (nonatomic, weak) IBOutlet UIView *viewPhoto;

@property (nonatomic, weak) IBOutlet UIView *viewVoice;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *photoHeight;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *voiceHeight;

@property (nonatomic, strong) PhotosView *photosView;

@property (nonatomic, strong) VoiceRecordView *voiceView;

@property (nonatomic, copy) NSString *videoPath;

//语音播放
@property (nonatomic, strong) VoicePlayView *playView;

@end

@implementation PublishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    //初始化
    _voiceHeight.constant = 0;
    _photoHeight.constant = 0;
    
    //录音按钮处理
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    longPress.minimumPressDuration = 0.5;
    [_btnVoice addGestureRecognizer:longPress];
}

/**
 *  关闭
 *
 *  @param sender sender
 */
- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showPhotoPicker:(id)sender
{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    
    if (PHAuthorizationStatusRestricted == author || PHAuthorizationStatusDenied == author)
    {
        [self showAlertMsg:@"您已经关闭访问相册权限" positive:^{
            [self jumpToSettings];
        } negative:nil];
        return;
    }
    
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [self presentViewController:controller animated:YES completion:nil];
    
    __weak typeof (self) weakSelf = self;
    [controller setDidFinishPickingPhotosHandle:^(NSArray *arrayImage, NSArray *array, BOOL isOrigin){
        _photosView = [[PhotosView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 32, 0) imageArray:arrayImage max:9];
        _photosView.delegate = self;
        _photosView.viewUpdate = ^(PhotosView *view) {
            weakSelf.photoHeight.constant = view.bounds.size.height;
        };
        [_photosView showPhotos];
        [_viewPhoto addSubview:_photosView];
    }];
}

#pragma mark - PhotosViewDelegate

- (void)addImage:(PhotosView *)photosView
{
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [self presentViewController:controller animated:YES completion:nil];
    
    __weak typeof (self) weakSelf = self;
    [controller setDidFinishPickingPhotosHandle:^(NSArray *arrayImage, NSArray *array, BOOL isOrigin){
        [weakSelf.photosView addImage:arrayImage[0]];
    }];
}

- (void)previewImage:(UIImage *)image
{
    [self showPreviewImage:image];
}

/**
 *  录音按钮长按处理
 *
 *  @param gestureRecognizer gestureRecognizer
 */
- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        _voiceView = [VoiceRecordView viewFromNib];
        _voiceView.center = CGPointMake(ScreenWidth / 2, 110);
        [self.view addSubview:_voiceView];
        [_voiceView startRecord];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSString *voicePath = [_voiceView stopRecord];
        [self prepareForPlayVoice:voicePath];
    }
    
}

#pragma mark - 视频处理

/**
 *  录制视频
 *
 *  @param sender sender
 */
- (IBAction)recordVideo:(id)sender
{
    VideoRecordController *controller = [VideoRecordController new];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

/**
 *  录制视频回调
 *
 *  @param path path
 */
- (void)onRecordSuccess:(NSString *)path
{
    self.videoPath = path;
}

/**
 *  添加语音播放界面
 *
 *  @param path path
 */
- (void)prepareForPlayVoice:(NSString *)path
{
    if (!_playView)
    {
        _playView = [VoicePlayView viewFromNib];
        _playView.delegate = self;
    }
    if (_playView.superview)
    {
        [_playView removeFromSuperview];
    }
    
    _playView.voicePath = path;
    _playView.frame = CGRectMake(0, 0, ScreenWidth - 32, _playView.bounds.size.height);
    _voiceHeight.constant = _playView.bounds.size.height;
    _viewVoice.backgroundColor = [UIColor redColor];
    
    NSLog(@"x: %.3lf", _playView.frame.origin.y);
    [_viewVoice addSubview:_playView];
}

/**
 *  删除语音
 *
 *  @param playView playView
 */
- (void)closePlayView:(VoicePlayView *)playView
{
    _voiceHeight.constant = 0;
}

/**
 *  播放视频
 *
 *  @param sender sender
 */
- (IBAction)playVideo:(id)sender
{
    VideoPlayerController *controller = [VideoPlayerController new];
    controller.urlStr = self.videoPath;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
