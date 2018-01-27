//
//  SectionManagerController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "SectionManagerController.h"

@interface SectionManagerController ()

@end

@implementation SectionManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getSections];
}

- (void)getSections
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"zhang";
    params[@"password"] = @"1111111";
    
    [[HttpClient shareClient] fgPost:@"register" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
    }];
}

@end
