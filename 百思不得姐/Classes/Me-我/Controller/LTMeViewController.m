//
//  LTMeViewController.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/13.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTMeViewController.h"
#import "LTMeCell.h"
#import "LTMeFootView.h"
#import "LTSettingViewController.h"
#import "MainViewController.h"
#import "AutoplayVC.h"
#import "LTOfflineDownloadVC.h"

@interface LTMeViewController ()

@end

@implementation LTMeViewController

- (instancetype)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*** 设置导航栏 ****/
    [self setupNav];
    /*** 设置tableView ****/
    [self setupTable];
    
    [Https getDataWithURL:@"http://api.tool.chexun.com/pc/downBrandInfo.do" parameter:nil success:^(id data) {
        
    } failure:nil];
}

- (void)setupTable{
    self.view.backgroundColor = LTCommonBgColor;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = LTMargin;
    /*** 设置内边距 ****/
    self.tableView.contentInset = UIEdgeInsetsMake(LTMargin-25, 0, 0, 0);
    /*** 设置尾视图 ****/
    self.tableView.tableFooterView = [[LTMeFootView alloc]init];
}

- (void)setupNav{
    self.navigationItem.title = @"我的";
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
}

/*** 设置 ****/
- (void)settingClick{
    LTSettingViewController * view = [[LTSettingViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

/*** 夜间模式 ****/
- (void)moonClick{
    MainViewController * view = [[MainViewController alloc]init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark <======  tableview代理方法  ======>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTMeCell * cell = [LTMeCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"publish-audio"];
    } else if(indexPath.section == 1){
        cell.textLabel.text = @"离线下载";
        cell.imageView.image = nil;
    }else{
        cell.textLabel.text = @"视频自动播放";
        cell.imageView.image = nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*HeightScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        AutoplayVC * view = [[AutoplayVC alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }else if(indexPath.section == 1){
        LTOfflineDownloadVC * view = [[LTOfflineDownloadVC alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
}


@end
