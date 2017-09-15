//
//  SideMenuViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/13.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "SideMenuViewController.h"
#import "LeftSideViewController.h"
#import "MiddleSideViewController.h"
#import "BaseNavigationController.h"
#import "RegisterViewController.h"

@interface SideMenuViewController () <MiddleSideViewControllerDelegate>
{
        CGPoint _start, _last;
}

@property (nonatomic, strong) LeftSideViewController *leftViewController;

@property (nonatomic, strong) MiddleSideViewController *middleViewController;

@property (nonatomic, strong) BaseNavigationController *naviMiddle;

@property (nonatomic, assign) BOOL leftHidden;

@end

@implementation SideMenuViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.leftHidden = YES;
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self loadViewController];
}

/**
 *  加载child viewcontroller
 */
- (void)loadViewController
{
    [self loadLeftViewController];
    [self loadMiddleViewController];
}

/**
 *  加载左侧ViewController
 */
- (void)loadLeftViewController
{
    _leftViewController = [[LeftSideViewController alloc] init];
    _leftViewController.view.frame = CGRectMake(- ScreenWidth * 0.6, 0, ScreenWidth * 0.6, ScreenHeight);
    [self.view addSubview:_leftViewController.view];
    [self addChildViewController:_leftViewController];
}

/**
 *  加载中间ViewController
 */
- (void)loadMiddleViewController
{
    _middleViewController = [[MiddleSideViewController alloc] init];
    _middleViewController.delegate = self;
    _naviMiddle = [[BaseNavigationController alloc] initWithRootViewController:_middleViewController];
    
    _naviMiddle.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_naviMiddle.view];
}

- (void)onSlide:(MiddleSideViewController *)controller
{
    if (self.leftHidden)
    {
        [self showLeft];
    }
    else
    {
        [self hideLeft];
    }
}
- (void)onPush:(MiddleSideViewController *)controller
{
    RegisterViewController *con = [[RegisterViewController alloc] init];
    [_middleViewController.navigationController pushViewController:con animated:YES];
    //[_naviMiddle pushViewController:con animated:YES];
}



- (void)showLeft
{
    _middleViewController.view.transform = CGAffineTransformTranslate(_middleViewController.view.transform, ScreenWidth * 0.6, 0);
    _leftViewController.view.transform = CGAffineTransformTranslate(_leftViewController.view.transform, ScreenWidth * 0.6, 0);
    self.leftHidden = NO;
}

- (void)hideLeft
{
    _middleViewController.view.transform = CGAffineTransformTranslate(_middleViewController.view.transform, - ScreenWidth * 0.6, 0);
    _leftViewController.view.transform = CGAffineTransformTranslate(_leftViewController.view.transform, - ScreenWidth * 0.6, 0);
    self.leftHidden = YES;
}

@end
