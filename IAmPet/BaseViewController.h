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

//屏幕宽度
@property (nonatomic, assign, readonly) CGFloat sWidth;

//屏幕高度
@property (nonatomic, assign, readonly) CGFloat sHeight;

@end
