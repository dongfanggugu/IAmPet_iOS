//
//  ChatViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseViewController.h"

@protocol ChatViewControllerDelegate <NSObject>

- (void)clickNavLeft;

@end

@interface ChatViewController : BaseViewController

@property (nonatomic, weak) id<ChatViewControllerDelegate> delegate;

@end
