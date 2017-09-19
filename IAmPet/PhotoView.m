//
//  PhotoView.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/19.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView ()

@property (nonatomic, weak) IBOutlet UIImageView *ivPhoto;

@property (nonatomic, weak) IBOutlet UIButton *btnClose;

- (IBAction)close:(id)sender;

@end

@implementation PhotoView

+ (instancetype)viewFromNib
{
    return [self viewFromNib:@"PhotoView"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //初始化
    _ivPhoto.image = [UIImage imageNamed:@"icon_add_photo"];
    _btnClose.hidden = YES;
    
    _ivPhoto.userInteractionEnabled = YES;
    [_ivPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPhoto:)]];
}

/**
 *  设置图片
 *
 *  @param imgPhoto imgPhoto
 */
- (void)setImgPhoto:(UIImage *)imgPhoto
{
    _imgPhoto = imgPhoto;
    
    //裁剪后显示
    CGRect frame = self.frame;
    UIImage *image = [ImageUtils imageWithImage:imgPhoto scaledToSize:frame.size];
    _ivPhoto.image = image;
    _btnClose.hidden = NO;
}

/**
 *  点击右侧关闭
 *
 *  @param sender sender
 */
- (IBAction)close:(id)sender
{
    _ivPhoto.image = [UIImage imageNamed:@"icon_add_photo"];
    _btnClose.hidden = YES;
    
    if (_delPhoto)
    {
        _delPhoto();
    }
}

/**
 *  点击View时操作
 *
 *  @param gesture gesture
 */
- (void)touchPhoto:(UIGestureRecognizer *)gesture
{
    if (_btnClose.hidden)
    {
        if (_addPhoto)
        {
            _addPhoto();
        }
    }
    else
    {
        if (_previewPhoto)
        {
            _previewPhoto(self.imgPhoto);
        }
    }
}

/**
 *  userInfo set方法
 *
 *  @return userInfo
 */
- (NSMutableDictionary *)userInfo
{
    if (!_userInfo)
    {
        _userInfo = [NSMutableDictionary dictionary];
    }
    return _userInfo;
}

@end
