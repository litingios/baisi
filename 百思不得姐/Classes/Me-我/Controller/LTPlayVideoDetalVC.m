//
//  LTPlayVideoDetalVC.m
//  百思不得姐
//
//  Created by 李霆 on 2018/10/20.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTPlayVideoDetalVC.h"
#import "JPVideoPlayerKit.h"
#import "LTPlModel.h"
#import "LTPlCell.h"

@interface LTVideoPlayerDetailControlView : JPVideoPlayerControlView

@property (nonatomic, strong) UILabel *label;

@end

@implementation LTVideoPlayerDetailControlView

- (instancetype)initWithControlBar:(UIView <JPVideoPlayerProtocol> *_Nullable)controlBar
                         blurImage:(UIImage *_Nullable)blurImage {
    self = [super initWithControlBar:controlBar
                           blurImage:blurImage];
        if(self){
//            self.label = ({
//                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 200, 50)];
//                label.text = @"测试 Masonry 布局";
//                [self addSubview:label];
//                label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
//                label;
//            });
        }
    return self;
}

@end

@interface LTPlayVideoDetalVC ()<JPVideoPlayerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *videoContainer;
/***  ****/
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *allData;

@end

@implementation LTPlayVideoDetalVC

- (void)dealloc{
    [self.videoContainer jp_stopPlay];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"视频详情";
    self.videoContainer = ({
        UIView *videoView = [UIView new];
        videoView.backgroundColor = [UIColor clearColor];
        CGFloat screenWid = [UIScreen mainScreen].bounds.size.width;
        videoView.frame = CGRectMake(0, 64, screenWid, screenWid * 9.0 / 16.0);
        [self.view addSubview:videoView];
        videoView.jp_videoPlayerDelegate = self;
        videoView;
    });
    [self creatTableView];
    [self loadNewTopics];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.videoContainer jp_playVideoWithURL:[NSURL URLWithString:self.videoPath]
                           bufferingIndicator:nil
                                  controlView:[[LTVideoPlayerDetailControlView alloc] initWithControlBar:nil blurImage:nil]
                                 progressView:nil
                                configuration:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - JPVideoPlayerDelegate
- (BOOL)shouldAutoReplayForURL:(nonnull NSURL *)videoURL {
    return NO;
}

- (void)creatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.videoContainer.lt_bottom, iPhone_Width, iPhone_Height-self.videoContainer.lt_height-64) style:UITableViewStylePlain];
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
    params[@"data_id"] = self.ID;
    params[@"hot"] = @"1";
    params[@"per"] = @"100";

    __weak typeof(self) weakSelf = self;
    [Https getDataWithURL:LTCommonURL parameter:params success:^(id data) {
        if ([data[@"data"] isKindOfClass:[NSArray class]]) {
            if (![data isKindOfClass:[NSDictionary class]]) {
                return ;
            }
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
