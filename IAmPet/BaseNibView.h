//
//  BaseNibView.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/12.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNibView : UIView

+ (instancetype)viewFromNib:(NSString *)nib;

@end