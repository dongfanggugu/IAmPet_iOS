//
//  LeftSideViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/13.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "LeftSideViewController.h"
#import "PersonCenterView.h"
#import "IAmPet-Swift.h"

@interface LeftSideViewController () <PersonCenterViewDelegate>


@end

@implementation LeftSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    PersonCenterView *view = [PersonCenterView viewFromNib];
    view.delegate = self;
    view.frame = CGRectMake(ScreenWidth * 0.4, 0, ScreenWidth * 0.6, ScreenHeight);
    [self.view addSubview:view];
}


#pragma mark - PersonCenterViewDelegate

- (void)clickView:(PersonCenterView *)view indexPath:(NSIndexPath *)indexPath
{
    PersonHomeViewController *controller = [PersonHomeViewController new];
    controller.personName = @"天空的鱼";
    if (_delegate && [_delegate respondsToSelector:@selector(enterViewController:)])
    {
        [_delegate enterViewController:controller];
    }
}

@end
