//
//  ViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "ViewController.h"
#import "SectionManagerController.h"
#import "RegisterViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
}

/**
 *  初始化视图
 */
- (void)initView
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 41)];
    [btn setBackgroundColor:RGB(Color_Main)];
    btn.center = CGPointMake(self.sWidth / 2, 95);
    [btn setTitle:@"版块管理" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sectionManager) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 41)];
    [btnRegister setBackgroundColor:RGB(Color_Main)];
    btnRegister.center = CGPointMake(self.sWidth / 2, 160);
    [btnRegister setTitle:@"注册/登录" forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(userRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegister];
}

/**
 *  版块管理
 */
- (void)sectionManager
{
    SectionManagerController *controller = [[SectionManagerController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  用户注册、登录
 */
- (void)userRegister
{
    RegisterViewController *controller = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
