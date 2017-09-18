//
//  AreaViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseViewController.h"

@protocol AreaViewControllerDelegate <NSObject>

- (void)clickNavLeft;

@end

@interface AreaViewController : BaseViewController

@property (nonatomic, weak) id<AreaViewControllerDelegate> delegate;

@end
