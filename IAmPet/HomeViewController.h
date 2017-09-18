//
//  HomeViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseViewController.h"

@protocol HomeViewControllerDelegate <NSObject>

- (void)clickNavLeft;

@end

@interface HomeViewController : BaseViewController

@property (nonatomic, weak) id<HomeViewControllerDelegate> delegate;

@end
