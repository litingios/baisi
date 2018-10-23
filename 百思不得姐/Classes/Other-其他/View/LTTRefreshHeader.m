//
//  LTTRefreshHeader.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/20.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTTRefreshHeader.h"

@interface LTTRefreshHeader()

/** logo */
@property (nonatomic, weak) UIImageView *logo;
@end

@implementation LTTRefreshHeader

/**
 *  初始化
 */
- (void)prepare
{
    [super prepare];
    
    self.automaticallyChangeAlpha = YES;
    self.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    self.stateLabel.textColor = [UIColor grayColor];
    [self setTitle:@"赶紧下拉吧" forState:MJRefreshStateIdle];
    [self setTitle:@"赶紧松开吧" forState:MJRefreshStatePulling];
    [self setTitle:@"百思正在给您加载数据..." forState:MJRefreshStateRefreshing];
    self.lastUpdatedTimeLabel.hidden = YES;
//    self.stateLabel.hidden = YES;
//    [self addSubview:[[UISwitch alloc] init]];
    
//    UIImageView *logo = [[UIImageView alloc] init];
//    logo.image = [UIImage imageNamed:@"bd_logo1"];
//    [self addSubview:logo];
//    self.logo = logo;
}

/**
 *  摆放子控件
 */
- (void)placeSubviews
{
    [super placeSubviews];

//    self.logo.lt_width = self.lt_width;
//    self.logo.lt_height = 50;
//    self.logo.lt_x = 0;
//    self.logo.lt_y = - 50;
}

@end
