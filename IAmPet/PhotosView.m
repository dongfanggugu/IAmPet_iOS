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
{
    CGPoint _buttonPoint;
    CGPoint startPoint;
    
    NSInteger beginPos;
    NSInteger endPos;
}

//@property (nonatomic, copy) NSMutableArray *arrayImage;

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

//- (NSMutableArray *)arrayImage
//{
//    if (!_arrayImage)
//    {
//        _arrayImage = [NSMutableArray array];
//    }
//    
//    return _arrayImage;
//}

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
        [self batchPhotoViewGenerator:arrayImage];
        self.max = max;
    }
    
    return self;
}

/**
 *  根据图片生成PhotoView
 *
 *  @param image image
 */
- (PhotoView *)photoGenerator:(UIImage *)image
{
    PhotoView *photoView = [PhotoView viewFromNib];
    photoView.imgPhoto = image;
    
    return photoView;
}

/**
 *  批量生成PhotoView
 *
 *  @param arrayImage array image
 */
- (void)batchPhotoViewGenerator:(NSArray *)arrayImage
{
    for (NSInteger i = 0; i < arrayImage.count; i++)
    {
        PhotoView *photoView = [self photoGenerator:arrayImage[i]];
        photoView.userInfo[@"index"] = [NSNumber numberWithInteger:i];
        [self.arrayPhotoView addObject:photoView];
    }
}

/**
 *  添加图片
 */
- (void)showPhotos
{
    if (0 == self.arrayPhotoView.count)
    {
        self.frame = CGRectZero;
    }
    else
    {
        if (self.arrayPhotoView.count > self.max)
        {
            NSRange range = NSMakeRange(self.max, self.arrayPhotoView.count - 1);
            [self.arrayPhotoView removeObjectsInRange:range];
        }
        
        [self cleanSubViews];
        
        NSInteger width = self.frame.size.width / 3;
        NSInteger rows = ceil((self.arrayPhotoView.count + 1) / 3.0);
        
        if (self.arrayPhotoView.count == self.max)
        {
            rows = ceil(self.arrayPhotoView.count / 3.0);
        }
        
        NSInteger height = width * rows + 32;
        
        CGRect newFrame = self.frame;
        newFrame.size.height = height;
        self.frame = newFrame;
        
        for (int i = 0; i < self.arrayPhotoView.count; i++)
        {
//            PhotoView *photoView = [PhotoView viewFromNib];
//            photoView.imgPhoto = self.arrayImage[i];
            
            PhotoView *photoView = self.arrayPhotoView[i];
            
            NSInteger row = i / 3;
            NSInteger column = i % 3;
            
            CGFloat x = width * column;
            CGFloat y = 16 + width * row;
            
            photoView.frame = CGRectMake(x, y, width, width);
//            photoView.userInfo[@"index"] = [NSNumber numberWithInt:i];
            
            __weak typeof (photoView) weakView = photoView;
            photoView.delPhoto = ^{
                [self imageDeleteListener:weakView];
            };
            
            [self imageAddLongPress:photoView];
//            [self.arrayPhotoView addObject:photoView];
            [self addSubview:photoView];
        }
        
        if (self.arrayPhotoView.count < self.max)
        {
            PhotoView *photoView = [PhotoView viewFromNib];
            
            NSInteger row = self.arrayPhotoView.count / 3;
            NSInteger column = self.arrayPhotoView.count % 3;
            
            CGFloat x = width * column;
            CGFloat y = 16 + width * row;
            
            photoView.frame = CGRectMake(x, y, width, width);
            
            
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
    [self.arrayPhotoView removeObject:photoView];
//    NSInteger index = [photoView.userInfo[@"index"] integerValue];
//    [self.arrayPhotoView removeObjectAtIndex:index];
    
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
 *  添加长按手势
 *
 *  @param photoView photoView
 */
- (void)imageAddLongPress:(PhotoView *)photoView
{
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    gesture.minimumPressDuration = 0.5;
    
    photoView.userInteractionEnabled = YES;
    [photoView addGestureRecognizer:gesture];
}

/**
 *  添加图片
 *
 *  @param image image
 */
- (void)addImage:(UIImage *)image
{
    if (self.arrayPhotoView.count == self.max)
    {
        return;
    }
    
    [self.arrayPhotoView addObject:[self photoGenerator:image]];
    
    [self showPhotos];
}

/**
 *  删除子view
 */
- (void)cleanSubViews
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

/**
 *  长按图片
 *
 *  @param sender sender
 */
- (void)longPressGesture:(UILongPressGestureRecognizer *)sender
{
    PhotoView *view = (PhotoView *)sender.view;
    
    [self bringSubviewToFront:view];
    
    if (UIGestureRecognizerStateBegan == sender.state)
    {
        startPoint = [sender locationInView:sender.view];
        beginPos = [self.arrayPhotoView indexOfObject:view];
        _buttonPoint = view.center;
        
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeScale(1.1, 1.1);
            view.alpha = 0.7;
        }];
    }
    else if (UIGestureRecognizerStateChanged == sender.state)
    {
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x - startPoint.x;
        CGFloat deltaY = newPoint.y - startPoint.y;
        view.center = CGPointMake(view.center.x + deltaX, view.center.y + deltaY);
        
        NSInteger fromIndex = [self.arrayPhotoView indexOfObject:view];
        NSInteger toIndex = [self judgeMoveByPoint:view.center moveView:view];
        
        if (toIndex < 0)
        {
            return;
        }
        else
        {
            [self changePhotoView:fromIndex to:toIndex];
        }
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformIdentity;
            view.alpha = 1;
            view.center = _buttonPoint;
        }];
    }
}

