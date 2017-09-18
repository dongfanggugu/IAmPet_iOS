//
//  PersonCenterView.m
//  IAmPet
//
//  Created by changhaozhang on 2017/9/18.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "PersonCenterView.h"
#import "PersonCenterCell.h"

@interface PersonCenterView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIButton *btnLogout;

@end

@implementation PersonCenterView

+ (instancetype)viewFromNib
{
    return [self viewFromNib:@"PersonCenterView"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //处理背景色
    [self setGradientLayer];
    _tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //处理UITableView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

/**
 *  设置渐变色背景
 */
- (void)setGradientLayer
{
    CAGradientLayer  *layer = [CAGradientLayer layer];
    layer.colors = @[(__bridge id)RGB(Color_Main2).CGColor, (__bridge id)RGB(Color_Main3).CGColor, (__bridge id)RGB(Color_Main1).CGColor];
    layer.locations = @[@0.2, @0.6];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    layer.frame = CGRectMake(0 , 0, ScreenWidth * 0.6, ScreenHeight);
    
    [self.layer insertSublayer:layer atIndex:0];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 3;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        PersonCenterCell *cell = [PersonCenterCell cellFromNib];
        
        cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
        
        if (0 == indexPath.row)
        {
            cell.ivItem.image = [UIImage imageNamed:@"icon_person"];
            cell.lbItem.text = @"个人资料";
        }
        else if (1 == indexPath.row)
        {
            cell.ivItem.image = [UIImage imageNamed:@"icon_want_normal"];
            cell.lbItem.text = @"我的收藏";
        }
        else if (2 == indexPath.row)
        {
            cell.ivItem.image = [UIImage imageNamed:@"icon_message"];
            cell.lbItem.text = @"个人评论";
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 23, 120, 20)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        
        if (0 == indexPath.row)
        {
            label.text = @"设置和隐私";
        }
        else
        {
            label.text = @"帮助中心";
        }
        
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PersonCenterCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    line.backgroundColor = RGB(Color_Line);
    
    return line;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
