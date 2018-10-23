
//
//  LTBaseViewController.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/26.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTBaseViewController.h"
#import "LTToppicCell.h"
#import "LTNewViewController.h"
#import "JPVideoPlayerKit.h"
#import "XMGTopicVideoView.h"
#import "JPVideoPlayerWeiBoEqualHeightCell.h"
#import "JPVideoPlayerManager.h"
#import "LTDetailVCViewController.h"

@interface LTBaseViewController ()<JPTableViewPlayVideoDelegate>

/*** 帖子数据 ****/
@property(nonatomic,strong) NSMutableArray<LTEssenceModel *> *topArr;
/** maxtime : 用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;
/** 声明这个方法的目的 : 为了能够使用点语法的智能提示 */
- (NSString *)aParam;
/*** 管理者 ****/
@property (nonatomic, strong) JPVideoPlayerManager *manager;

@end

@implementation LTBaseViewController

/*** 释放cell停止播放 ****/
- (void)dealloc {
    if (self.tableView.jp_playingVideoCell) {
        [self.tableView.jp_playingVideoCell.jp_videoPlayView jp_stopPlay];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPlayStrategyType:(JPScrollPlayStrategyType)playStrategyType {
    self = [super init];
    if(self){
        _scrollPlayStrategyType = playStrategyType;
    }
    return self;
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

#pragma mark - 仅仅是为了消除编译器发出的警告 : type方法没有实现
- (LTModelType)type {
    return 0;
}

- (instancetype)init{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    [self setupRefresh];
    [self setupNote];
    _manager = [[JPVideoPlayerManager alloc]init];
}

- (void)setUpTableView{
    self.view.backgroundColor = LTCommonBgColor;
    self.tableView.contentInset = UIEdgeInsetsMake(35, 0, 0, 0);
    self.tableView.estimatedRowHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.jp_tableViewVisibleFrame = self.tableView.frame;
    self.tableView.jp_delegate = self;
    self.tableView.jp_scrollPlayStrategyType = self.scrollPlayStrategyType;
}

- (void)setupNote{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:LTTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:LTTitleButtonDidRepeatClickNotification object:nil];
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

#pragma mark - 监听
/**
 *  监听TabBar按钮的重复点击
 */
- (void)tabBarButtonDidRepeatClick{
    
    // 如果当前控制器的view不在window上，就直接返回,否则这个方法调用五次
    if (self.view.window == nil) return;
    
    // 如果当前控制器的view跟window没有重叠，就直接返回
    if (![self.view intersectWithView:self.view.window]) return;
    
    // 进行下拉刷新
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  监听标题按钮的重复点击
 */
- (void)titleButtonDidRepeatClick
{
    [self tabBarButtonDidRepeatClick];
}


#pragma mark ------  请求数据  ------
- (void)loadNewTopics{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.aParam;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    
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
    params[@"type"] = @(self.type);

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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.topArr[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTToppicCell * cell = [LTToppicCell cellWithTableView:self.tableView];
    cell.model = self.topArr[indexPath.row];
    if (self.topArr[indexPath.row].type == LTModelTypeVideo) {
        cell.jp_videoURL = [NSURL URLWithString:self.topArr[indexPath.row].videouri];
        cell.jp_videoPlayView = cell.videoView.imageView;
        [tableView jp_handleCellUnreachableTypeForCell:cell
                                           atIndexPath:indexPath];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LTEssenceModel * model = _topArr[indexPath.row];
    if (model.type == LTModelTypeVideo) {
        LTPlayVideoDetalVC * view = [[LTPlayVideoDetalVC alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        view.videoPath = model.videouri;
        view.ID = model.id;
        [self.navigationController pushViewController:view animated:YES];
    }else{
        LTDetailVCViewController * view = [[LTDetailVCViewController alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        view.model = model;
        [self.navigationController pushViewController:view animated:YES];
    }
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
    LTToppicCell * topCell = (LTToppicCell *)cell;
    topCell.videoView.playVideoBtn.hidden = YES;
}

@end
