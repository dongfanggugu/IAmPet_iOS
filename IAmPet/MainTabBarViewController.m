//
//  MainTabBarViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "AreaViewController.h"
#import "SearchViewController.h"
#import "ChatViewController.h"

@interface MainTabBarViewController () <HomeViewControllerDelegate>

@end

@implementation MainTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTabBar];
}

/**
 *  初始化底部栏item
 */
- (void)initTabBar
{
    HomeViewController *home = [HomeViewController new];
    home.delegate = self;
    UIViewController *area = [AreaViewController new];
    UIViewController *search = [SearchViewController new];
    UIViewController *chat = [ChatViewController new];
    
    self.viewControllers = @[[self getNavigationController:home],
                             [self getNavigationController:area],
                             [self getNavigationController:search],
                             [self getNavigationController:chat]];
    [self initItem];
}

/**
 *  初始化底部栏图标和说明
 */
- (void)initItem
{
    self.tabBar.tintColor = [UIColor redColor];
    [self.tabBar.items[0] setImage:[UIImage imageNamed:@"icon_main_page"]];
    [self.tabBar.items[1] setImage:[UIImage imageNamed:@"icon_main_page"]];
    [self.tabBar.items[2] setImage:[UIImage imageNamed:@"icon_main_page"]];
    [self.tabBar.items[3] setImage:[UIImage imageNamed:@"icon_main_page"]];
    
    [self.tabBar.items[0] setTitle:@"窝窝"];
    [self.tabBar.items[1] setTitle:@"逛一逛"];
    [self.tabBar.items[2] setTitle:@"嗅一嗅"];
    [self.tabBar.items[3] setTitle:@"聊一聊"];
}

/**
 *  获取导航controller
 *
 *  @return UINavigationController
 */
- (UINavigationController *)getNavigationController:(UIViewController *)rootViewController
{
    return [[BaseNavigationController alloc] initWithRootViewController:rootViewController];
}

- (void)showPersonCenter
{
    if (_mainDelegate && [_mainDelegate respondsToSelector:@selector(showPersonCenter)])
    {
        [_mainDelegate showPersonCenter];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
