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
#import "SearchViewController.h"
#import "ChatViewController.h"
#import "IAmPet-Swift.h"

@interface MainTabBarViewController () <HomeViewControllerDelegate, AreaViewControllerDelegate, SearchViewControllerDelegate, ChatViewControllerDelegate>

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
    
    AreaViewController *area = [AreaViewController new];
    area.delegate = self;
    
    SearchViewController *search = [SearchViewController new];
    search.delegate = self;
    
    ChatViewController *chat = [ChatViewController new];
    chat.delegate = self;
    
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
    self.tabBar.tintColor = RGB(Color_Main1);
    [self.tabBar.items[0] setImage:[UIImage imageNamed:@"icon_main_page"]];
    [self.tabBar.items[1] setImage:[UIImage imageNamed:@"icon_shop"]];
    [self.tabBar.items[2] setImage:[UIImage imageNamed:@"icon_search_mainpage"]];
    [self.tabBar.items[3] setImage:[UIImage imageNamed:@"chat"]];
    
    [self.tabBar.items[0] setTitle:@"主页"];
    [self.tabBar.items[1] setTitle:@"广场"];
    [self.tabBar.items[2] setTitle:@"搜索"];
    [self.tabBar.items[3] setTitle:@"私信"];
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

#pragma mark - HomeViewControllerDelegate

- (void)clickNavLeft
{
    if (_mainDelegate && [_mainDelegate respondsToSelector:@selector(clickNavLeft)])
    {
        [_mainDelegate clickNavLeft];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
