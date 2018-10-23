//
//  LTMeButton.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/17.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTMeButton.h"
#import "LTMeModel.h"
#import "UIButton+WebCache.h"

@implementation LTMeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
//        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
//        LRViewBorderRadius(self, 1, 0.1, [UIColor redColor]);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.lt_y = self.lt_height * 0.15;
    self.imageView.lt_height = self.lt_height * 0.5;
    self.imageView.lt_width = self.imageView.lt_height;
    self.imageView.lt_centerX = self.lt_width * 0.5;
    
    self.titleLabel.lt_x = 0;
    self.titleLabel.lt_y = self.imageView.lt_bottom;
    self.titleLabel.lt_width = self.lt_width;
    self.titleLabel.lt_height = self.lt_height - self.titleLabel.lt_y;
}

- (void)setModel:(LTMeModel *)model
{
    _model = model;
    
    [self setTitle:model.name forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:model.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"setup-head-default"]];
}


@end
