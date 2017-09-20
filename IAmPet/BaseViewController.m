//
//  BaseViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>

@interface BaseViewController ()
{
    CGRect _oldFrame;    //保存图片原来的大小
    CGRect _largeFrame;
}

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(Color_Window);
    // Do any additional setup after loading the view.
    [self initNavBar];
}

/**
 *  获取屏幕宽度
 *
 *  @return screen width
 */
- (CGFloat)sWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

/**
 *  获取屏幕高度
 *
 *  @return screen height
 */
- (CGFloat)sHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

/**
 *  显示只有有一个按钮的
 *
 *  @param msg     msg
 *  @param dismiss dismiss callback
 *
 *  @return UIAlertController
 */
- (UIAlertController *)showAlertMsg:(NSString *)msg dismiss:(void(^)())dismiss
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (dismiss)
        {
            dismiss();
        }
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    return controller;
}

/**
 *  显示有确认和取消的弹出框
 *
 *  @param msg      msg
 *  @param positive positive
 *  @param negative negative
 *
 *  @return UIAlertController
 */
- (UIAlertController *)showAlertMsg:(NSString *)msg positive:(void(^)())positive negative:(void(^)())negative
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (positive)
        {
            positive();
        }
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (negative)
        {
            negative();
        }
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    return controller;
}

/**
 *  设置导航栏标题
 *
 *  @param title navigationbar title
 */
- (void)setNavTitle:(NSString *)title
{
    if (!self.navigationController)
    {
        return;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.title = title;
}

/**
 *  初始化导航栏
 */
- (void)initNavBar
{
    if (!self.navigationController)
    {
        return;
    }
    
    self.navigationController.navigationBar.translucent = NO;
    CAGradientLayer  *layer = [CAGradientLayer layer];
    layer.colors = @[(__bridge id)RGB(Color_Main2).CGColor, (__bridge id)RGB(Color_Main3).CGColor, (__bridge id)RGB(Color_Main1).CGColor];
    layer.locations = @[@0.2, @0.6];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    layer.frame = CGRectMake(0, 0, ScreenWidth, 64);
    [self.navigationController.navigationBar.subviews[0].layer addSublayer:layer];
}

/**
 *  设置导航栏左侧按钮和回调
 *
 *  @param image     image
 *  @param clickLeft click callback
 */
- (void)setNavBarLeft:(UIImage *)image click:(void(^)())clickLeft
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    btn.tintColor = [UIColor whiteColor];
    [btn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    if (clickLeft)
    {
        objc_setAssociatedObject(btn, @"click_callback", clickLeft, OBJC_ASSOCIATION_COPY);
        [btn addTarget:self action:@selector(clickNavCallback:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  设置导航栏右侧按钮和回调
 *
 *  @param image     image
 *  @param clickRight click callback
 */
- (void)setNavBarRight:(UIImage *)image click:(void(^)())clickRight
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    if (clickRight)
    {
        objc_setAssociatedObject(btn, @"click_callback", clickRight, OBJC_ASSOCIATION_COPY);
        [btn addTarget:self action:@selector(clickNavCallback:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  点击导航栏按钮回调
 *
 *  @param sender sender
 */
- (void)clickNavCallback:(id)sender
{
    void(^callback)() = objc_getAssociatedObject(sender, @"click_callback");
    callback();
}


/**
 *  跳转到应用的设置界面
 */
- (void)jumpToSettings
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)dealloc
{
    NSLog(@"dealloc: %@", [self class]);
}

#pragma makr - 图片预览

/**
 *  显示预览图
 *
 *  @param image image
 */
- (void)showPreviewImage:(UIImage *)image
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
//    _oldFrame = image.size;
    
    backgroundView.backgroundColor=[UIColor blackColor];
    
    backgroundView.alpha = 1;
    
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleW = (ScreenWidth - 32) / oldWidth;
    CGFloat scaleH = (ScreenHeight - 64 -32) / oldHeight;
    CGFloat scale = MIN(scaleW, scaleH);
    
    CGRect newFrame = CGRectMake(0, 0, oldWidth * scale, oldHeight * scale);
    
    UIImageView *ivNew =[[UIImageView alloc]initWithFrame:newFrame];
    
    ivNew.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    
    ivNew.backgroundColor = [UIColor whiteColor];
    
    ivNew.image = image;
    
    ivNew.tag = 1;
    
    [backgroundView addSubview:ivNew];
    
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    
    [backgroundView addGestureRecognizer:tap];
    
    ivNew.multipleTouchEnabled = YES;
    
    ivNew.userInteractionEnabled = YES;
    
    [self addGestureRecognizerToView:ivNew];
}

/**
 *  隐藏预览
 *
 *  @param tap tap
 */
- (void)hideImage:(UITapGestureRecognizer*)tap
{
    UIView *backgroundView = tap.view;
    [backgroundView removeFromSuperview];
}

/**
 *  添加所有手势
 *
 *  @param view view
 */
- (void)addGestureRecognizerToView:(UIView *)view
{
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    //拖动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

/**
 *  处理缩放手势
 *
 *  @param pinchGestureRecognizer pinchGestureRecognizer
 */
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        
        if (view.frame.size.width < _oldFrame.size.width)
        {
            NSInteger x = (NSInteger) (view.frame.origin.x / ScreenWidth);
            
            CGRect frame = CGRectMake(x * ScreenWidth, _oldFrame.origin.y, _oldFrame.size.width, _oldFrame.size.height);
            view.frame = frame;
        }
        pinchGestureRecognizer.scale = 1;
    }
}

/**
 *  处理拖拉手势
 *
 *  @param panGestureRecognizer panGestureRecognizer
 */
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint) {view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

@end
