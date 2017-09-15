//
//  HomeViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"窝窝";
    self.navigationController.navigationBar.barTintColor = [UIColor yellowColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    [btn addTarget:self action:@selector(clickLeft) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

/**
 *  点击导航栏左侧按钮
 */
- (void)clickLeft
{
    if (_delegate && [_delegate respondsToSelector:@selector(showPersonCenter)])
    {
        [_delegate showPersonCenter];
    }
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
