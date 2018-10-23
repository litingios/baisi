//
//  MainViewController.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/27.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "MainViewController.h"
#import "imageViewController.h"
#import "AVFoundationVC.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"视频";
    self.view.backgroundColor = LTCommonBgColor;
    [self setupUI];
}

- (void)setupUI{
    NSArray * arr = @[@"UIImagePickerController",@"AVFoundation"];
    for (int i = 0; i<2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:button];
        button.frame = CGRectMake(80, 180+80*i, [[UIScreen mainScreen] bounds].size.width-160, 40);
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonCiled:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonCiled:(UIButton *)btn{
    if (btn.tag == 101) {
        AVFoundationVC * view = [[AVFoundationVC alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }else{
        imageViewController * view = [[imageViewController alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
}


@end
