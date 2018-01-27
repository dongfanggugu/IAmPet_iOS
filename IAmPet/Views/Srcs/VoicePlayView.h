//
//  VoicePlayView.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/20.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseNibView.h"

@class VoicePlayView;

@protocol VoicePlayViewDelegate <NSObject>

@optional
- (void)closePlayView:(VoicePlayView *)playView;

@end

@interface VoicePlayView : BaseNibView

+ (instancetype)viewFromNib;

@property (nonatomic, copy) NSString *voicePath;

@property (nonatomic, weak) id<VoicePlayViewDelegate> delegate;

@property (nonatomic, assign) BOOL showMode;

@end
