//
//  VoiceRecordView.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/20.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseNibView.h"

@interface VoiceRecordView : BaseNibView

+ (instancetype)viewFromNib;

/**
 *  启动录音
 */
- (void)startRecord;

/**
 *  结束录音，并返回录音文件路径
 *
 *  @return record path
 */
- (NSString *)stopRecord;

@end
