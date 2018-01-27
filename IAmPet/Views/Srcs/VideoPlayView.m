//
//  VideoPlayView.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/21.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "VideoPlayView.h"

@interface VideoPlayView ()

@end

@implementation VideoPlayView

+ (instancetype)viewFromNib
{
    return [self viewFromNib:@"VideoPlayView"];
}

- (IBAction)clickPlay:(id)sender
{
    if (_clickPlay)
    {
        _clickPlay();
    }
}

/**
 *  从view上移除
 *
 *  @param sender sender
 */
- (IBAction)delVideo:(id)sender
{
    if (self.superview)
    {
        [self removeFromSuperview];
    }
    
    if (_clickDel)
    {
        _clickDel();
    }
}

@end
