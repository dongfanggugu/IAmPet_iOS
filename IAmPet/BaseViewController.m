//
//  BaseViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(Color_Window);
    // Do any additional setup after loading the view.
    [self initNavBar];
}

/**
 *  获取屏幕宽度
 *
 *  @return screen width
 */
- (CGFloat)sWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

/**
 *  获取屏幕高度
 *
 *  @return screen height
 */
- (CGFloat)sHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

/**
 *  显示只有有一个按钮的
 *
 *  @param msg     msg
 *  @param dismiss dismiss callback
 *
 *  @return UIAlertController
 */
- (UIAlertController *)showAlertMsg:(NSString *)msg dismiss:(void(^)())dismiss
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (dismiss)
        {
            dismiss();
        }
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    return controller;
}

/**
 *  显示有确认和取消的弹出框
 *
 *  @param msg      msg
 *  @param positive positive
 *  @param negative negative
 *
 *  @return UIAlertController
 */
- (UIAlertController *)showAlertMsg:(NSString *)msg positive:(void(^)())positive negative:(void(^)())negative
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (positive)
        {
            positive();
        }
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (negative)
        {
            negative();
        }
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    return controller;
}

/**
 *  设置导航栏标题
 *
 *  @param title navigationbar title
 */
- (void)setNavTitle:(NSString *)title
{
    if (!self.navigationController)
    {
        return;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.title = title;
}

/**
 *  初始化导航栏
 */
- (void)initNavBar
{
    if (!self.navigationController)
    {
        return;
    }
    
    self.navigationController.navigationBar.translucent = NO;
    CAGradientLayer  *layer = [CAGradientLayer layer];
    layer.colors = @[(__bridge id)RGB(Color_Main2).CGColor, (__bridge id)RGB(Color_Main3).CGColor, (__bridge id)RGB(Color_Main1).CGColor];
    layer.locations = @[@0.2, @0.6];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    layer.frame = CGRectMake(0, 0, ScreenWidth, 64);
    [self.navigationController.navigationBar.subviews[0].layer addSublayer:layer];
}

/**
 *  设置导航栏左侧按钮和回调
 *
 *  @param image     image
 *  @param clickLeft click callback
 */
- (void)setNavBarLeft:(UIImage *)image click:(void(^)())clickLeft
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    btn.tintColor = [UIColor whiteColor];
    [btn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    if (clickLeft)
    {
        objc_setAssociatedObject(btn, @"click_callback", clickLeft, OBJC_ASSOCIATION_COPY);
        [btn addTarget:self action:@selector(clickNavCallback:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  设置导航栏右侧按钮和回调
 *
 *  @param image     image
 *  @param clickRight click callback
 */
- (void)setNavBarRight:(UIImage *)image click:(void(^)())clickRight
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    if (clickRight)
    {
        objc_setAssociatedObject(btn, @"click_callback", clickRight, OBJC_ASSOCIATION_COPY);
        [btn addTarget:self action:@selector(clickNavCallback:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  点击导航栏按钮回调
 *
 *  @param sender sender
 */
- (void)clickNavCallback:(id)sender
{
    void(^callback)() = objc_getAssociatedObject(sender, @"click_callback");
    callback();
}


/**
 *  跳转到应用的设置界面
 */
- (void)jumpToSettings
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)dealloc
{
    NSLog(@"dealloc: %@", [self class]);
}

@end
