//
//  MiddleSideViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/13.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "MiddleSideViewController.h"

@interface MiddleSideViewController ()


@end

@implementation MiddleSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self customNavigationBar];
}

- (void)customNavigationBar
{
    UIView *navigationBar = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    navigationBar.backgroundColor = [UIColor greenColor];
    [self.view addSubview:navigationBar];
}

- (void)initView
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    btn.backgroundColor = [UIColor greenColor];
    btn.center = CGPointMake(ScreenWidth / 2, 100);
    [btn setTitle:@"切换" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(slide) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btnPush = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    btnPush.backgroundColor = [UIColor greenColor];
    btnPush.center = CGPointMake(ScreenWidth / 2, 200);
    [btnPush setTitle:@"push" forState:UIControlStateNormal];
    [btnPush addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPush];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)]];
}

/**
 *  点击切换按钮
 */
- (void)slide
{
    if (_delegate && [_delegate respondsToSelector:@selector(onSlide:)])
    {
        [_delegate onSlide:self];
    }
}


- (void)push
{
    if (_delegate && [_delegate respondsToSelector:@selector(onPush:)])
    {
        [_delegate onPush:self];
    }
}

/**
 *  界面手势滑动
 *
 *  @param gesture gesture
 */
- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(onPanGesture:)])
    {
        [_delegate onPanGesture:gesture];
    }
    
}

@end
