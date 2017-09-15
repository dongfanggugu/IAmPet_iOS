//
//  BaseViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
