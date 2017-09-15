//
//  SectionInfo.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "SectionInfo.h"

@implementation SectionInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        self.sectionId = dictionary[@"id"];
    }
    return self;
}

@end
