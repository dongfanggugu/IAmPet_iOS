//
//  HomeViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "HomeViewController.h"
#import "PublishViewController.h"
#import "VideoPlayerController.h"
#import "IAmPet-Swift.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, PublishViewControllerDelegate>

@property (nonatomic, weak) TalkCommentCell *cell;

@property (nonatomic, copy) NSString *voiceUrl;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"主页"];
    
    __weak id weakSelf = self;
    [self setNavBarLeft:[UIImage imageNamed:@"icon_person"] click:^{
        [weakSelf clickNavLeft];
    }];
    
    [self setNavBarRight:[UIImage imageNamed:@"icon_edit"] click:^{
        [weakSelf showPulishPage];
    }];
    
    [self initView];
}

- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

/**
 *  点击导航栏左侧按钮
 */
- (void)clickNavLeft
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickNavLeft)])
    {
        [_delegate clickNavLeft];
    }
}

/**
 *  显示发布页面
 */
- (void)showPulishPage
{
    PublishViewController *controller = [PublishViewController new];
    controller.delegate = self;
//    [self showViewController:controller sender:self];
    [self presentViewController:controller animated:YES completion:nil];
}

/**
 *  进入播放视频界面
 *
 *  @param url url
 */
- (void)playVideo:(NSString *)url
{
    VideoPlayerController *controller = [VideoPlayerController new];
    controller.urlStr = url;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate & UITableViewDataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[TalkCommentCell identifier]];
    
    if (!cell)
    {
        cell = [TalkCommentCell cellFromNib];
        
    }
    _cell = cell;
    
    if (0 == indexPath.section % 2)
    {
        cell.commentContent = @"师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅省份省份双氯芬酸分手就分手师傅师傅师傅师傅说";
    }
    else
    {
        cell.commentContent = @"是否顺风顺水方式方法";
    }
    
//    if (0 == indexPath.section)
//    {
//        NSArray *urls = @[
//                          @"https://gss2.bdstatic.com/-fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=9cb489038bd4b31ce4319ce9e6bf4c1a/8c1001e93901213f6e57dc9c54e736d12f2e950e.jpg",
//                          @"http://image.tianjimedia.com/uploadImages/2016/336/11/265T705PHEN4.jpg",
//                          @"http://image.tianjimedia.com/uploadImages/2015/131/29/1OZRZ52WJ9T2.jpg",
//                          @"http://image.tianjimedia.com/uploadImages/2015/131/22/59SG53FU0160.jpg"
//                          ];
//        MediaContent *media = [[MediaContent alloc] initWithType:MediaContent.picture urls:urls];
//        cell.mediaContent = media;
//    }
//    else
//    {
//        
//    NSArray *urls = @[
//            @"http://image.tianjimedia.com/uploadImages/2015/131/22/59SG53FU0160.jpg"
//            ];
//        MediaContent *media = [[MediaContent alloc] initWithType:MediaContent.picture urls:urls];
//        cell.mediaContent = media;
//    }
//    
//    cell.playVideo = ^(NSString *url) {
//        [self playVideo:url];
//    };
//    
//    cell.showPhoto = ^(UIImage *image) {
//        [self showPreviewImage:image];
//    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_cell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkDetailViewController *controller = [TalkDetailViewController new];
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)voiceRecordSuccess:(NSString *)path
{
    self.voiceUrl = path;
    [_tableView reloadData];
}

@end
