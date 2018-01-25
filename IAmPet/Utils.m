//
//  Utils.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Utils

/**
 *  获取服务器接口
 *
 *  @return server address
 */
+ (NSString *)getServer
{
    return [NSString stringWithFormat:@"%@mobile/", [Utils getIp]];
}

/**
 *  获取id
 *
 *  @return ip
 */
+ (NSString *)getIp
{
//    return @"http://www.chorstar.com:8081/";
//    return @"http://192.168.0.107:8011/";
    return @"http://10.10.4.10:8011/";
}

/**
 *  md5加密
 *
 *  @param str tr
 *
 *  @return result
 */
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

/**
 *  根据rgb值获取颜色
 *
 *  @param RGB RGB value
 *
 *  @return UIColor
 */
+ (UIColor *)getColorByRGB:(NSString *)RGB
{

    if (RGB.length != 7)
    {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }

    if (![RGB hasPrefix:@"#"])
    {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }

    NSString *colorString = [RGB substringFromIndex:1];

    NSRange range;
    range.location = 0;
    range.length = 2;

    NSString *red = [colorString substringWithRange:range];

    range.location = 2;
    NSString *green = [colorString substringWithRange:range];

    range.location = 4;
    NSString *blue = [colorString substringWithRange:range];

    unsigned int r, g, b;
    [[NSScanner scannerWithString:red] scanHexInt:&r];
    [[NSScanner scannerWithString:green] scanHexInt:&g];
    [[NSScanner scannerWithString:blue] scanHexInt:&b];
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}

/**
 *  图片转换为base64码
 *
 *  @param image image
 *
 *  @return base64 code
 */
+ (NSString *)image2Base64From:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *base64Code = [data base64Encoding];
    return base64Code;
}

/**
 *  格式化日期
 *
 *  @param date      日期
 *  @param formatter 格式化字符串
 *
 *  @return date string
 */
+ (NSString *)date:(NSDate *)date formatter:(NSString *)formatter
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:formatter];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

/**
 *  把今天格式化输出
 *
 *  @param format 格式化字符串
 *
 *  @return today string
 */
+ (NSString *)today:(NSString *)format
{
    return [self date:[NSDate date] formatter:format];
}

/**
 *  根据格式化字符串返回NSDate对象
 *
 *  @param dateStr date string
 *  @param format  format
 *
 *  @return NDdate
 */
+ (NSDate *)string2Date:(NSString *)dateStr format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    return date;
}

/**
 *  获取当前时间
 *
 *  @return current time
 */
+ (NSString *)getCurrentTime
{
    return [self today:@"yyyy-MM-dd HH:mm:ss"];
}

/**
 *  删除制定路径文件
 *
 *  @param path path
 */
+ (void)delFile:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!blHave)
    {
        NSLog(@"不存在");
        return;
    }
    else
    {
        NSLog(@"存在");
        BOOL blDele = [fileManager removeItemAtPath:path error:nil];
        if (blDele)
        {
            NSLog(@"删除成功");
        }
        else
        {
            NSLog(@"删除失败");
        }
    }
}

@end
