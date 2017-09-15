//
//  MiddleSideViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/13.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseTableViewController.h"

@class MiddleSideViewController;

@protocol MiddleSideViewControllerDelegate <NSObject>

- (void)onSlide:(MiddleSideViewController *)controller;

- (void)onPush:(MiddleSideViewController *)controller;

@optional
- (void)onPanGesture:(UIPanGestureRecognizer *)gesture;

@end

@interface MiddleSideViewController : BaseTableViewController

@property (nonatomic, weak) id<MiddleSideViewControllerDelegate> delegate;

@end
