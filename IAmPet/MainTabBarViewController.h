//
//  MainTabBarViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseTabBarController.h"

@protocol MainTabBarViewControllerDelegate <NSObject>

- (void)clickNavLeft;

@end

@interface MainTabBarViewController : BaseTabBarController

- (void)enterViewController:(UIViewController *)controller;

@property (nonatomic, weak) id<MainTabBarViewControllerDelegate> mainDelegate;

@end
