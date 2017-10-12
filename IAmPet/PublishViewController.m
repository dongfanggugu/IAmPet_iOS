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
#import <ALMoviePlayerController.h>
#import <AVKit/AVKit.h>
#import "VideoPlayView.h"
#import <IQTextView.h>
#import "IAmPet-Swift.h"
#import "PhotoView.h"

#define MAX_LENGTH 300

@interface PublishViewController () <TZImagePickerControllerDelegate, PhotosViewDelegate, AVAudioRecorderDelegate, VideoRecordControllerDelegate, VoicePlayViewDelegate, UITextViewDelegate>

- (IBAction)close:(id)sender;

- (IBAction)showPhotoPicker:(id)sender;

- (IBAction)recordVideo:(id)sender;

@property (nonatomic, weak) IBOutlet UILabel *lbStatistics;

@property (nonatomic, weak) IBOutlet IQTextView *textView;

@property (nonatomic, weak) IBOutlet UIButton *btnPublish;

@property (nonatomic, weak) IBOutlet UIButton *btnClose;

@property (nonatomic, weak) IBOutlet UIButton *btnPhoto;

@property (nonatomic, weak) IBOutlet UIButton *btnVoice;

@property (nonatomic, weak) IBOutlet UIView *viewMyVoice;

@property (nonatomic, weak) IBOutlet UIView *viewMyPhoto;

@property (nonatomic, weak) IBOutlet UIView *viewMyVideo;

@property (nonatomic, weak) IBOutlet UIView *viewPhoto;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *photoHeight;

@property (nonatomic, strong) PhotosView *photosView;

@property (nonatomic, strong) VoiceRecordView *voiceView;

@property (nonatomic, copy) NSString *videoPath;

//语音播放
@property (nonatomic, strong) VoicePlayView *playView;

//视频播放
@property (nonatomic, strong) ALMoviePlayerController *playerController;

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
    _photoHeight.constant = 0;
    [self initStyle];
    
    _textView.placeholder = @"分享你的想法......";
    _textView.delegate = self;
    
    _lbStatistics.text = [NSString stringWithFormat:@"0/%d", MAX_LENGTH];
    
    //录音按钮处理
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    longPress.minimumPressDuration = 0.5;
    [_btnVoice addGestureRecognizer:longPress];
    
    [_textView becomeFirstResponder];
}

/**
 *  设置控件的风格
 */
- (void)initStyle
{
    _btnPublish.backgroundColor = RGB(Color_Main);
    _lbStatistics.textColor = [UIColor lightGrayColor];
    
    [self cornerView:_viewMyVoice];
    [self cornerView:_viewMyVideo];
    [self cornerView:_viewMyPhoto];
}

/**
 *  图形圆角显示
 *
 *  @param view view
 */
- (void)cornerView:(UIView *)view
{
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1;
    view.layer.borderColor = RGB(Color_Main).CGColor;
}

- (IBAction)publish
{
    PhotoView *photoView = (PhotoView *) [_photosView.arrayPhotoView firstObject];
    UIImage *image = photoView.imgPhoto;
    
    NSData *data = UIImagePNGRepresentation(image);
    [self uploadFile:data name:@"aaaa" url:@"image_upload"];
}

- (void)uploadFile:(NSData *)data name:(NSString *)fileName url:(NSString *)url
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
//    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://10.10.4.9:3000/mobile/image_upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
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
    
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    [self presentViewController:controller animated:YES completion:nil];
    
    __weak typeof (self) weakSelf = self;
    [controller setDidFinishPickingPhotosHandle:^(NSArray *arrayImage, NSArray *array, BOOL isOrigin){
        //清除之前加载的图片
        [self cleanMediaView];
        _photosView = [[PhotosView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 32, 0) imageArray:arrayImage max:3];
        _photosView.delegate = self;
        _photosView.viewUpdate = ^(PhotosView *view) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.photoHeight.constant = view.bounds.size.height;
                [weakSelf.view layoutIfNeeded];
            }];
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
- (void)onRecordSuccess:(NSString *)path preview:(UIImage *)image
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(voiceRecordSuccess:)])
    {
        [_delegate voiceRecordSuccess:path];
    }
    
    [self cleanMediaView];
    CGFloat width = _viewPhoto.frame.size.width;
    CGFloat height = width;
    
    VideoPlayView *videoPlayView = [VideoPlayView viewFromNib];
    videoPlayView.frame = CGRectMake(0, 0, width, height);
    
    videoPlayView.imageView.image = image;
    videoPlayView.clickPlay = ^{
        [self playVideo:path];
    };
    videoPlayView.clickDel = ^{
        [Utils delFile:path];
        [self cleanMediaView];
    };
    
    [_viewPhoto addSubview:videoPlayView];
    
    [UIView animateWithDuration:0.5 animations:^{
        _photoHeight.constant = height;
        [self.view layoutIfNeeded];
    }];
    
}

/**
 *  播放视频
 *
 *  @param path path
 */
- (void)playVideo:(NSString *)path
{
    VideoPlayerController *controller = [VideoPlayerController new];
    controller.urlStr = path;
    [self presentViewController:controller animated:YES completion:nil];
}

/**
 *  添加语音播放界面
 *
 *  @param path path
 */
- (void)prepareForPlayVoice:(NSString *)path
{
    if (_delegate && [_delegate respondsToSelector:@selector(voiceRecordSuccess:)])
    {
        [_delegate voiceRecordSuccess:path];
    }
    
    [self cleanMediaView];
    _playView = [VoicePlayView viewFromNib];
    _playView.delegate = self;
    _playView.voicePath = path;
    _playView.frame = CGRectMake(0, 0, ScreenWidth - 32, _playView.bounds.size.height);
    
    [_viewPhoto addSubview:_playView];
    
    [UIView animateWithDuration:0.5 animations:^{
        _photoHeight.constant = _playView.bounds.size.height;
        [self.view layoutIfNeeded];
    }];
}

/**
 *  清理多媒体view
 */
- (void)cleanMediaView
{
    for (UIView *view in _viewPhoto.subviews)
    {
        [view removeFromSuperview];
    }
    _photoHeight.constant = 0;
}

/**
 *  删除语音
 *
 *  @param playView playView
 */
- (void)closePlayView:(VoicePlayView *)playView
{
    [UIView animateWithDuration:0.5 animations:^{
        [self cleanMediaView];
        _photoHeight.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [HHUtils textViewLimitOnInput:MAX_LENGTH textView:textView textRange:range text:text];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [HHUtils textViewLimitEndInput:MAX_LENGTH textView:textView label:_lbStatistics];
}

@end