/**
 *  获取移动到的photoView的index
 *
 *  @param point     point
 *  @param photoView poitView
 *
 *  @return index
 */
- (NSInteger)judgeMoveByPoint:(CGPoint)point moveView:(PhotoView *)photoView
{
    for (PhotoView *view in self.arrayPhotoView)
    {
        if (photoView != view && CGRectContainsPoint(view.frame, point))
        {
            return [view.userInfo[@"index"] integerValue];
        }
    }
    
    return -1;
}

/**
 *  改变顺序
 *
 *  @param from 需要改变的index
 *  @param to   插入的index
 */
- (void)changePhotoView:(NSInteger)from to:(NSInteger)to
{
    if (from == to)
    {
        return;
    }
    
    //缓存当前要占据的位置
    CGPoint temp = [self.arrayPhotoView[to] center];
    
    //当向前面移动时，新位置和原来位置之间的view向后移，改变center和相关的index值
    if (from > to)
    {
        //位置向后移
        for (NSInteger i = to; i < from; i++)
        {
            PhotoView *view = self.arrayPhotoView[i];
            view.userInfo[@"index"] = [NSNumber numberWithInteger:i + 1];
            
            if (i == from - 1)
            {
                view.center = _buttonPoint;
            }
            else
            {
                view.center = [self.arrayPhotoView[i + 1] center];
            }
        }
        PhotoView *fromView = self.arrayPhotoView[from];
        fromView.userInfo[@"index"] = [NSNumber numberWithInteger:to];
        
        //改变在数组中位置
        for (NSInteger i = from; i > to; i--)
        {
            self.arrayPhotoView[i] = self.arrayPhotoView[i - 1];
        }
        
        //改变图片位置
        
        self.arrayPhotoView[to] = fromView;
    }
    else
    {
        //位置向前移
        for (NSInteger i = to; i > from; i--)
        {
            PhotoView *view = self.arrayPhotoView[i];
            view.userInfo[@"index"] = [NSNumber numberWithInteger:i - 1];
            
            if (i == from + 1)
            {
                view.center = _buttonPoint;
            }
            else
            {
                view.center = [self.arrayPhotoView[i - 1] center];
            }
        }
        
        PhotoView *fromView = self.arrayPhotoView[from];
        fromView.userInfo[@"index"] = [NSNumber numberWithInteger:to];
        
        //改变在数组中的位置
        for (NSInteger i = from; i < to; i++)
        {
            self.arrayPhotoView[i] = self.arrayPhotoView[i + 1];
        }
        self.arrayPhotoView[to] = fromView;
    }
    
    //保存当期应该的位置
    _buttonPoint = temp;
}

@end
