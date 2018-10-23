//
//  LTNotCacheVC.m
//  百思不得姐
//
//  Created by 李霆 on 2018/10/19.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTNotCacheVC.h"
#import "LTNewViewController.h"
#import "LTEssenceModel.h"
#import "LTDownSecondCell.h"
#import "LTPlayVideoDetalVC.h"

@interface LTNotCacheVC ()

/*** 帖子数据 ****/
@property(nonatomic,strong) NSMutableArray<LTEssenceModel *> *topArr;
/*** 本地已缓存数据 ****/
@property(nonatomic,strong) NSMutableArray<LTEssenceModel *> *cacheArr;
/** maxtime : 用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;
/** 声明这个方法的目的 : 为了能够使用点语法的智能提示 */
- (NSString *)aParam;
/*** 数据库 ****/
@property(nonatomic,strong) JQFMDB * jqdb;

@end

@implementation LTNotCacheVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待缓存列表";
    [self creatTableView];
    [self setupRefresh];
    [self loadNewTopics];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self openDataBase];
}

/*** 开启数据库 ****/
- (void)openDataBase{
    _jqdb = [JQFMDB shareDatabase];
    [_jqdb open];
    [_jqdb jq_createTable:TableName dicOrModel:[LTEssenceModel new]];
    self.cacheArr = [NSMutableArray arrayWithArray:[self->_jqdb jq_lookupTable:TableName dicOrModel:[LTEssenceModel new] whereFormat:nil]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_jqdb close];
}

#pragma mark - 仅仅是为了消除编译器发出的警告 : type方法没有实现
- (LTModelType)type {
    return 0;
}

- (void)setupRefresh{
    self.tableView.mj_header = [LTTRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [LTRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (NSString *)aParam{
    if (self.parentViewController.class == [LTNewViewController class]) {
        return @"newlist";
    }
    return @"list";
}

#pragma mark ------  请求数据  ------
- (void)loadNewTopics{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.aParam;
    params[@"c"] = @"data";
    params[@"type"] = @"41";
    
    __weak typeof(self) weakSelf = self;
    [Https getDataWithURL:LTCommonURL parameter:params success:^(id data) {
        if ([data[@"list"] isKindOfClass:[NSArray class]]) {
            // 存储maxtime(方便用来加载下一页数据)
            weakSelf.maxtime = data[@"info"][@"maxtime"];
            weakSelf.topArr = [LTEssenceModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
            for (NSInteger i=0; i<weakSelf.cacheArr.count; i++) {
                LTEssenceModel *dic = weakSelf.cacheArr[i];
                for (NSInteger j = 0; j<weakSelf.topArr.count; j++) {
                    LTEssenceModel *datadic = weakSelf.topArr[j];
                    if (datadic.id==dic.id) {
                        datadic.isDownLoad = YES;
                        [self.topArr replaceObjectAtIndex:j withObject:datadic];
                    }
                }
            }
            [weakSelf.tableView reloadData];
            // 让[刷新控件]结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
        }else{
            [SVProgressHUD showErrorWithStatus:@"数据格式错误"];
        }
    } failure:^(NSError *errorMessage) {
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
    }];
}

- (void)loadMoreTopics{
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.aParam;
    params[@"c"] = @"data";
    params[@"maxtime"] = self.maxtime;
    params[@"type"] = @"41";
    
    __weak typeof(self) weakSelf = self;
    [Https getDataWithURL:LTCommonURL parameter:params success:^(id data) {
        if ([data[@"list"] isKindOfClass:[NSArray class]]) {
            // 存储maxtime(方便用来加载下一页数据)
            weakSelf.maxtime = data[@"info"][@"maxtime"];
            NSArray<LTEssenceModel *> * moreArr = [LTEssenceModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
            [weakSelf.topArr addObjectsFromArray:moreArr];
            for (NSInteger i=0; i<weakSelf.cacheArr.count; i++) {
                LTEssenceModel *dic = weakSelf.cacheArr[i];
                for (NSInteger j = 0; j<weakSelf.topArr.count; j++) {
                    LTEssenceModel *datadic = weakSelf.topArr[j];
                    if (datadic.id==dic.id) {
                        datadic.isDownLoad = YES;
                        [self.topArr replaceObjectAtIndex:j withObject:datadic];
                    }
                }
            }
            [weakSelf.tableView reloadData];
            // 让[刷新控件]结束刷新
            [weakSelf.tableView.mj_footer endRefreshing];
        }else{
            [SVProgressHUD showErrorWithStatus:@"数据格式错误"];
        }
    } failure:^(NSError *errorMessage) {
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络加载失败"];
    }];
}

- (void)creatTableView{
    self.view.backgroundColor = LTCommonBgColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.rowHeight = 90;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LTDownSecondCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LTDownSecondCell class])];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTEssenceModel * model = self.topArr[indexPath.row];
    LTDownSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LTDownSecondCell class])];
    cell.model = model;
    cell.downBlock = ^{
        int count = 0;
        self.cacheArr = [NSMutableArray arrayWithArray:[self->_jqdb jq_lookupTable:TableName dicOrModel:[LTEssenceModel new] whereFormat:nil]];
        for (LTEssenceModel * Fmodel in self.cacheArr) {
            if (Fmodel.id == model.id) {
                count ++;
                [CXAlert showMessage:@"数据已存在" Time:0];
                return ;
            }
        }
        if (count == 0) {
            /*** 插入model ****/
            if ([self->_jqdb jq_insertTable:TableName dicOrModel:model]) {
                [CXAlert showMessage:@"插入数据成功" Time:0];
            }
        }
        model.isDownLoad = YES;
        [self.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LTPlayVideoDetalVC * view = [[LTPlayVideoDetalVC alloc]init];
    view.hidesBottomBarWhenPushed = YES;
    view.videoPath = self.topArr[indexPath.row].videouri;
    view.ID = self.topArr[indexPath.row].id;
    [self.navigationController pushViewController:view animated:YES];
}


@end
