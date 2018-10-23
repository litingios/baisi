//
//  LTRefreshFooter.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/20.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTRefreshFooter.h"

@implementation LTRefreshFooter

- (void)prepare
{
    [super prepare];
    
    self.stateLabel.textColor = [UIColor grayColor];
    
//    [self addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    [self setTitle:@"没有数据啦,不要再上拉了" forState:MJRefreshStateNoMoreData];
    
    // 刷新控件出现一半就会进入刷新状态
    self.triggerAutomaticallyRefreshPercent = 1.0;
    
    // 不要自动刷新
    //    self.automaticallyRefresh = NO;
}

@end
