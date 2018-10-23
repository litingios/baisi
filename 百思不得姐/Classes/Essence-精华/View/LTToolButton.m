//
//  LTToolButton.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/21.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTToolButton.h"

@implementation LTToolButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.lt_y = self.lt_height * 0.3;
    self.imageView.lt_x = self.lt_width * 0.2;
    self.imageView.lt_height = self.lt_height * 0.5;
    self.imageView.lt_width = self.lt_height*0.5;
    
    self.titleLabel.lt_x = self.imageView.lt_right;
    self.titleLabel.lt_y = self.lt_height * 0.3;
    self.titleLabel.lt_width = self.lt_width*0.4;
    self.titleLabel.lt_height = self.lt_height * 0.5;
}

@end
