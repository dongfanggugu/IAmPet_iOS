//
//  SideMenuViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/13.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "SideMenuViewController.h"
#import "LeftSideViewController.h"
//#import "MiddleSideViewController.h"
#import "MainTabBarViewController.h"
#import "BaseNavigationController.h"
#import "RegisterViewController.h"

@interface SideMenuViewController() <MainTabBarViewControllerDelegate>
{
        CGPoint _start, _last;
}

@property (nonatomic, strong) LeftSideViewController *leftViewController;

@property (nonatomic, strong) MainTabBarViewController *middleViewController;

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
    _middleViewController = [[MainTabBarViewController alloc] init];
    _middleViewController.mainDelegate = self;
    _middleViewController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [self.view addSubview:_middleViewController.view];
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

- (void)showPersonCenter
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

@end
