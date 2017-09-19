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
#import "lame.h"

#define kSandboxPathStr [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define kMp3FileName @"myRecord.mp3"

#define kCafFileName @"myRecord.caf"

@interface PublishViewController () <TZImagePickerControllerDelegate, PhotosViewDelegate, AVAudioRecorderDelegate>

@property (nonatomic, weak) IBOutlet UIButton *btnClose;

@property (nonatomic, weak) IBOutlet UIButton *btnPhoto;

@property (nonatomic, weak) IBOutlet UIButton *btnVoice;

@property (nonatomic, weak) IBOutlet UIView *viewPhoto;

@property (nonatomic, weak) IBOutlet UIView *viewVoice;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *photoHeight;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *voiceHeight;

@property (nonatomic, strong) PhotosView *photosView;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, copy) NSString *cafPath;

@property (nonatomic, copy) NSString *mp3Path;

@property (strong, nonatomic) AVAudioPlayer *player;

- (IBAction)close:(id)sender;

- (IBAction)showPhotoPicker:(id)sender;

- (IBAction)playVoice:(id)sender;

@end

@implementation PublishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    //录音按钮处理
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
    //longPress.delegate = self;
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

/**
 *  录音按钮长按处理
 *
 *  @param gestureRecognizer gestureRecognizer
 */
- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [HUDClass showHUDWithText:@"按住说话"];
        [self startRecord];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"UIGestureRecognizerStateEnded");
        [self stopRecord];
    }
    
}

#pragma mark - 录音方法

- (void)startRecord
{
    
    if ([self.audioRecorder isRecording])
    {
        [self.audioRecorder stop];
    }
    NSLog(@"----------开始录音----------");
    [self deleteOldRecordFile];  //如果不删掉，会在原文件基础上录制；虽然不会播放原来的声音，但是音频长度会是录制的最大长度。
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    if (![self.audioRecorder isRecording])
    {
        //首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        [self.audioRecorder record];
    }
}

/**
 *  停止录音
 */
- (void)stopRecord
{
    NSLog(@"----------结束录音----------");
    
    [self.audioRecorder stop];
    [self audio_PCMtoMP3];
}

/**
 *  pcm转为mp3
 */
- (void)audio_PCMtoMP3
{
    @try
    {
        int read, write;
        
        //source 被转换的音频文件位置
        FILE *pcm = fopen([self.cafPath cStringUsingEncoding:1], "rb");
        fseek(pcm, 4 * 1024, SEEK_CUR);                                   //skip file header
        
        //output 输出生成的Mp3文件位置
        FILE *mp3 = fopen([self.mp3Path cStringUsingEncoding:1], "wb"); 
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do
        {
            read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
            {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            }
            else
            {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        }
        while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", [exception description]);
    }
    @finally
    {
        NSLog(@"MP3生成成功: %@", self.mp3Path);
    }
    
}

/**
 *  获取录音对象
 *
 *  @return audioRecorder
 */
- (AVAudioRecorder *)audioRecorder
{
    if (!_audioRecorder)
    {
        //创建录音文件保存路径
        NSURL *url = [NSURL URLWithString:self.cafPath];
        //创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        //创建录音机
        NSError *error = nil;
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//如果要监控声波则必须设置为YES
        if (error)
        {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@", error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
- (NSDictionary *)getAudioSetting
{
    //LinearPCM 是iOS的一种无损编码格式,但是体积较为庞大
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //采样率
    [recordSettings setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];//44100.0
    //通道数
    [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    return recordSettings;
}

/**
 *  获取caf存储路径
 *
 *  @return cafPath
 */
- (NSString *)cafPath
{
    _cafPath = [kSandboxPathStr stringByAppendingPathComponent:kCafFileName];
    return _cafPath;
}

/**
 *  获取mp3存储路径
 *
 *  @return mp3Path
 */
- (NSString *)mp3Path
{
    _mp3Path = [kSandboxPathStr stringByAppendingPathComponent:kMp3FileName];
    return _mp3Path;
}

/**
 *  删除之前录制文件
 */
- (void)deleteOldRecordFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:self.cafPath];
    if (!blHave)
    {
        NSLog(@"不存在");
        return;
    }
    else
    {
        NSLog(@"存在");
        BOOL blDele = [fileManager removeItemAtPath:self.cafPath error:nil];
        if (blDele)
        {
            NSLog(@"删除成功");
        }
        else
        {
            NSLog(@"删除失败");
        }
    }
}

/**
 *  播放声音
 *
 *  @param sender sender
 */
- (IBAction)playVoice:(id)sender
{
    NSURL *url = [NSURL URLWithString:self.mp3Path];
    [self playMusicWithUrl:url];
}

/**
 *播放音乐文件
 */
- (BOOL)playMusicWithUrl:(NSURL *)fileUrl
{
    //其他播放器停止播放
    if (!fileUrl)
    {
        return NO;
    }
    
    if ([_player isPlaying])
    {
        [_player stop];
        _player = nil;
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [session setActive:YES error:nil];
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    
    [_player play];
    //正在播放，那么就返回YES
    return YES;
}

@end
