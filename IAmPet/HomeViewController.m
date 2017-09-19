//
//  HomeViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "HomeViewController.h"
#import "PublishViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"主页"];
    
    __weak id weakSelf = self;
    [self setNavBarLeft:[UIImage imageNamed:@"icon_person"] click:^{
        [weakSelf clickNavLeft];
    }];
    
    [self setNavBarRight:[UIImage imageNamed:@"icon_edit"] click:^{
        [weakSelf showPulishPage];
    }];
}

/**
 *  点击导航栏左侧按钮
 */
- (void)clickNavLeft
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickNavLeft)])
    {
        [_delegate clickNavLeft];
    }
}

/**
 *  显示发布页面
 */
- (void)showPulishPage
{
    PublishViewController *controller = [PublishViewController new];
//    [self showViewController:controller sender:self];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
