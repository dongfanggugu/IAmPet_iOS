//
//  PersonCenterView.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/18.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseNibView.h"

@interface PersonCenterView : BaseNibView

+ (instancetype)viewFromNib;

@property (nonatomic, weak) IBOutlet UIImageView *ivPerson;

@property (nonatomic, weak) IBOutlet UILabel *lbNickName;

@property (nonatomic, weak) IBOutlet UILabel *lbAccount;

@property (nonatomic, weak) IBOutlet UILabel *lbFans;

@property (nonatomic, weak) IBOutlet UILabel *lbFollow;

@end
