//
//  PersonCenterCell.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/18.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PersonCenterCell : BaseTableViewCell

+ (instancetype)cellFromNib;

@property (nonatomic, weak) IBOutlet UIImageView *ivItem;

@property (nonatomic, weak) IBOutlet UILabel *lbItem;

@end
