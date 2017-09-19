//
//  BaseViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//


@interface BaseViewController : UIViewController

/**
 *  显示只有有一个按钮的
 *
 *  @param msg     msg
 *  @param dismiss dismiss callback
 *
 *  @return UIAlertController
 */
- (UIAlertController *)showAlertMsg:(NSString *)msg dismiss:(void(^)())dismiss;

/**
 *  显示有确认和取消的弹出框
 *
 *  @param msg      msg
 *  @param positive positive
 *  @param negative negative
 *
 *  @return UIAlertController
 */
- (UIAlertController *)showAlertMsg:(NSString *)msg positive:(void(^)())positive negative:(void(^)())negative;

/**
 *  设置导航栏标题
 *
 *  @param title navigationbar title
 */
- (void)setNavTitle:(NSString *)title;

/**
 *  设置导航栏左侧按钮和回调
 *
 *  @param image     image
 *  @param clickLeft click callback
 */
- (void)setNavBarLeft:(UIImage *)image click:(void(^)())clickLeft;

/**
 *  设置导航栏右侧按钮和回调
 *
 *  @param image     image
 *  @param clickRight click callback
 */
- (void)setNavBarRight:(UIImage *)image click:(void(^)())clickRight;

/**
 *  跳转到应用的设置界面
 */
- (void)jumpToSettings;

//屏幕宽度
@property (nonatomic, assign, readonly) CGFloat sWidth;

//屏幕高度
@property (nonatomic, assign, readonly) CGFloat sHeight;

@end
