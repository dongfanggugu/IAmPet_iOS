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

@property (nonatomic, weak) MyTalkCell *cell;

@property (nonatomic, copy) NSString *voiceUrl;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *arrayData;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getTalks];
}

- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *bannerView = [self genBannerView];
    _tableView.tableHeaderView = bannerView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

- (UIView *)genBannerView
{
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 2)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:bannerView.frame];
    imageView.image = [self getBannerImage:bannerView.frame];
    [bannerView addSubview:imageView];
    return bannerView;
}

- (UIImage *)getBannerImage:(CGRect)frame
{
    UIImage *image = [UIImage imageNamed:@"icon_icon.jpg"];
    image = [ImageUtils imageWithImage:image scaledToSize:frame.size];
    
    return image;
}

/**
 *  get talks from server
 */
- (void)getTalks
{
    [[HttpClient shareClient] fgPost:URL_TALK_USER parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self addTalks:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)addTalks:(id)response
{
    [self.arrayData removeAllObjects];
    [self.arrayData addObjectsFromArray:response[@"body"]];
    [_tableView reloadData];
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
 *  initial arrayData
 *
 *  @return arrayData
 */
- (NSMutableArray *)arrayData
{
    if (!_arrayData)
    {
        _arrayData = [NSMutableArray array];
    }
    
    return _arrayData;
}

/**
 *  显示发布页面
 */
- (void)showPulishPage
{
    PublishViewController *controller = [PublishViewController new];
    controller.delegate = self;
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
    return self.arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTalkCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyTalkCell identifier]];
    
    if (!cell)
    {
        cell = [MyTalkCell cellFromNib];
        
    }
    _cell = cell;
    
    id talkInfo = [[TalkInfo alloc] initWithDictionary:self.arrayData[indexPath.section]];
    [self assignMyTalkCell:cell talk:talkInfo];
    
    
    return cell;
}

- (void)assignMyTalkCell:(MyTalkCell *)cell talk:(TalkInfo *)talk
{
    cell.talkContent = talk.content;
    cell.mediaContent = talk.mediaContent;
    __weak typeof(self) weakSelf = self;
    cell.playVideo = ^(NSString *url) {
        [weakSelf playVideo:url];
    };
    
    cell.showPhoto = ^(UIImage *image) {
        [weakSelf showPreviewImage:image];
    };
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
