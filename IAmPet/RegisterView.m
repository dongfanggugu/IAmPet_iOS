//
//  RegisterView.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/12.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "RegisterView.h"

@interface RegisterView()

@property (nonatomic, weak) IBOutlet UITextField *tfUserName;

@property (nonatomic, weak) IBOutlet UITextField *tfPwd;

@property (nonatomic, weak) IBOutlet UIButton *btnRegister;

@property (nonatomic, weak) IBOutlet UIButton *btnLogin;

@property (nonatomic, weak) IBOutlet UIButton *btnLogout;

@property (nonatomic, weak) IBOutlet UIButton *btnHidden;

@property (nonatomic, assign) BOOL pwdHidden;

@end

@implementation RegisterView

+ (instancetype)viewFromNib
{
    return [super viewFromNib:@"RegisterView"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
   
    //注册
    _btnRegister.layer.masksToBounds = YES;
    _btnRegister.layer.cornerRadius = 5;
    _btnRegister.backgroundColor = RGB(Color_Main);
    [_btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRegister addTarget:self action:@selector(clickRegister) forControlEvents:UIControlEventTouchUpInside];
    
    //登录
    _btnLogin.layer.masksToBounds = YES;
    _btnLogin.layer.cornerRadius = 5;
    _btnLogin.backgroundColor = RGB(Color_Main);
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLogin addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    
    //退出登录
    _btnLogout.layer.masksToBounds = YES;
    _btnLogout.layer.cornerRadius = 5;
    _btnLogout.backgroundColor = RGB(Color_Main);
    [_btnLogout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLogout addTarget:self action:@selector(clickLogout) forControlEvents:UIControlEventTouchUpInside];
    
    //密码不可见
    self.pwdHidden = NO;
    
    //密码可见控制
    [_btnHidden addTarget:self action:@selector(changeHidden) forControlEvents:UIControlEventTouchUpInside];
    
    //设置键盘
    _tfUserName.keyboardType = UIKeyboardTypeAlphabet;
    _tfPwd.keyboardType = UIKeyboardTypeAlphabet;
}

/**
 *  点击注册按钮
 */
- (void)clickRegister
{
    NSString *user = _tfUserName.text;
    NSString *pwd = _tfPwd.text;
    
    if (_delegate && [_delegate respondsToSelector:@selector(onRegister:user:password:)])
    {
        [_delegate onRegister:self user:user password:pwd];
    }
}

/**
 *  点击登录按钮
 */
- (void)clickLogin
{
    NSString *user = _tfUserName.text;
    NSString *pwd = _tfPwd.text;
    
    if (_delegate && [_delegate respondsToSelector:@selector(onLogin:user:password:)])
    {
        [_delegate onLogin:self user:user password:pwd];
    }
}

/**
 *  点击退出登录按钮
 */
- (void)clickLogout
{
    if (_delegate && [_delegate respondsToSelector:@selector(onLogout:)])
    {
        [_delegate onLogout:self];
    }
}

/**
 *  处理密码是否可见
 *
 *  @param pwdHidden pwdHidden
 */
- (void)setPwdHidden:(BOOL)pwdHidden
{
    _pwdHidden = pwdHidden;
    if (pwdHidden)
    {
        _tfPwd.secureTextEntry = NO;
    }
    else
    {
        _tfPwd.secureTextEntry = YES;
    }
}

/**
 *  密码可见控制
 */
- (void)changeHidden
{
    if (self.pwdHidden)
    {
        self.pwdHidden = NO;
        [_btnHidden setTitle:@"隐藏密码" forState:UIControlStateNormal];
    }
    else
    {
        self.pwdHidden = YES;
        [_btnHidden setTitle:@"显示密码" forState:UIControlStateNormal];
    }
}


@end
