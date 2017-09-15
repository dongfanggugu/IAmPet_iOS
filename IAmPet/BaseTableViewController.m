//
//  BaseTableViewController.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseTableViewController.h"
#import <MJRefresh.h>

@interface BaseTableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
}

/**
 *  初始化tableView
 */
- (void)initTableView
{
   // self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    __weak id weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"refresh");
        [[weakSelf tableView].mj_header endRefreshing];
        [[weakSelf tableView] reloadData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"load more");
        [[weakSelf tableView] reloadData];
        [[weakSelf tableView].mj_footer endRefreshing];
    }];
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] init];
}

@end
