//
//  LTHotCommentView.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/25.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTHotCommentView.h"

@implementation LTHotCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _hotTitleLable = [LTControl createLabelWithFrame:CGRectMake(20*WidthScale, 10*HeightScale, self.lt_width-40*WidthScale, 30*HeightScale) Font:14 Text:@"最热评论"];
        [self addSubview:_hotTitleLable];
        
        _hotDesLable = [LTControl createLabelWithFrame:CGRectMake(_hotTitleLable.lt_x, _hotTitleLable.lt_bottom+20*HeightScale, _hotTitleLable.lt_width, self.lt_height-40*HeightScale) Font:14 Text:@""];
        [self addSubview:_hotDesLable];
    }
    return self;
}



@end
