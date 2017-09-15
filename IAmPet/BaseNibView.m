//
//  BaseNibView.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/12.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseNibView.h"

@implementation BaseNibView

+ (instancetype)viewFromNib:(NSString *)nib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    return array[0];
}

@end
