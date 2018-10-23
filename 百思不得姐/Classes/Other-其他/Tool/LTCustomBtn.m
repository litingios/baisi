//
//  LTCustomBtn.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/15.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTCustomBtn.h"

@implementation LTCustomBtn

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    LTCustomBtn * btn = [super buttonWithType:buttonType];
    btn.topImage = [[UIImageView alloc] init];
    [btn addSubview:btn.topImage];
    btn.bottomLbl = [[UILabel alloc] init];
    btn.bottomLbl.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:btn.bottomLbl];
    return btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _topImage.frame = CGRectMake(self.frame.size.width*(1-self.widthScale)/2, 0, self.frame.size.width*self.widthScale, self.frame.size.width*self.widthScale);
    _topImage.contentMode = UIViewContentModeScaleAspectFit;
    _bottomLbl.frame = CGRectMake(0, CGRectGetMaxY(_topImage.frame)+30*HeightScale , self.frame.size.width, self.frame.size.height/4);
}


@end
