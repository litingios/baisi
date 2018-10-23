//
//  LTSettingViewController.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/18.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTSettingViewController.h"
#import "LTClearCell.h"
#import "LTMeCell.h"

@interface LTSettingViewController ()

@end

@implementation LTSettingViewController

- (instancetype)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LTCommonBgColor;
    /*** 设置内边距 ****/
    self.tableView.contentInset = UIEdgeInsetsMake(LTMargin-25, 0, 0, 0);
    self.tableView.sectionFooterHeight = 5;
    self.tableView.sectionHeaderHeight = LTMargin;
    self.navigationItem.title = @"设置";
    /*** 获取沙盒路径 ****/
    //    LTLog(@"%@",NSHomeDirectory());
    /*** 只是可以算出NSHomeDirectory文件夹下面的library下的Caches下面的default文件夹的内存 ****/
    /*** 对于自己缓存的东西,非SDWebImage下的东西计算不出来,所以还得自己进行计算 ****/
    //    [[SDImageCache sharedImageCache].getSize]
    LTLog(@"%lu",(unsigned long)[SDImageCache sharedImageCache].getSize);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 10;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LTClearCell * cell = [LTClearCell cellWithTableView:tableView];
        return cell;
    }else{
        LTMeCell * cell = [LTMeCell cellWithTableView:tableView];
        cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld组  第%ld行",(long)indexPath.section,(long)indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"publish-audio"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LTLog(@"哈哈哈哈");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*HeightScale;
}


@end
