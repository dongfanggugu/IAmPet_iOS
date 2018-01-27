//
//  HttpClient.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef HttpClient_h
#define HttpClient_h

#import <AFNetworking.h>

@interface HttpClient : AFHTTPSessionManager

+ (instancetype)shareClient;

/**
 *  前台请求
 *
 *  @param url        url
 *  @param parameters parameters body
 *  @param success    success callback
 *  @param failure    failure callback
 */
- (void)fgPost:(NSString *)url parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error)) failure;

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
        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)uploadImage:(NSData *)data url:(NSString *)url success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)uploadAudio:(NSData *)data url:(NSString *)url success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)uploadVideo:(NSData *)data url:(NSString *)url success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

#endif /* HttpClient_h */
