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
}

@end
