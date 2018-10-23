//
//  LTFollowViewController.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/13.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTFollowViewController.h"
#import "LTRecomendFllowViewController.h"
#import "LTLoginResgstViewController.h"

@interface LTFollowViewController ()

@end

@implementation LTFollowViewController
/*
 * 关注
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LTCommonBgColor;
    
    // 标题(不建议使用self.title属性)
    self.navigationItem.title = @"我的关注";
    // 左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(followClick)];
}


#pragma mark <======  左边按钮点击事件  ======>
- (void)followClick{
    LTRecomendFllowViewController * view = [[LTRecomendFllowViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark <======  点击登录按钮事件  ======>
- (IBAction)loginFunc:(id)sender {
    LTLoginResgstViewController * view = [[LTLoginResgstViewController alloc]init];
    [self.navigationController presentViewController:view animated:YES completion:nil];
}


@end
