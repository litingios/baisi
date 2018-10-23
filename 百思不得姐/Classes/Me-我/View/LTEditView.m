//
//  LTEditView.m
//  百思不得姐
//
//  Created by 李霆 on 2018/10/20.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTEditView.h"

@implementation LTEditView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _confirmBtn = [LTControl createButtonWithFrame:CGRectZero ImageName:nil Target:self Action:@selector(confirmBtnCiled:) Title:@""];
        [_confirmBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_confirmBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        [_confirmBtn setTitleColor:LTBlackColor forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = FONT(16);
        [self addSubview:_confirmBtn];
        
        _cancelBtn = [LTControl createButtonWithFrame:CGRectZero ImageName:nil Target:self Action:@selector(cancelBtnCiled) Title:@"删除"];
        [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = FONT(16);
        [self addSubview:_cancelBtn];
        
        _lineLable = [[UILabel alloc]init];
        _lineLable.backgroundColor = LTCommonBgColor;
        [self addSubview:_lineLable];
    }
    return self;
}

- (void)layoutSubviews{
    _confirmBtn.frame = CGRectMake(0, 0, iPhone_Width/2-0.5, self.lt_height);
    _cancelBtn.frame = CGRectMake(iPhone_Width/2+0.5, 0, iPhone_Width/2-0.5, self.lt_height);
    _lineLable.frame = CGRectMake(iPhone_Width/2-0.5, 10, 1, self.lt_height-20);
}

- (void)confirmBtnCiled:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(confirMothed:)]) {
        [self.delegate confirMothed:btn];
    }
}

- (void)cancelBtnCiled{
    if ([self.delegate respondsToSelector:@selector(cancelMothed)]) {
        [self.delegate cancelMothed];
    }
}

@end
