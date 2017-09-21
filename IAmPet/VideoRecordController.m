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


@interface VideoRecordController()<WCLRecordEngineDelegate>
{
    NSInteger _count;
}

//@property (strong, nonatomic) AVCaptureMovieFileOutput *output;

@property (strong, nonatomic) UIView *processView;

@property (strong, nonatomic) UIButton *btnRecord;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) WCLRecordEngine *recordEngine;


@end


@implementation VideoRecordController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initDevice];
    [self initNaviBar];
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

/**
 *  添加后退按钮
 */
- (void)initNaviBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.center = CGPointMake(25, 42);
    [view addSubview:btn];
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    lbTitle.font = [UIFont systemFontOfSize:15];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.center = CGPointMake(ScreenWidth / 2, 42);
    lbTitle.text = @"拍摄";
    [view addSubview:lbTitle];
}

/**
 *  初始化视图
 */
- (void)initView
{
    _btnRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_btnRecord setTitle:@"按住拍" forState:UIControlStateNormal];
    _btnRecord.titleLabel.font = [UIFont systemFontOfSize:13];
    _btnRecord.layer.masksToBounds = YES;
    _btnRecord.layer.cornerRadius = 40;
    _btnRecord.layer.borderColor = RGB(Color_Main1).CGColor;
    _btnRecord.layer.borderWidth = 1;
    _btnRecord.center = CGPointMake(ScreenWidth / 2, ScreenWidth  + 100);
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = RGB(Color_Main1).CGColor;
    layer.masksToBounds = YES;
    layer.cornerRadius = 35;
    layer.frame = CGRectMake(5, 5, 70, 70);
    [_btnRecord.layer addSublayer:layer];
    
    [self.view addSubview:_btnRecord];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongPressed:)];
    recognizer.minimumPressDuration = 0.5;
    [_btnRecord addGestureRecognizer:recognizer];
    
    _processView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth, ScreenWidth, 5)];
    _processView.backgroundColor = RGB(Color_Main1);
    
    [self.view addSubview:_processView];
}

/**
 *  长按录制
 *
 *  @param gesture gesture
 */
- (void)btnLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (UIGestureRecognizerStateBegan == gesture.state)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(itsTime) userInfo:nil repeats:YES];
        [self.recordEngine startCapture];
    }
    else if (UIGestureRecognizerStateEnded == gesture.state)
    {
        if (_count != 0)
        {
            [self stop];
        }
    }
}

//- (void)click:(id)sender
//{
//    if (self.recordEngine.isCapturing)
//    {
//        [self stop];
//        return;
//    }
//    
//    [sender setTitle:@"停止" forState:UIControlStateNormal];
//    
//    //开始录制
//    //NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myVideo.mp4"];
//    //NSURL *url = [NSURL fileURLWithPath:path];
//    //[self.output startRecordingToOutputFileURL:url recordingDelegate:self];
//    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(itsTime) userInfo:nil repeats:YES];
//    [self.recordEngine startCapture];
//}

/**
 *  停止录制
 */
- (void)stop
{
    [self.recordEngine stopCaptureHandler:^(UIImage *movieImage)
     {
         NSLog(@"录制完成");
         
         NSString *path = self.recordEngine.videoPath;
         [self recordSuccess:path preview:movieImage];
         
     }];
    
    [_btnRecord setTitle:@"录制" forState:UIControlStateNormal];
    
    [_timer invalidate];
    _timer = nil;
    _processView.frame = CGRectZero;
    _count = 0;
}

- (void)recordSuccess:(NSString *)path preview:(UIImage *)image
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(onRecordSuccess:preview:)])
    {
        [_delegate onRecordSuccess:path preview:image];
    }
}

- (void)initDevice
{
    if (!_recordEngine)
    {
        [self.recordEngine previewLayer].frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
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
        _recordEngine.videoWidth = ScreenWidth;
        _recordEngine.videoHeight = ScreenWidth;
        _recordEngine.fps = 30;
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
            
            NSString *path = self.recordEngine.videoPath;
            
            NSLog(@"path:%@", path);
            [self recordSuccess:path preview:movieImage];
            
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
//
//#pragma mark - AVCaptureFileOutputRecordingDelegate
//
//- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
//{
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(itsTime) userInfo:nil repeats:YES];
//}
//
//- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
//      fromConnections:(NSArray *)connections error:(NSError *)error
//{
//    NSLog(@"录制完成");
//    
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myVideo.mp4"];
//    
//    [self recordSuccess:path];
//}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
