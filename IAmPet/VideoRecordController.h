//
//  VideoRecordController.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef VideoRecordController_h
#define VideoRecordController_h

#import "BaseViewController.h"


@protocol VideoRecordControllerDelegate <NSObject>

- (void)onRecordSuccess:(NSString *)path;

@end

@interface VideoRecordController : BaseViewController

@property (copy, nonatomic) NSString *alarmId;

@property (weak, nonatomic) id<VideoRecordControllerDelegate> delegate;

@end


#endif /* VideoRecordController_h */
