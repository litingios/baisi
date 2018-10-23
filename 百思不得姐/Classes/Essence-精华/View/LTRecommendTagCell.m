//
//  LTRecommendTagCell.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/28.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTRecommendTagCell.h"
#import "LTRecommendModel.h"

@interface LTRecommendTagCell();
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *renCountLable;
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@end
@implementation LTRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    LRViewBorderRadius(_iconImageView, 25, 1, [UIColor clearColor]);
    LRViewBorderRadius(_dingBtn, 4, 1, LTCommonBgColor);
}

- (void)setModel:(LTRecommendModel *)model{
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image_list] placeholderImage:[UIImage imageNamed:@"setup-head-default"]];
    _titleLable.text = model.theme_name;
    _renCountLable.text = [NSString stringWithFormat:@"%ld人订阅",model.sub_number];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
