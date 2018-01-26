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
#import <MJRefresh.h>

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
    [self getTalks];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *bannerView = [self genBannerView];
    _tableView.tableHeaderView = bannerView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addMJHeader];
    [self addMJFooter];
    
    [self.view addSubview:_tableView];
}

/**
 *  add mjheader
 */
- (void)addMJHeader
{
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getTalks];
    }];
}

/**
 *  add mjfooter
 */
- (void)addMJFooter
{
    __weak typeof(self) weakSelf = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreTalks];
    }];
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
        [self refreshTalks:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

/**
 *  get more talks
 */
- (void)getMoreTalks
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"createTime"] = [_arrayData lastObject][@"createTime"];
    [[HttpClient shareClient] fgPost:URL_TALK_USER parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [self loadMoreTalks:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

/**
 *  refresh the talks
 *
 *  @param response response
 */
- (void)refreshTalks:(id)response
{
    if (_tableView.mj_header.isRefreshing)
    {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
    [self.arrayData removeAllObjects];
    [self.arrayData addObjectsFromArray:response[@"body"]];
    [_tableView reloadData];
}

/**
 *  load more talks
 *
 *  @param response response
 */
- (void)loadMoreTalks:(id)response
{
    NSArray *array = response[@"body"];
    if (_tableView.mj_footer.isRefreshing)
    {
        if (0 == array.count)
        {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [_tableView.mj_footer endRefreshing];
        }
    }
    [self.arrayData addObjectsFromArray:array];
    [_tableView reloadData];
}

- (void)afterRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    });
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTalkCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyTalkCell identifier]];
    if (!cell)
    {
        cell = [MyTalkCell cellFromNib];
    }
    _cell = cell;
    id talkInfo = [[TalkInfo alloc] initWithDictionary:self.arrayData[indexPath.row]];
    [self assignMyTalkCell:cell talk:talkInfo];
    return cell;
}

/**
 *  assign the cell with talkInfo
 *
 *  @param cell cell
 *  @param talk talk info
 */
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
    
    [self showFavorCount:cell count:talk.favorCount];
    [self showCommentCount:cell count:talk.commentCount];
    [self showLikesCount:cell count:talk.likesCount];
}


/**
 *  show favor count in the cell
 *
 *  @param cell  cell
 *  @param count count
 */
- (void)showFavorCount:(MyTalkCell *)cell count:(NSInteger)count
{
    cell.favorCount = [NSString stringWithFormat:@"%ld", count];
}

- (void)showLikesCount:(MyTalkCell *)cell count:(NSInteger)count
{
    cell.likesCount = [NSString stringWithFormat:@"%ld", count];
}

- (void)showCommentCount:(MyTalkCell *)cell count:(NSInteger)count
{
    cell.commentCount = [NSString stringWithFormat:@"%ld", count]; 
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
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
    id talkInfo = [[TalkInfo alloc] initWithDictionary:self.arrayData[indexPath.row]];
    controller.talkInfo = talkInfo;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)voiceRecordSuccess:(NSString *)path
{
    self.voiceUrl = path;
    [_tableView reloadData];
}

@end
