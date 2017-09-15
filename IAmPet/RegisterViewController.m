//
//  RegisterViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/12.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"

@interface RegisterViewController()<RegisterViewDelegate>

@property (nonatomic, copy) NSString *userId;

@end

@implementation RegisterViewController

- (void)loadView
{
    RegisterView *view = [RegisterView viewFromNib];
    view.delegate = self;
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  RegisterViewDelegate
 *
 *  @param view RegisterView
 *  @param user user
 *  @param pwd  pwd
 */
- (void)onRegister:(RegisterView *)view user:(NSString *)user password:(NSString *)pwd
{
    if (0 == user.length)
    {
        [self showAlertMsg:@"用户名不能为空" dismiss:nil];
        return;
    }
    
    if (0 == pwd.length)
    {
        [self showAlertMsg:@"密码不能为空" dismiss:nil];
        return;
    }
    
    if ([user containsString:@" "])
    {
        [self showAlertMsg:@"用户名不能包含空格" dismiss:nil];
        return;
    }
    
    if ([pwd containsString:@" "])
    {
        [self showAlertMsg:@"密码不能包含空格" dismiss:nil];
        return;
    }
    [self userRegister:user password:pwd];
}

/**
 *  登录
 *
 *  @param view RegisterView
 *  @param user user
 *  @param pwd  pwd
 */
- (void)onLogin:(RegisterView *)view user:(NSString *)user password:(NSString *)pwd
{
    if (0 == user.length)
    {
        [self showAlertMsg:@"用户名不能为空" dismiss:nil];
        return;
    }
    
    if (0 == pwd.length)
    {
        [self showAlertMsg:@"密码不能为空" dismiss:nil];
        return;
    }
    
    if ([user containsString:@" "])
    {
        [self showAlertMsg:@"用户名不能包含空格" dismiss:nil];
        return;
    }
    
    if ([pwd containsString:@" "])
    {
        [self showAlertMsg:@"密码不能包含空格" dismiss:nil];
        return;
    }
    [self userLogin:user password:pwd];
}

/**
 *  退出登录
 *
 *  @param view RegisterView
 */
- (void)onLogout:(RegisterView *)view
{
    if (0 == self.userId)
    {
        return;
    }
    
    [self userLogout];
}


/**
 *  用户注册
 *
 *  @param user user
 *  @param pwd  password
 */
- (void)userRegister:(NSString *)user password:(NSString *)pwd
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = user;
    params[@"password"] = [Utils md5:pwd];
    
    [[HttpClient shareClient] fgPost:URL_REGISTER parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [self showAlertMsg:@"新用户注册成功,返回到登录页面" dismiss:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showAlertMsg:error.domain dismiss:nil];
    }];
}

/**
 *  用户登录
 *
 *  @param user user
 *  @param pwd  pwd
 */
- (void)userLogin:(NSString *)user password:(NSString *)pwd
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"] = user;
    params[@"password"] = [Utils md5:pwd];
    
    [[HttpClient shareClient] fgPost:URL_LOGIN parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.userId = responseObject[@"body"][@"id"];
        [self showAlertMsg:@"登录成功" dismiss:^{
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showAlertMsg:error.domain dismiss:nil];
    }];
}

/**
 *  退出登录
 */
- (void)userLogout
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = self.userId;
    
    [[HttpClient shareClient] fgPost:URL_LOGOUT parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [self showAlertMsg:@"退出登录成功" dismiss:^{
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showAlertMsg:error.domain dismiss:nil];
    }];

}

@end
