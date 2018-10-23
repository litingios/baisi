//
//  LTNewViewController.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/13.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTNewViewController.h"

@interface LTNewViewController ()

@end

@implementation LTNewViewController
/*
 * 新帖
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LTCommonBgColor;
    [self setupNav];
    /*** 请求数据 ****/
    [self creatDtae];
    /*** 创建UI ****/
    [self creatUI];
}

- (void)setupNav{
    self.view.backgroundColor = LTCommonBgColor;
    // 标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    // 左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}

- (void)creatDtae{
    
}

- (void)creatUI{
    
}

- (void)tagClick{
    
}

@end
