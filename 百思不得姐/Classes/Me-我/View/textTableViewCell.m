//
//  textTableViewCell.m
//  百思不得姐
//
//  Created by 李霆 on 2018/10/19.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "textTableViewCell.h"
#import "LTEssenceModel.h"

@interface textTableViewCell()

/*** 视频图片 ****/
@property(nonatomic,strong) UIImageView *videoImageView;
/*** 选择按钮 ****/
@property(nonatomic,strong) UIButton *selctBtn;
/*** 视频标题 ****/
@property(nonatomic,strong) UILabel *titleLable;
/*** 内存大小 ****/
@property(nonatomic,strong) UILabel *memoryLable;
/*** 观看时间 ****/
@property(nonatomic,strong) UILabel *seeLable;
/*** 未观看 ****/
@property(nonatomic,strong) UILabel *isNewLable;
/*** 控制动画显示效应 ****/
@property(nonatomic) BOOL count;

@end

@implementation textTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = NSStringFromClass([self class]);
    textTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[textTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /*** 创建UI ****/
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    
    _count = YES;
    
    _selctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selctBtn.frame = CGRectMake(20*WidthScale, (90-25)/2, 25, 25);
    [_selctBtn setImage:[UIImage imageNamed:@"weiselect"] forState:UIControlStateNormal];
    [_selctBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_selctBtn addTarget:self action:@selector(selctBtnCiled:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selctBtn];
    
    _videoImageView = [[UIImageView alloc]init];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _videoImageView.clipsToBounds = YES;
    [self addSubview:_videoImageView];
    
    _titleLable = [[UILabel alloc]init];
    _titleLable.font = [UIFont systemFontOfSize:15];
    _titleLable.textColor = LTBlackColor;
    _titleLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLable];
    
    _memoryLable = [LTControl createLabelWithFrame:CGRectZero Font:12 Text:@"388M"];
    _memoryLable.textColor = [UIColor lightGrayColor];
    _memoryLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_memoryLable];
    
    _seeLable = [LTControl createLabelWithFrame:CGRectZero Font:12 Text:@"剩余32:09未观看"];
    _seeLable.textColor = [UIColor lightGrayColor];
    _seeLable.textAlignment = NSTextAlignmentRight;
    [self addSubview:_seeLable];
    
    _isNewLable = [LTControl createLabelWithFrame:CGRectZero Font:10 Text:@"新"];
    _isNewLable.textColor = [UIColor whiteColor];
    _isNewLable.textAlignment = NSTextAlignmentCenter;
    _isNewLable.backgroundColor = LTRGB(252, 87, 101);
    LRViewBorderRadius(_isNewLable, 3, 1, [UIColor clearColor]);
    [self addSubview:_isNewLable];
}

- (void)selctBtnCiled:(UIButton *)btn{
    btn.selected = !btn.selected;
}

- (void)setModel:(LTEssenceModel *)model{
    [_videoImageView sd_setImageWithURL:[NSURL URLWithString:model.small_image]];
    _titleLable.text = model.text;
    if (model.isEdit == YES) {
        _selctBtn.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self->_videoImageView.frame = CGRectMake(self->_selctBtn.lt_right+LTMargin, LTMargin, 120, 70);
            self->_titleLable.frame = CGRectMake(self->_videoImageView.lt_right+LTMargin, self->_videoImageView.lt_y, 360*WidthScale, 30*HeightScale);
            self->_memoryLable.frame = CGRectMake(self->_videoImageView.lt_right+LTMargin, self->_videoImageView.lt_bottom-30*HeightScale, 160*WidthScale, 30*HeightScale);
            self->_seeLable.frame = CGRectMake(iPhone_Width-300*WidthScale, self->_memoryLable.lt_y, 260*WidthScale, 30*HeightScale);
            self->_isNewLable.frame = CGRectMake(iPhone_Width-50*WidthScale, self->_videoImageView.lt_y+10*HeightScale, 30*WidthScale, 30*WidthScale);
        } completion:nil];
    }else{
        _selctBtn.hidden = YES;
        if (_count == YES) {
            _count = NO;
            [self animalMenthod];
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                [self animalMenthod];
            } completion:nil];
        }
    }
    model.isSelect == YES ? (_selctBtn.selected = YES) : (_selctBtn.selected = NO);
}

- (void)animalMenthod{
    self->_videoImageView.frame = CGRectMake(LTMargin, LTMargin, 120, 70);
    self->_titleLable.frame = CGRectMake(self->_videoImageView.lt_right+LTMargin, self->_videoImageView.lt_y,360*WidthScale, 30*HeightScale);
    self->_memoryLable.frame = CGRectMake(self->_videoImageView.lt_right+LTMargin, self->_videoImageView.lt_bottom-30*HeightScale, 160*WidthScale, 30*HeightScale);
    self->_seeLable.frame = CGRectMake(iPhone_Width-300*WidthScale, self->_memoryLable.lt_y, 260*WidthScale, 30*HeightScale);
    self->_isNewLable.frame = CGRectMake(iPhone_Width-50*WidthScale, self->_videoImageView.lt_y+10*HeightScale, 30*WidthScale, 30*WidthScale);
}

@end
