//
//  PersonCenterCell.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/18.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "PersonCenterCell.h"

@interface PersonCenterCell()


@end

@implementation PersonCenterCell

+ (instancetype)cellFromNib
{
    return [self cellFromNib:@"PersonCenterCell"];
}

/**
 *  cell  高度
 *
 *  @return cell height
 */
+ (CGFloat)cellHeight
{
    return 60;
}

/**
 *  返回复用标记
 *
 *  @return identifier
 */
+ (NSString *)identifier
{
    return @"person_center_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

@end
