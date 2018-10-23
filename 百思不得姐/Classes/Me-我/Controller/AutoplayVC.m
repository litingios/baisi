//
//  AutoplayVC.m
//  百思不得姐
//
//  Created by 李霆 on 2018/10/17.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "AutoplayVC.h"
#import "JPVideoPlayerKit.h"
#import "JPVideoPlayerWeiBoEqualHeightCell.h"
#import "JPVideoPlayerDetailViewController.h"
#import "JPVideoPlayerWeiBoUnequalHeightCell.h"
#import "LTEssenceModel.h"
#import "LTNewViewController.h"

@interface AutoplayVC ()<JPTableViewPlayVideoDelegate>

/*** 帖子数据 ****/
@property(nonatomic,strong) NSMutableArray<LTEssenceModel *> *topArr;
/** maxtime : 用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;
/** 声明这个方法的目的 : 为了能够使用点语法的智能提示 */
- (NSString *)aParam;

@end

@implementation AutoplayVC
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

/*** 释放cell停止播放 ****/
- (void)dealloc {
    if (self.tableView.jp_playingVideoCell) {
        [self.tableView.jp_playingVideoCell.jp_videoPlayView jp_stopPlay];
    }
}

- (instancetype)initWithPlayStrategyType:(JPScrollPlayStrategyType)playStrategyType {
    self = [super init];
    if(self){
        _scrollPlayStrategyType = playStrategyType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LTCommonBgColor;
    [self setup];
    [self setupRefresh];
    [self loadNewTopics];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height -= self.tabBarController.tabBar.bounds.size.height;
    self.tableView.jp_tableViewVisibleFrame = tableViewFrame;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView jp_handleCellUnreachableTypeInVisibleCellsAfterReloadData];
    [self.tableView jp_playVideoInVisibleCellsIfNeed];
    
    // 用来防止选中 cell push 到下个控制器时, tableView 再次调用 scrollViewDidScroll 方法, 造成 playingVideoCell 被置空.
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 用来防止选中 cell push 到下个控制器时, tableView 再次调用 scrollViewDidScroll 方法, 造成 playingVideoCell 被置空.
    self.tableView.delegate = nil;
}


#pragma mark - Data Srouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self.topArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = indexPath.row % 2 == 0 ? NSStringFromClass([JPVideoPlayerWeiBoEqualHeightCell class]) :
    NSStringFromClass([JPVideoPlayerWeiBoUnequalHeightCell class]);
    if(self.scrollPlayStrategyType == JPScrollPlayStrategyTypeBestCell){
        reuseIdentifier = NSStringFromClass([JPVideoPlayerWeiBoEqualHeightCell class]);
    }
    JPVideoPlayerWeiBoEqualHeightCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.jp_videoURL = [NSURL URLWithString:self.topArr[indexPath.row].videouri];
    cell.jp_videoPlayView = cell.videoPlayView;
    cell.model = self.topArr[indexPath.row];
    [tableView jp_handleCellUnreachableTypeForCell:cell
                                       atIndexPath:indexPath];
    return cell;
}


#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JPVideoPlayerDetailViewController *single = [JPVideoPlayerDetailViewController new];
    single.hidesBottomBarWhenPushed = YES;
    [self presentViewController:single animated:NO completion:nil];
    JPVideoPlayerWeiBoEqualHeightCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    single.videoPath = cell.jp_videoURL.absoluteString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LTEssenceModel * model = self.topArr[indexPath.row];
    return (iPhone_Width-10)*model.height/model.width+10;
}

/**
 * Called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
 * 松手时已经静止, 只会调用scrollViewDidEndDragging
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.tableView jp_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

/**
 * Called on tableView is static after finger up if the user dragged and tableView is scrolling.
 * 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.tableView jp_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView jp_scrollViewDidScroll];
}


#pragma mark - JPTableViewPlayVideoDelegate

- (void)tableView:(UITableView *)tableView willPlayVideoOnCell:(UITableViewCell *)cell {
    [cell.jp_videoPlayView jp_resumeMutePlayWithURL:cell.jp_videoURL
                                 bufferingIndicator:nil
                                       progressView:nil
                                      configuration:nil];
}


#pragma mark - Setup

- (void)setup{
    self.title = @"微博";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JPVideoPlayerWeiBoEqualHeightCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([JPVideoPlayerWeiBoEqualHeightCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JPVideoPlayerWeiBoUnequalHeightCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([JPVideoPlayerWeiBoUnequalHeightCell class])];
    
    self.tableView.jp_delegate = self;
    self.tableView.jp_scrollPlayStrategyType = self.scrollPlayStrategyType;
}


@end
