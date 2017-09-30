//
//  ImageUtils.h
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/18.
//
//

#ifndef ImageUtils_h
#define ImageUtils_h


#endif /* ImageUtils_h */

@interface ImageUtils : NSObject

/**
 *  按照比例裁剪图片
 *
 *  @param image   image
 *  @param newSize newSize
 *
 *  @return imageWithImage
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/**
 *  裁剪图片
 *
 *  @param image       image
 *  @param borderWidth 边框
 *  @param borderColor 边框颜色
 *
 *  @return new image
 */
+ (UIImage *)circleImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


/**
 *  图片转换为BASE64
 *
 *  @param path path
 *
 *  @return base64 code
 */
+ (NSString *)image2Base64From:(NSString *)path;


@end
