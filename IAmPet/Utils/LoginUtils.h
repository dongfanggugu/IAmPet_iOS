//
//  LoginUtils.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/9/4.
//
//

#import <Foundation/Foundation.h>

@interface LoginUtils : NSObject

/**
 *  登录
 *
 *  @param name     name
 *  @param pwd      password
 *  @param callback call back
 */
+ (void)login:(NSString *)name pwd:(NSString *)pwd success:(void(^)())callback;

/**
 *  退回到登录界面
 */
+ (void)logoutBackTosignIn;

/**
 *  退出登录
 */
+ (void)logout;

@end
