//
//  HUDClass.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HUDClass_h
#define HUDClass_h

#import "MBProgressHUD.h"

@interface HUDClass: NSObject

/**
 *  toast显示内容
 *
 *  @param text text
 */
+ (void)showHUDWithText:(NSString *)text;

/**
 *  模态显示加载
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)showLoadingHUD;

/**
 *  隐藏模态显示的加载框
 *
 *  @param hud hud
 */
+ (void)hideLoadingHUD:(MBProgressHUD *)hud;

@end


#endif /* HUDClass_h */
