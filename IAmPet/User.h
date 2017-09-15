//
//  User.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

/**
 *  单例生成对象
 *
 *  @return User instance
 */
+ (instancetype)shareConfig;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *accessToken;

@end
