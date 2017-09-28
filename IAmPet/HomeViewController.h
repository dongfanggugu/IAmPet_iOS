//
//  HomeViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseViewController.h"
#import "MainTabBarViewController.h"

@interface HomeViewController : BaseViewController

@property (nonatomic, weak) id<MainTabBarViewControllerDelegate> delegate;

@end
