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

- (void)setUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"user_name"];
}

- (NSString *)userName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
}

- (void)setAccessToken:(NSString *)accessToken
{
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"access_token"];
}

- (NSString *)accessToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
}

- (void)setUserId:(NSString *)userId
{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"user_id"];
}
- (NSString *)userId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
}

- (void)setPetsName:(NSString *)petsName
{
    [[NSUserDefaults standardUserDefaults] setObject:petsName forKey:@"pets_name"];
}

- (NSString *)petsName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pets_name"];
}

- (void)setBirthday:(NSString *)birthday
{
    [[NSUserDefaults standardUserDefaults] setObject:birthday forKey:@"birthday"];
}

- (NSString *)birthday
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"birthday"];
}

- (void)setOwnerName:(NSString *)ownerName
{
    [[NSUserDefaults standardUserDefaults] setObject:ownerName forKey:@"owner_name"];
}

- (NSString *)ownerName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"owner_name"];
}

- (void)setOwnerTel:(NSString *)ownerTel
{
    [[NSUserDefaults standardUserDefaults] setObject:ownerTel forKey:@"owner_tel"];
}

- (NSString *)ownerTel
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"owner_tel"];
}

- (void)setCategory:(NSString *)category
{
    [[NSUserDefaults standardUserDefaults] setObject:category forKey:@"category"];
}

- (NSString *)category
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"category"];
}

- (void)setVariety:(NSString *)variety
{
    [[NSUserDefaults standardUserDefaults] setObject:variety forKey:@"variety"];
}

- (NSString *)variety
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"variety"];
}

- (void)setIntroduce:(NSString *)introduce
{
    [[NSUserDefaults standardUserDefaults] setObject:introduce forKey:@"introduce"];
}

- (NSString *)introduce
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"introduce"];
}

- (void)setImgUrl:(NSString *)imgUrl
{
    [[NSUserDefaults standardUserDefaults] setObject:imgUrl forKey:@"img_url"];
}

- (NSString *)imgUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"img_url"];
}

- (void)setSex:(NSInteger)sex
{
    NSNumber *number = [NSNumber numberWithInteger:sex];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"sex"];
}

- (NSInteger)sex
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    return number.integerValue;
}

- (void)setVoiceUrl:(NSString *)voiceUrl
{
    [[NSUserDefaults standardUserDefaults] setObject:voiceUrl forKey:@"voice_url"];
}

- (NSString *)voiceUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"voice_url"];
}

@end
