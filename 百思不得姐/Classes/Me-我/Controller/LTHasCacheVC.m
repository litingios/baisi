//
//  LTHasCacheVC.m
//  百思不得姐
//
//  Created by 李霆 on 2018/10/19.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTHasCacheVC.h"
#import "LTEssenceModel.h"
#import "textTableViewCell.h"
#import "LTEditView.h"

@interface LTHasCacheVC ()<editViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray<LTEssenceModel *> *topArr;
@property (nonatomic, strong) NSMutableArray<LTEssenceModel *> *selectArray;
/*** 底部编辑视图 ****/
@property(nonatomic,weak) LTEditView *editView;
/*** 注释内容 ****/
@property(nonatomic,strong) UITableView *tableView;
/*** 编辑 ****/
@property(nonatomic,strong) UIButton *leftbutton;
/*** 数据库 ****/
@property(nonatomic,strong) JQFMDB* jqdb;

@end

@implementation LTHasCacheVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"已缓存列表";
    [self creatTableView];
    [self creatNav];
}

- (LTEditView *)editView{
    if (!_editView) {
        LTEditView * editView = [[LTEditView alloc]initWithFrame:CGRectMake(0, iPhone_Height, iPhone_Width, 50)];
        editView.backgroundColor = [UIColor whiteColor];
        editView.delegate = self;
        _editView = editView;
        [self.view addSubview:_editView];
    }
    return _editView;
}

- (void)creatNav{
    _leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [_leftbutton setTitle:@"编辑" forState:UIControlStateNormal];
    [_leftbutton setTitle:@"取消" forState:UIControlStateSelected];
    [_leftbutton setTitleColor:LTBlackColor forState:UIControlStateNormal];
    [_leftbutton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    _leftbutton.titleLabel.font = FONT(16);
    [_leftbutton addTarget:self action:@selector(enditCiled:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:_leftbutton];
    self.navigationItem.rightBarButtonItem=rightitem;
}

- (void)enditCiled:(UIButton *)btn{
    btn.selected = !btn.selected;
    for (LTEssenceModel * model in _topArr) {
        if (btn.selected == YES) {
            model.isEdit = YES;
            [UIView animateWithDuration:0.25 animations:^{
                self.editView.frame = CGRectMake(0, iPhone_Height-50, iPhone_Width, 50);
                self.tableView.frame = CGRectMake(0, 0, iPhone_Width, iPhone_Height-50);
            }];
        }else{
            model.isEdit = NO;
            model.isSelect = NO;
            _editView.confirmBtn.selected = NO;
            [self updataUIFram];
            self.selectArray = [NSMutableArray array];
            [self updataUIWithArr:self.selectArray];
        }
    }
    [self.tableView reloadData];
}

- (void)creatTableView{
    self.view.backgroundColor = LTCommonBgColor;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, iPhone_Height) style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 90;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)loadNewTopics{
    _selectArray = [NSMutableArray array];
    _jqdb = [JQFMDB shareDatabase];
    [_jqdb open];
    _topArr = [NSMutableArray arrayWithArray:[_jqdb jq_lookupTable:TableName dicOrModel:[LTEssenceModel new] whereFormat:nil]];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_jqdb close];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewTopics];
}

- (void)updataUIWithArr:(NSArray *)arr{
    arr.count > 0 ? [self.editView.cancelBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",arr.count] forState:UIControlStateNormal] : [self.editView.cancelBtn setTitle:@"删除" forState:UIControlStateNormal];
    arr.count > 0 ? [self.editView.cancelBtn setTitleColor:LTRGB(252, 87, 101) forState:UIControlStateNormal] : [self.editView.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.tableView reloadData];
}

- (void)updataUIFram{
    [UIView animateWithDuration:0.25 animations:^{
        self.editView.frame = CGRectMake(0, iPhone_Height, iPhone_Width, 50);
        self.tableView.frame = CGRectMake(0, 0, iPhone_Width, iPhone_Height);
    }];
}

#pragma mark - editViewDelegate
/*** 全选 ****/
- (void)confirMothed:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected == YES) {
        for (LTEssenceModel * model in self.topArr) {
            if (model.isSelect == NO) {
                model.isSelect = YES;
                [self.selectArray addObject:model];
            }
        }
    }else{
        for (LTEssenceModel * model in self.topArr) {
            model.isSelect = NO;
            [self.selectArray removeObject:model];
        }
    }
    [self updataUIWithArr:self.selectArray];
}

/*** 删除 ****/
- (void)cancelMothed{
    for (LTEssenceModel * model in self.selectArray) {
        if ([self.topArr containsObject:model]) {
            if ([_jqdb jq_deleteTable:TableName dicOrModel:model]) {
                [self.topArr removeObject:model];
            }
        }
    }
    for (LTEssenceModel * model in _topArr) {
        model.isEdit = NO;
    }
    _leftbutton.selected = NO;
    self.selectArray = [NSMutableArray array];
    [self updataUIFram];
    [self updataUIWithArr:self.selectArray];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _topArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    textTableViewCell * cell = [textTableViewCell cellWithTableView:self.tableView];
    cell.model = _topArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LTEssenceModel * model = self.topArr[indexPath.row];
    model.isSelect = !model.isSelect;
    model.isSelect == YES ? [self.selectArray addObject:model] : [self.selectArray removeObject:model];
    self.selectArray.count < self.topArr.count ? (self.editView.confirmBtn.selected = NO) : (self.editView.confirmBtn.selected = YES);
    [self updataUIWithArr:self.selectArray];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        LTEssenceModel * model = self.topArr[indexPath.row];
        /*** 点击左滑删除,删除数据源 ****/
        if ([_jqdb jq_deleteTable:TableName dicOrModel:model]) {
            [self.topArr removeObject:model];
        }
    }
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
