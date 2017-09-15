//
//  Utils.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/11.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

@interface Utils : NSObject

/**
 *  获取服务器接口
 *
 *  @return server address
 */
+ (NSString *)getServer;

/**
 *  md5加密
 *
 *  @param str tr
 *
 *  @return result
 */
+ (NSString *)md5:(NSString *)str;

/**
 *  根据rgb值获取颜色
 *
 *  @param RGB RGB value
 *
 *  @return UIColor
 */
+ (UIColor *)getColorByRGB:(NSString *)RGB;


/**
 图片转换为base64

 @return base64 code
 */
+ (NSString *)image2Base64From:(UIImage *)image;

/**
 *  把今天格式化输出
 *
 *  @param format 格式化字符串
 *
 *  @return today string
 */
+ (NSString *)today:(NSString *)format;

/**
 *  格式化日期
 *
 *  @param date      日期
 *  @param formatter 格式化字符串
 *
 *  @return date string
 */
+ (NSString *)date:(NSDate *)date formatter:(NSString *)formatter;

/**
 *  根据格式化字符串返回NSDate对象
 *
 *  @param dateStr date string
 *  @param format  format
 *
 *  @return NDdate
 */
+ (NSDate *)string2Date:(NSString *)dateStr format:(NSString *)format;

/**
 *  获取当前时间
 *
 *  @return current time
 */
+ (NSString *)getCurrentTime;

@end


#endif /* Utils_h */
