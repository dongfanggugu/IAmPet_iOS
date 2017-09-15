//
//  LoginUtils.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/9/4.
//
//

#import "LoginUtils.h"

@implementation LoginUtils

+ (void)login:(NSString *)name pwd:(NSString *)pwd success:(void(^)())callback
{
    if (0 == name.length || 0 == pwd.length)
    {
        return;
    }
    //设置参数
    NSMutableDictionary *paras = [NSMutableDictionary dictionaryWithCapacity:1];
    [paras setObject:name forKey:@"userName"];
    [paras setObject:[Utils md5:pwd] forKey:@"password"];
    
    //请求服务器
    [[HttpClient shareClient] fgPost:@"/login" parameters:paras success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

/**
 *  退回到登录界面
 */
+ (void)logoutBackTosignIn
{
}

/**
 *  退出登录
 */
+ (void)logout
{
}

- (void)dealloc
{
    NSLog(@"LoginUtils dealloc");
}

@end
