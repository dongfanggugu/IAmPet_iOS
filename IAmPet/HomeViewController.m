//
//  HomeViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "HomeViewController.h"
#import "PublishViewController.h"
#import "IAmPet-Swift.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, PublishViewControllerDelegate>

@property (nonatomic, weak) MyTalkCell *cell;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTalkCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyTalkCell identifier]];
    
    if (!cell)
    {
        cell = [MyTalkCell cellFromNib];
    }
    _cell = cell;
    
    if (0 == indexPath.row % 2)
    {
        cell.talkContent = @"师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅师傅省份省份双氯芬酸分手就分手师傅师傅师傅师傅说";
    }
    else
    {
        cell.talkContent = @"是否顺风顺水方式方法";
    }
    MediaContent *media = nil;
    
    if (nil == self.voiceUrl)
    {
        media = [[MediaContent alloc] initWithType:MediaContent.voice urls:@[@"http"]];
    }
    else
    {
        media = [[MediaContent alloc] initWithType:MediaContent.voice urls:@[self.voiceUrl]];
    }
    cell.mediaContent = media;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_cell cellHeight];
}

- (void)voiceRecordSuccess:(NSString *)path
{
    self.voiceUrl = path;
    [_tableView reloadData];
}

@end
