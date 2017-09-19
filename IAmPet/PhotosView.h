//
//  PhotosView.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/19.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotosView;
@class PhotoView;

@protocol PhotosViewDelegate <NSObject>

- (void)addImage:(PhotosView *)photosView;

@end


@interface PhotosView : UIView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)arrayImage max:(NSInteger)max;

- (void)showPhotos;

- (void)addImage:(UIImage *)image;

@property (nonatomic, copy) NSDictionary *userInfo;

@property (nonatomic, copy) void(^viewUpdate)(PhotosView *view);

@property (nonatomic, weak) id<PhotosViewDelegate> delegate;

@end
