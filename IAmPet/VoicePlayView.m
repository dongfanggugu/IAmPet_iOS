//
//  VoicePlayView.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/20.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "VoicePlayView.h"
#import <AVFoundation/AVFoundation.h>

@interface VoicePlayView () <AVAudioPlayerDelegate>

- (IBAction)playVoice:(id)sender;

- (IBAction)delVoice:(id)sender;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, weak) IBOutlet UIView *viewVoice1;

@property (nonatomic, weak) IBOutlet UIView *viewVoice2;

@property (nonatomic, weak) IBOutlet UIView *viewVoice3;

@property (nonatomic, weak) IBOutlet UIView *viewVoice4;

@property (nonatomic, weak) IBOutlet UIView *viewVoice5;

@property (nonatomic, weak) IBOutlet UIView *viewVoice6;

@property (nonatomic, copy) NSArray *arrayVoice;

@property (nonatomic, strong) NSTimer *voiceTimer;

@end

@implementation VoicePlayView

+ (instancetype)viewFromNib
{
    return [self viewFromNib:@"VoicePlayView"];
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

/**
 *  播放声音
 *
 *  @param sender sender
 */
- (IBAction)playVoice:(id)sender
{
    NSURL *url = [NSURL URLWithString:self.voicePath];
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
        [self voidTimerCancel];
        [_player stop];
        _player = nil;
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [session setActive:YES error:nil];
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    _player.meteringEnabled = YES;
    _player.delegate = self;
    
    [_player play];
    [self detectPlayerVoice];
    
    //正在播放，那么就返回YES
    return YES;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self voidTimerCancel];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    [self voidTimerCancel];
}

/**
 *   取消监听音量的定时器
 */
- (void)voidTimerCancel
{
    if (self.voiceTimer && [self.voiceTimer isValid])
    {
        [self.voiceTimer invalidate];
        self.voiceTimer = nil;
    }
}

/**
 *  监听语音播放的声音
 *
 */
- (void)detectPlayerVoice
{
    _voiceTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.player updateMeters];
        NSInteger lowPassResult = (NSInteger)(pow(10, (0.05 * [self.player peakPowerForChannel:1])) * 100);
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
 *  从view上移除
 *
 *  @param sender sender
 */
- (IBAction)delVoice:(id)sender
{
    if (self.superview)
    {
        [self removeFromSuperview];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(closePlayView:)])
    {
        [_delegate closePlayView:self];
    }
}

- (void)dealloc
{
    [self voidTimerCancel];
}

@end
