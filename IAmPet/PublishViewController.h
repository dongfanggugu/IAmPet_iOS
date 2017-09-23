//
//  PublishViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/19.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseViewController.h"

@protocol PublishViewControllerDelegate <NSObject>

- (void)voiceRecordSuccess:(NSString *)path;

@end

@interface PublishViewController : BaseViewController

@property (nonatomic, weak) id<PublishViewControllerDelegate> delegate;

@end
