//
//  LTTabBar.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/12.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTTabBar.h"
@interface LTTabBar()
/** 中间的发布按钮 */
@property (nonatomic, weak) UIButton *publishButton;

@end
@implementation LTTabBar

#pragma mark - 懒加载
/** 发布按钮 */
- (UIButton *)publishButton
{
    if (!_publishButton) {
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        _publishButton = publishButton;
    }
    return _publishButton;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
    }
    return self;
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    /**** 按钮的尺寸 ****/
    CGFloat buttonW = self.lt_width / 5;
    CGFloat buttonH = self.lt_height;
    
    /**** 设置所有UITabBarButton的frame ****/
    CGFloat tabBarButtonY = 0;
    // 按钮索引
    int tabBarButtonIndex = 0;
    
    for (UIView *subview in self.subviews) {
        // 过滤掉非UITabBarButton
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        
        // 设置frame
        CGFloat tabBarButtonX = tabBarButtonIndex * buttonW;
        if (tabBarButtonIndex >= 2) { // 右边的2个UITabBarButton
            tabBarButtonX += buttonW;
        }
        subview.frame = CGRectMake(tabBarButtonX, tabBarButtonY, buttonW, buttonH);
        
        // 增加索引
        tabBarButtonIndex++;
    }
    
    /**** 设置中间的发布按钮的frame ****/
    self.publishButton.lt_width = buttonW;
    self.publishButton.lt_height = buttonH;
    self.publishButton.lt_centerX = self.lt_width * 0.5;
    self.publishButton.lt_centerY = self.lt_height * 0.5;
}

#pragma mark - 监听
- (void)publishClick
{
    LTLogFunc
}


@end
