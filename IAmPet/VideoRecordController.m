//
//  VideoRecordController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoRecordController.h"
#import "WCLRecordEngine.h"
#import <AVFoundation/AVFoundation.h>

#define VIDEO_LENGTH 10


@interface VideoRecordController()<AVCaptureFileOutputRecordingDelegate, WCLRecordEngineDelegate>
{
    NSInteger _count;
}

@property (strong, nonatomic) AVCaptureMovieFileOutput *output;

@property (strong, nonatomic) UIView *processView;


@property (strong, nonatomic) UIButton *btnRecord;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) WCLRecordEngine *recordEngine;


@end


@implementation VideoRecordController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"视频录制"];
    [self initData];
    [self initDevice];
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_timer && [_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)initData
{
    _count = 0;
}

- (void)initView
{
    _btnRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    [_btnRecord setTitle:@"录制" forState:UIControlStateNormal];
    
    
    
    _btnRecord.layer.masksToBounds = YES;
    
    _btnRecord.layer.cornerRadius = 30;
    
    _btnRecord.backgroundColor = RGB(Color_Main1);
    
    _btnRecord.center = CGPointMake(ScreenWidth / 2, ScreenHeight - 100 + 60);
    
    [self.view addSubview:_btnRecord];
    
    [_btnRecord addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    _processView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 100, ScreenWidth, 10)];
    _processView.backgroundColor = RGB(Color_Main1);
    
    [self.view addSubview:_processView];
}



- (void)click:(id)sender
{
    if (self.recordEngine.isCapturing)
    {
        [self stop];
        return;
    }
    
    [sender setTitle:@"停止" forState:UIControlStateNormal];
    
    //开始录制
    //NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myVideo.mp4"];
    //NSURL *url = [NSURL fileURLWithPath:path];
    //[self.output startRecordingToOutputFileURL:url recordingDelegate:self];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(itsTime) userInfo:nil repeats:YES];
    [self.recordEngine startCapture];
}

/**
 *  停止录制
 */
- (void)stop
{
    [self.recordEngine stopCaptureHandler:^(UIImage *movieImage)
     {
         NSLog(@"录制完成");
         
         //NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myVideo.mp4"];
         
         NSString *path = self.recordEngine.videoPath;
         [self recordSuccess:path];
         
     }];
    
    [_btnRecord setTitle:@"录制" forState:UIControlStateNormal];
    
    [_timer invalidate];
    _timer = nil;
    _processView.frame = CGRectZero;
    _count = 0;
}

- (void)recordSuccess:(NSString *)path
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(onRecordSuccess:)])
    {
        [_delegate onRecordSuccess:path];
    }
}

- (void)initDevice
{
    
    if (!_recordEngine)
    {
        [self.recordEngine previewLayer].frame = CGRectMake(0, 94, ScreenWidth, ScreenHeight - 94 - 100);
        [self.view.layer addSublayer:[_recordEngine previewLayer]];
    }
    
    [_recordEngine startUp];
}


#pragma mark - set、get方法
- (WCLRecordEngine *)recordEngine
{
    if (_recordEngine == nil)
    {
        _recordEngine = [[WCLRecordEngine alloc] init];
        _recordEngine.delegate = self;
    }
    return _recordEngine;
}

#pragma mark - WCLRecordEngineDelegate
- (void)recordProgress:(CGFloat)progress
{
}

- (void)itsTime
{
    _count += 1;
    
    if (VIDEO_LENGTH * 10 <= _count)
    {
        [self.recordEngine stopCaptureHandler:^(UIImage *movieImage)
        {
            NSLog(@"录制完成");
            
            //NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myVideo.mp4"];
            
            NSString *path = self.recordEngine.videoPath;
            
            NSLog(@"path:%@", path);
            [self recordSuccess:path];
            
        }];
        
        [_btnRecord setTitle:@"录制" forState:UIControlStateNormal];
        
        [_timer invalidate];
        _timer = nil;
        _processView.frame = CGRectZero;
        _count = 0;
    }
    
    CGRect frame = _processView.frame;
    
    CGFloat interval = ScreenWidth / (VIDEO_LENGTH * 10);
    
    frame.size.width -= interval;
    
    _processView.frame = frame;
    
    CGPoint center = _processView.center;
    
    center.x = ScreenWidth / 2;
    
    _processView.center = center;
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(itsTime) userInfo:nil repeats:YES];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"录制完成");
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myVideo.mp4"];
    
    [self recordSuccess:path];
}



- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 二进制文件转为base64的字符串
- (NSString *)Base64StrWithData:(NSData *)data
{
    if (!data) {
        NSLog(@"NSData 不能为空");
        return nil;
    }
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return str;
}


@end
