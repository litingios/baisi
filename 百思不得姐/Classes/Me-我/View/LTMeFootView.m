//
//  LTMeFootView.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/17.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTMeFootView.h"
#import "LTMeModel.h"
#import "LTMeButton.h"
#import "XMGWebViewController.h"
/*** 获取safar控制器进行显示网页 ****/
#import <SafariServices/SafariServices.h>

@implementation LTMeFootView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        // 请求
        [Https getDataWithURL:LTCommonURL parameter:params success:^(id data) {
            /*** 加载数组中的字典 ****/
            NSMutableArray *squares = [NSMutableArray array];
            squares = [LTMeModel mj_objectArrayWithKeyValuesArray:data[@"square_list"]];
            /*** 删除字典的最后一个元素 ****/
            [squares removeLastObject];
            [self createModel:squares];
        } failure:^(NSError *errorMessage) {
            LTLog(@"请求失败 - %@", errorMessage);
        }];
    }
    return self;
}

/**
  根据数据创建按钮
  @param array 数据源
 */
- (void)createModel:(NSArray *)array{
    //总个数
    NSUInteger count = array.count;
    //方块的尺寸
    int maxColsCount = 4; //一行最多4列
    CGFloat buttonW = self.lt_width / maxColsCount;
    CGFloat buttonH = buttonW;
    
    for (NSInteger i = 0; i < count; i++) {
        LTMeButton * button = [LTMeButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //设置fram
        button.lt_x = (i % maxColsCount) * buttonW;
        button.lt_y = (i / maxColsCount) * buttonH+LTMargin;
        button.lt_width = buttonW - 2*WidthScale;
        button.lt_height = buttonH - 2*WidthScale;
        button.model = array[i];
    }
    // 设置footer的高度 == 最后一个按钮的bottom(最大Y值)
    self.lt_height = self.subviews.lastObject.lt_bottom;
    // 设置tableView的contentSize
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
    [tableView reloadData]; // 重新刷新数据(会重新计算contentSize)    
}

- (void)buttonClick:(LTMeButton *)button{
    NSString *url = button.model.url;
    
    if ([url hasPrefix:@"http"]) { // 利用webView加载url即可
        // 使用SFSafariViewController显示网页
        //        SFSafariViewController *webView = [[SFSafariViewController alloc] initWithURL:[NSURL URLWi thString:url]];
        //        UITabBarController *tabBarVc = (UITabBarController *)self.window.rootViewController;
        //        [tabBarVc presentViewController:webView animated:YES completion:nil];
        
        
        // 获得"我"模块对应的导航控制器
        //        UITabBarController *tabBarVc = [UIApplication sharedApplication].keyWindow.rootViewController;
        //        UINavigationController *nav = tabBarVc.childViewControllers.firstObject;
        UITabBarController *tabBarVc = (UITabBarController *)self.window.rootViewController;
        UINavigationController *nav = tabBarVc.selectedViewController;
        
        // 显示XMGWebViewController
        XMGWebViewController *webView = [[XMGWebViewController alloc] init];
        webView.url = url;
        webView.navigationItem.title = button.currentTitle;
        [nav pushViewController:webView animated:YES];
    } else if ([url hasPrefix:@"mod"]) { // 另行处理
        if ([url hasSuffix:@"BDJ_To_Check"]) {
            LTLog(@"跳转到[审帖]界面");
        } else if ([url hasSuffix:@"BDJ_To_RecentHot"]) {
            LTLog(@"跳转到[每日排行]界面");
        } else {
            LTLog(@"跳转到其他界面");
        }
    } else {
        LTLog(@"不是http或者mod协议的");
    }
}


@end
