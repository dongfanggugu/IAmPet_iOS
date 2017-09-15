//
//  MainTabBarViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseTabBarController.h"

@protocol MainTabBarViewControllerDelegate <NSObject>

- (void)showPersonCenter;

@end

@interface MainTabBarViewController : BaseTabBarController

@property (nonatomic, weak) id<MainTabBarViewControllerDelegate> mainDelegate;

@end
