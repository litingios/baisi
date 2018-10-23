//
//  LTDetailVCViewController.m
//  百思不得姐
//
//  Created by 李霆 on 2018/10/20.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTDetailVCViewController.h"
#import "LTEssenceModel.h"
#import "LTPlCell.h"
#import "LTPlModel.h"

@interface LTDetailVCViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *allData;
@end

@implementation LTDetailVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTableView];
    [self loadNewTopics];
}

- (void)setModel:(LTEssenceModel *)model{
    _model = model;
}

- (void)creatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, iPhone_Height) style:UITableViewStyleGrouped];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LTPlCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LTPlCell class])];
    [self.view addSubview:self.tableView];
}

- (void)loadNewTopics{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = _model.id;
    params[@"hot"] = @"1";
    params[@"per"] = @"100";
    __weak typeof(self) weakSelf = self;
    [Https getDataWithURL:LTCommonURL parameter:params success:^(id data) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        if ([data[@"data"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *comArr = [NSMutableArray arrayWithArray:[LTPlModel mj_objectArrayWithKeyValuesArray:data[@"data"]]];
            NSMutableArray *hotArr = [NSMutableArray arrayWithArray:[LTPlModel mj_objectArrayWithKeyValuesArray:data[@"hot"]]];
            weakSelf.allData = [NSMutableArray array];
            if (comArr.count>0) {
                [weakSelf.allData insertObject:comArr atIndex:0];
            }
            if (hotArr.count>0) {
                [weakSelf.allData insertObject:hotArr atIndex:0];
            }
            [weakSelf.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"数据格式错误"];
        }
    } failure:^(NSError *errorMessage) {
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.allData[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTPlCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LTPlCell class])];
    cell.model = self.allData[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LTPlayVideoDetalVC"];
    if (!headerV) {
        headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, 30)];
        headerV.backgroundColor = LTCommonBgColor;
        UILabel * titleLable = [LTControl createLabelWithFrame:CGRectMake(20*WidthScale, 0, iPhone_Width, 30) Font:15 Text:@""];
        titleLable.textColor = [UIColor grayColor];
        [headerV addSubview:titleLable];
        NSString * str;
        section > 0 ? (str = @"最新评论") : (str = @"最热评论");
        titleLable.text = [NSString stringWithFormat:@"%@ %ld",str,[self.allData[section] count]];
    }
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

@end
