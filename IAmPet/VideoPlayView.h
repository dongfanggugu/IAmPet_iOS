//
//  VideoPlayView.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/21.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseNibView.h"

@interface VideoPlayView : BaseNibView

+ (instancetype)viewFromNib;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, copy) void(^clickPlay)();

@property (nonatomic, copy) void(^clickDel)();

@end
