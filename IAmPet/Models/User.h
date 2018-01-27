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

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, copy) NSString *petsName;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *ownerName;

@property (nonatomic, copy) NSString *ownerTel;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *variety;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *voiceUrl;

@end
