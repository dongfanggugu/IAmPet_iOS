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
//    head[@"userId"] = @"8afbe900-ae93-11e7-8893-37ba8c9451b9";
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
        NSInteger rspCode = [head[@"code"] integerValue];
        NSString *rspMsg = head[@"msg"];
        
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

- (void)uploadImage:(NSData *)data url:(NSString *)url success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self uploadFile:data mimeType:@"image/jpg" url:url success:success failure:failure];
}

- (void)uploadAudio:(NSData *)data url:(NSString *)url success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self uploadFile:data mimeType:@"audio/mpeg" url:url success:success failure:failure];
}

- (void)uploadVideo:(NSData *)data url:(NSString *)url success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self uploadFile:data mimeType:@"video/mpeg" url:url success:success failure:failure];
}

- (void)uploadFile:(NSData *)data mimeType:(NSString *)mimeType url:(NSString *)url success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"file" fileName:@"fileName" mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"%.2lf", progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if (success)
        {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (failure)
        {
            failure(task, error);
        }
    }];
}
@end
