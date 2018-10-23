//
//  LTTitleButton.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/19.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTTitleButton.h"

@implementation LTTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置按钮颜色
        // self.selected = NO;
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        // self.selected = YES;
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

/**
 * 解决重复点击按钮闪动的问题
 *
 */
- (void)setHighlighted:(BOOL)highlighted {
    
}


@end
