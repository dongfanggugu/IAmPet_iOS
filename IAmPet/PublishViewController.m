//
//  PublishViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/19.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "PublishViewController.h"
#import <TZImagePickerController.h>
#import <RSKImageCropper.h>
#import <Photos/Photos.h>
#import "PhotosView.h"

@interface PublishViewController () <TZImagePickerControllerDelegate, PhotosViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *btnClose;

@property (nonatomic, weak) IBOutlet UIButton *btnPicker;

@property (nonatomic, weak) IBOutlet UIView *viewPhoto;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *photoHeight;

@property (nonatomic, strong) PhotosView *photosView;

- (IBAction)close:(id)sender;

- (IBAction)showPhotoPicker:(id)sender;

@end

@implementation PublishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 *  关闭
 *
 *  @param sender sender
 */
- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showPhotoPicker:(id)sender
{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    
    if (PHAuthorizationStatusRestricted == author || PHAuthorizationStatusDenied == author)
    {
        [self showAlertMsg:@"您已经关闭访问相册权限" positive:^{
            [self jumpToSettings];
        } negative:nil];
        return;
    }
    
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [self presentViewController:controller animated:YES completion:nil];
    
    __weak typeof (self) weakSelf = self;
    [controller setDidFinishPickingPhotosHandle:^(NSArray *arrayImage, NSArray *array, BOOL isOrigin){
        _photosView = [[PhotosView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 32, 0) imageArray:arrayImage max:9];
        _photosView.delegate = self;
        _photosView.viewUpdate = ^(PhotosView *view) {
            weakSelf.photoHeight.constant = view.bounds.size.height;
        };
        [_photosView showPhotos];
        [_viewPhoto addSubview:_photosView];
    }];
}

#pragma mark - PhotosViewDelegate

- (void)addImage:(PhotosView *)photosView
{
    [self showPicker];
}

#pragma mark - 处理图片相关

- (void)showPicker
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self pickPhoto];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self takePhoto];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

/**
 *  从本地选取照片
 */
- (void)pickPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    //设置选择后的图片可以编辑
    picker.allowsEditing = YES;
    
    [self showViewController:picker sender:self];
}

/**
 *  拍摄照片
 */
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        //设置拍照后的图片可以编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self showViewController:picker sender:self];
    }
}

/**
 *  当选择一张图片后调用此方法
 *
 *  @param picker picker
 *  @param info info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //选择的是图片
    if ([type isEqualToString:@"public.image"])
    {
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [_photosView addImage:image];
        
//        CGSize size = CGSizeMake(360, 480);
        
//        image = [ImageUtils imageWithImage:image scaledToSize:size];
        
        //上传到服务器
//        [self uploadRepairImage:image];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


/**
 *  取消图片选择时调用
 *
 *  @param picker picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
