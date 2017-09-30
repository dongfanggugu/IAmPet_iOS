//
//  ImageUtils.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/18.
//
//

#import <Foundation/Foundation.h>
#import "ImageUtils.h"

@interface ImageUtils()

@end


@implementation ImageUtils

/**
 *  按照比例裁剪图片
 *
 *  @param image   image
 *  @param newSize newSize
 *
 *  @return imageWithImage
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    if([[UIScreen mainScreen] scale] == 2.0)
    {      // @2x
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
    }
    else if([[UIScreen mainScreen] scale] == 3.0)
    {   // @3x ( iPhone 6plus 、iPhone 6s plus)
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 3.0);
    }
    else
    {
        UIGraphicsBeginImageContext(newSize);
    }
    
    CGFloat wScale = newSize.width / image.size.width;
    CGFloat hScale = newSize.height / image.size.height;
    
    CGFloat scale = MAX(wScale, hScale);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width * scale, image.size.height * scale)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  裁剪图片
 *
 *  @param image       image
 *  @param borderWidth 边框
 *  @param borderColor 边框颜色
 *
 *  @return new image
 */
+ (UIImage *)circleImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    CGFloat imageW = image.size.width + 2 * borderWidth;
    CGFloat imageH = image.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //大圆
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;   //大圆半径
    CGFloat centerX = bigRadius;    //圆心
    CGFloat centerY = bigRadius;
    
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI *2, 0);
    CGContextFillPath(ctx);
    
    //小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(ctx);
    
    //画图
    [image drawInRect:CGRectMake(borderWidth, borderWidth, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //结束上下文
    return  newImage;
}

/**
 *  图片转换为BASE64
 *
 *  @param path path
 *
 *  @return base64 code
 */
+ (NSString *)image2Base64From:(NSString *)path
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *base64Code = [data base64Encoding];
    return base64Code;
}

@end
