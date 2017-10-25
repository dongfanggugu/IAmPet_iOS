//
//  User.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "User.h"

@implementation User

/**
 *  单例生成对象
 *
 *  @return User instance
 */
+ (instancetype)shareConfig
{
    static User *user = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        user = [[User alloc] init];
    });
    
    return user;
}

- (NSString *)userId
{
    if (!_userId)
    {
        return @"";
    }
    return _userId;
}

@end
