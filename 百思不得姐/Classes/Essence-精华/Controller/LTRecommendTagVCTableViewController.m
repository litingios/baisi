//
//  LTRecommendTagVCTableViewController.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/28.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTRecommendTagVCTableViewController.h"
#import "LTRecommendTagCell.h"
#import "LTRecommendModel.h"

@interface LTRecommendTagVCTableViewController ()
/*** 数据 ****/
@property(nonatomic,strong) NSMutableArray<LTRecommendModel *> *dateArr;


@end

@implementation LTRecommendTagVCTableViewController

/** cell的重用标识 */
static NSString * const LTRecommendTagCellId = @"recommendTag";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐标签";
    self.tableView.rowHeight = 70;
    self.tableView.backgroundColor = LTCommonBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LTRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:LTRecommendTagCellId];
    [self creatData];
}

- (void)creatData{
    __weak typeof(self) weakSelf = self;
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    [Https getDataWithURL:LTCommonURL parameter:params success:^(id data) {
        weakSelf.dateArr = [NSMutableArray arrayWithArray:[LTRecommendModel mj_objectArrayWithKeyValuesArray:data]];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *errorMessage) {
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:LTRecommendTagCellId];
    cell.model = self.dateArr[indexPath.row];
    return cell;
}



@end
