//
//  VoiceRecordView.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/20.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "VoiceRecordView.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

#define kSandboxPathStr [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define kMp3FileName @"myRecord.mp3"

#define kCafFileName @"myRecord.caf"

@interface VoiceRecordView ()

@property (nonatomic, weak) IBOutlet UIView *viewVoice1;

@property (nonatomic, weak) IBOutlet UIView *viewVoice2;

@property (nonatomic, weak) IBOutlet UIView *viewVoice3;

@property (nonatomic, weak) IBOutlet UIView *viewVoice4;

@property (nonatomic, weak) IBOutlet UIView *viewVoice5;

@property (nonatomic, weak) IBOutlet UIView *viewVoice6;

@property (nonatomic, copy) NSArray *arrayVoice;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, copy) NSString *cafPath;

@property (nonatomic, copy) NSString *mp3Path;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation VoiceRecordView

+ (instancetype)viewFromNib
{
    return [self viewFromNib:@"VoiceRecordView"];
}

/**
 *  获取arrayVoice
 *
 *  @return arrayVoice
 */
- (NSArray *)arrayVoice
{
    if (!_arrayVoice)
    {
        _arrayVoice = @[_viewVoice1, _viewVoice2, _viewVoice3, _viewVoice4, _viewVoice5, _viewVoice6];
    }
    
    return _arrayVoice;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    self.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.7];
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
        [self detectVoice];
    }
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
 *  监听声音
 */
- (void)detectVoice
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.audioRecorder updateMeters];
        NSInteger lowPassResult = (NSInteger)(pow(10, (0.05 * [self.audioRecorder peakPowerForChannel:1])) * 100);
        [self updateVoiceView:lowPassResult];
    }];
}

/**
 *  显示音量图标
 *
 *  @param voiceResult voice result
 */
- (void)updateVoiceView:(NSInteger)voiceResult
{
    NSLog(@"result: %ld", voiceResult);
    [self showVoice:ceil(voiceResult / 9.0)];
}

/**
 *  根据音量等级显示图片
 *
 *  @param level voice level
 */
- (void)showVoice:(NSInteger)level
{
    NSLog(@"level: %ld", level);
    for (NSInteger i = 0; i < self.arrayVoice.count; i++)
    {
        if (i < level)
        {
            [self.arrayVoice[i] setHidden:NO];
        }
        else
        {
            [self.arrayVoice[i] setHidden:YES];
        }
    }
}


/**
 *  停止录音
 */
- (NSString *)stopRecord
{
    NSLog(@"----------结束录音----------");
    
    if (self.timer && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.audioRecorder stop];
    [self audio_PCMtoMP3];
    
    [self dismiss];
    
    return self.mp3Path;
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

- (void)dealloc
{
    if (self.timer && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    NSLog(@"dealloc: VoiceRecordView");
}

/**
 *  从界面上移除
 */
- (void)dismiss
{
    if (self.timer && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.superview)
    {
        [self removeFromSuperview];
    }
}


@end
