//
//  BaseTableViewCell.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/18.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

+ (instancetype)cellFromNib:(NSString *)nib;

+ (CGFloat)cellHeight;

+ (NSString *)identifier;

@end
