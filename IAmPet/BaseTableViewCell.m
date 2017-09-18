//
//  BaseTableViewCell.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/18.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

+ (instancetype)cellFromNib:(NSString *)nib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 44;
}

+ (NSString *)identifier
{
    return @"cell";
}

@end
