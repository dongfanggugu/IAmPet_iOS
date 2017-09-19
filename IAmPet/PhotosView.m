//
//  PhotosView.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/19.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "PhotosView.h"
#import "PhotoView.h"

@interface PhotosView ()

@property (nonatomic, copy) NSMutableArray *arrayImage;

@property (nonatomic, copy) NSMutableArray *arrayPhotoView;

@property (nonatomic, assign) NSInteger max;

@end

@implementation PhotosView

- (NSMutableArray *)arrayPhotoView
{
    if (!_arrayPhotoView)
    {
        _arrayPhotoView = [NSMutableArray array];
    }
    
    return _arrayPhotoView;
}

- (NSMutableArray *)arrayImage
{
    if (!_arrayImage)
    {
        _arrayImage = [NSMutableArray array];
    }
    
    return _arrayImage;
}

/**
 *  根据图片数组生成view，按照传入的宽度计算显示方形的边长，根据图片的数量，计算出view的高度，上下有16point的margin
 *
 *  @param frame      frame
 *  @param arrayImage array image
 *
 *  @return view
 */
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)arrayImage max:(NSInteger)max
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.arrayImage addObjectsFromArray:arrayImage];
        self.max = max;
    }
    
    return self;
}

/**
 *  添加图片
 */
- (void)showPhotos
{
    if (0 == self.arrayImage.count)
    {
        self.frame = CGRectZero;
    }
    else
    {
        if (self.arrayImage.count > self.max)
        {
            NSRange range = NSMakeRange(self.max, self.arrayImage.count - 1);
            [self.arrayImage removeObjectsInRange:range];
        }
        
        NSInteger width = self.frame.size.width / 3;
        
        NSInteger rows = ceil((self.arrayImage.count + 1) / 3.0);
        
        if (self.arrayImage.count == self.max)
        {
            rows = ceil(self.arrayImage.count / 3.0);
        }
        
        NSInteger height = width * rows + 32;
        
        CGRect newFrame = self.frame;
        newFrame.size.height = height;
        self.frame = newFrame;
        
        for (int i = 0; i < self.arrayImage.count; i++)
        {
            PhotoView *photoView = [PhotoView viewFromNib];
            photoView.imgPhoto = self.arrayImage[i];
            
            NSInteger row = i / 3;
            NSInteger column = i % 3;
            
            CGFloat x = width * column;
            CGFloat y = 16 + width * row;
            
            photoView.frame = CGRectMake(x, y, width, width);
            photoView.userInfo[@"index"] = [NSNumber numberWithInt:i];
            
            __weak typeof (photoView) weakView = photoView;
            photoView.delPhoto = ^{
                [self imageDeleteListener:weakView];
            };
            
            [self addSubview:photoView];
        }
        
        if (self.arrayImage.count < self.max)
        {
            PhotoView *photoView = [PhotoView viewFromNib];
            
            NSInteger row = self.arrayImage.count / 3;
            NSInteger column = self.arrayImage.count % 3;
            
            CGFloat x = width * column;
            CGFloat y = 16 + width * row;
            
            photoView.frame = CGRectMake(x, y, width, width);
            
            photoView.userInfo[@"index"] = [NSNumber numberWithInteger:self.arrayImage.count];
            
            photoView.addPhoto = ^{
                [self imageAddListener];
            };
            [self addSubview:photoView];
        }
    }
    
    if (_viewUpdate)
    {
        _viewUpdate(self);
    }
}

/**
 *  处理删除动作
 *
 *  @param photoView photoView
 */
- (void)imageDeleteListener:(PhotoView *)photoView
{
    NSInteger index = [photoView.userInfo[@"index"] integerValue];
    NSLog(@"index: %ld", index);
    [self.arrayImage removeObjectAtIndex:index];
    
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self showPhotos];
}

/**
 *  点击添加回调
 */
- (void)imageAddListener
{
    if (_delegate && [_delegate respondsToSelector:@selector(addImage:)])
    {
        [_delegate addImage:self];
    }
}

/**
 *  添加图片
 *
 *  @param image image
 */
- (void)addImage:(UIImage *)image
{
    if (self.arrayImage.count == self.max)
    {
        return;
    }
    
    [self.arrayImage addObject:image];
    [self showPhotos];
}

@end
