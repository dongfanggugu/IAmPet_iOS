//
//  VideoPlayerController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/2/10.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerController()

@end

@implementation VideoPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"视频播放"];
    [self initView];
}

- (void)initView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 20;
    view.center = CGPointMake(25, 42);
    [self.view addSubview:view];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.center = CGPointMake(20, 20);
    [view addSubview:btn];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
