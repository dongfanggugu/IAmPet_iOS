//
//  LoginUtils.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/9/4.
//
//

#import "LoginUtils.h"
#import "IAmPet-Swift.h"

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
        [self setBasicInfo:responseObject[@"body"]];
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        
    }];
}

+ (void)setBasicInfo:(NSDictionary *)info
{
    [User shareConfig].userName = info[@"userName"];
    [User shareConfig].accessToken = info[@"token"];
    [User shareConfig].userId = info[@"userId"];
    [User shareConfig].petsName = info[@"petsName"];
}

/**
 *  退回到登录界面
 */
+ (void)logoutBackTosignIn
{
    UIViewController *controller = [LoginViewController new];
    [UIApplication sharedApplication].delegate.window.rootViewController = controller;
}

/**
 *  退出登录
 */
+ (void)logout
{
    [self logoutBackTosignIn];
}

- (void)dealloc
{
    NSLog(@"LoginUtils dealloc");
}

@end
