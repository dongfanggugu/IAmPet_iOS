//
//  HttpClient.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "HUDClass.h"

@interface HttpClient ()

@end

@implementation HttpClient

/**
 *  初始化http请求
 *
 *  @return HttpClient instance
 */
+ (instancetype)shareClient
{
    static HttpClient *shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:[Utils getServer]]];
        shareClient.requestSerializer = [AFJSONRequestSerializer serializer];
        shareClient.responseSerializer = [AFJSONResponseSerializer serializer];
        shareClient.responseSerializer.acceptableContentTypes
                = [shareClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    });

    return shareClient;
}

/**
 *  前台请求
 *
 *  @param url        url
 *  @param parameters parameters body
 *  @param success    success callback
 *  @param failure    failure callback
 */
- (void)fgPost:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *head = [NSMutableDictionary dictionary];
    head[@"userId"] = [User shareConfig].userId;
    [self background:NO post:url head:head body:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

/**
 *  后台请求
 *
 *  @param url        url
 *  @param parameters parameters body
 *  @param success    success callback
 *  @param failure    failure callback
 */
- (void)bgPost:(NSString *)url parameters:(id)parameters
        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *head = [NSMutableDictionary dictionary];
    head[@"userId"] = [User shareConfig].userId;
    [self background:YES post:url head:head body:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
}

/**
 *  请求网络
 *
 *  @param url     url
 *  @param head    head
 *  @param body    body
 *  @param success success callback
 *  @param failure failure callback
 */
- (void)background:(BOOL)bg post:(NSString *)url head:(id)head body:(id)body
           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    if (head)
    {
        param[@"head"] = head;
    }
    
    if (body)
    {
        param[@"body"] = body;
    }
    
    MBProgressHUD *hud = nil;
    if (!bg)
    {
        hud = [HUDClass showLoadingHUD];
    }
    
    [self POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (hud)
        {
            [HUDClass hideLoadingHUD:hud];
        }
        
        NSDictionary *head = responseObject[@"head"];
        NSInteger rspCode = [head[@"rspCode"] integerValue];
        NSString *rspMsg = head[@"rspMsg"];
        
        NSLog(@"response: %@", responseObject);
        
        //根据返回code进行处理
        if (1 == rspCode)
        {
            success(task, responseObject);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:rspMsg code:rspCode userInfo:nil];
            if (failure)
            {
                failure(task, error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (hud)
        {
            [HUDClass hideLoadingHUD:hud];
        }
        NSLog(@"post error: %@", error);
        
        if (!bg)
        {
            [HUDClass showHUDWithText:@"网络连接错误,请稍后再试"];
        }
    }];
}

@end
