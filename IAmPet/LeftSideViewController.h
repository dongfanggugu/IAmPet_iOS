//
//  LeftSideViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/13.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseViewController.h"

@protocol LeftSideViewControllerDelegate <NSObject>

- (void)enterViewController:(UIViewController *)viewController;

@end

@interface LeftSideViewController : BaseViewController

@property (nonatomic, weak) id<LeftSideViewControllerDelegate> delegate;

@end
