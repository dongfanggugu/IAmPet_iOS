//
//  PhotoView.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/19.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseNibView.h"

@interface PhotoView : BaseNibView

+ (instancetype)viewFromNib;

@property (nonatomic, strong) UIImage *imgPhoto;

@property (nonatomic, copy) NSMutableDictionary *userInfo;

@property (nonatomic, copy) void(^previewPhoto)(UIImage *image);

@property (nonatomic, copy) void(^addPhoto)();

@property (nonatomic, copy) void(^delPhoto)();

@end
