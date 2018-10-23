
//
//  LTOfflineDownloadVC.m
//  百思不得姐
//
//  Created by 李霆 on 2018/10/19.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTOfflineDownloadVC.h"
#import "LTNotCacheVC.h"
#import "LTHasCacheVC.h"

@interface LTOfflineDownloadVC ()

@property(nonatomic,strong) JQFMDB * jqdb;
@property(nonatomic,strong) NSArray * dataArr;

@end

@implementation LTOfflineDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"缓存中心";
    [self creatTableview];
}

- (void)openDataBase{
    _jqdb = [JQFMDB shareDatabase];
    [_jqdb open];
    int count = [_jqdb jq_tableItemCount:TableName];
    _dataArr = @[@"20",[NSString stringWithFormat:@"%d",count]];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self openDataBase];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_jqdb close];
}

- (void)creatTableview{
    self.view.backgroundColor = LTCommonBgColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    if (indexPath.row > 0) {
        cell.textLabel.text = @"已缓存列表";
        cell.detailTextLabel.text = _dataArr[indexPath.row];
    }else{
        cell.textLabel.text = @"待缓存列表";
        cell.detailTextLabel.text = _dataArr[indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        LTNotCacheVC * view = [[LTNotCacheVC alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }else{
        LTHasCacheVC * view = [[LTHasCacheVC alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
}

@end
