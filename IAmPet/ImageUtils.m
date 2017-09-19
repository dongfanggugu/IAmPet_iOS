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
