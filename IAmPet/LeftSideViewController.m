//
//  LeftSideViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/13.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "LeftSideViewController.h"
#import "PersonCenterView.h"

@interface LeftSideViewController ()

@end

@implementation LeftSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    [self initView];
}

- (void)initView
{
//    [self setGradientLayer];
    PersonCenterView *view = [PersonCenterView viewFromNib];
    view.frame = CGRectMake(ScreenWidth * 0.4, 0, ScreenWidth * 0.6, ScreenHeight);
    [self.view addSubview:view];
}




@end
