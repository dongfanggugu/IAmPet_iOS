//
//  SideMenuViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/13.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "SideMenuViewController.h"
#import "LeftSideViewController.h"
#import "MainTabBarViewController.h"
#import "BaseNavigationController.h"
#import "RegisterViewController.h"

@interface SideMenuViewController() <MainTabBarViewControllerDelegate, LeftSideViewControllerDelegate>
{
        CGPoint _start, _last;
}

//@property (nonatomic, strong) LeftSideViewController *leftViewController;
@property (nonatomic, strong) LeftSideViewController *leftViewController;

@property (nonatomic, strong) MainTabBarViewController *middleViewController;

@property (nonatomic, strong) BaseNavigationController *naviMiddle;

@property (nonatomic, assign) BOOL leftHidden;

@property (nonatomic, strong) UIView *viewSurface;

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
    _leftViewController = [LeftSideViewController new];
    _leftViewController.delegate = self;
    _leftViewController.view.frame = CGRectMake(- ScreenWidth , 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:_leftViewController.view];
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
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        _middleViewController.view.transform = CGAffineTransformTranslate(_middleViewController.view.transform, ScreenWidth * 0.6, 0);
        _leftViewController.view.transform = CGAffineTransformTranslate(_leftViewController.view.transform, ScreenWidth * 0.6, 0);
        weakSelf.leftHidden = NO;
    }];
}

- (void)hideLeft:(void(^)())complete
{
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        _middleViewController.view.transform = CGAffineTransformTranslate(_middleViewController.view.transform, - ScreenWidth * 0.6, 0);
        _leftViewController.view.transform = CGAffineTransformTranslate(_leftViewController.view.transform, - ScreenWidth * 0.6, 0);
        weakSelf.leftHidden = YES;
         [self removeSurface];
    } completion:^(BOOL finished){
        if (finished && complete)
        {
            complete();
        }
    }];
}

/**
 *  隐藏左侧
 */
- (void)hideLeft
{
    [self hideLeft:nil];
}

#pragma mark - MainTabBarViewControllerDelegate

- (void)clickNavLeft
{
    if (self.leftHidden)
    {
        [self showLeft];
        [self addSurface];
    }
    else
    {
        [self hideLeft:nil];
    }
}

- (UIView *)viewSurface
{
    if (!_viewSurface)
    {
        _viewSurface = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _viewSurface.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    }
    
    return _viewSurface;
}

/**
 *  去除蒙版
 */
- (void)removeSurface
{
    if (self.viewSurface.superview)
    {
        [self.viewSurface removeFromSuperview];
    }
}

/**
 *  添加蒙版
 */
- (void)addSurface
{
    [self.middleViewController.view addSubview:self.viewSurface];
    self.viewSurface.userInteractionEnabled = YES;
    [self.viewSurface addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLeft:)]];
}

- (void)enterViewController:(UIViewController *)viewController
{
    [self hideLeft:^{
    }];
    [_middleViewController enterViewController:viewController];
}

@end
