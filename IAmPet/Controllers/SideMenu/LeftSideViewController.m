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
#import "LoginUtils.h"

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
    
    //set basic info
    NSString *petsName = [User shareConfig].petsName;
    if (0 == petsName.length)
    {
        petsName = @"花猫";
    }
    view.lbNickName.text = petsName;
    view.lbAccount.text = [User shareConfig].userName;
}

#pragma mark - PersonCenterViewDelegate

- (void)clickView:(PersonCenterView *)view indexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row)
    {
        PersonInfoViewController *controller = [PersonInfoViewController new];
        if (_delegate && [_delegate respondsToSelector:@selector(enterViewController:)])
        {
            [_delegate enterViewController:controller];
        }
    }
    else if (1 == indexPath.row)
    {
        FavorViewController *controller = [FavorViewController new];
        controller.hidesBottomBarWhenPushed = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(enterViewController:)])
        {
            [_delegate enterViewController:controller];
        }
    }
    else if (2 == indexPath.row)
    {
        CommentsViewController *controller = [CommentsViewController new];
        controller.hidesBottomBarWhenPushed = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(enterViewController:)])
        {
            [_delegate enterViewController:controller];
        }
    }
}

- (void)clickFollow:(PersonCenterView *)view
{
    FollowsViewController *controller = [FollowsViewController new];
    if (_delegate && [_delegate respondsToSelector:@selector(enterViewController:)])
    {
        [_delegate enterViewController:controller];
    }
}

- (void)clickFans:(PersonCenterView *)view
{
    FansViewController *controller = [FansViewController new];
    if (_delegate && [_delegate respondsToSelector:@selector(enterViewController:)])
    {
        [_delegate enterViewController:controller];
    }
}

/**
 *  click logout button
 *
 *  @param view PersonCenterView
 */
- (void)clickLogout:(PersonCenterView *)view
{
    [LoginUtils logout];
}

@end
