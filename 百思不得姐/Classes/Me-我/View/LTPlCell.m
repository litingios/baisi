//
//  LTPlCell.m
//  百思不得姐
//
//  Created by 李霆 on 2018/10/20.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTPlCell.h"
#import "LTPlModel.h"

@interface LTPlCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbale;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;


@end

@implementation LTPlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    LRViewBorderRadius(_iconView, 20, 1, [UIColor clearColor]);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)zanBtnCiled:(id)sender {
    UIButton * btn = sender;
    btn.selected = !btn.selected;
}

- (void)setModel:(LTPlModel *)model{
    _model = model;
    [_iconView sd_setImageWithURL:URL(model.user[@"profile_image"]) placeholderImage:IMAGE(@"setup-head-default")];
    _nickNameLbale.text = model.user[@"username"];
    _timeLable.text = model.ctime;
    _desLable.text = model.content;
    [_zanBtn setTitle:model.like_count forState:UIControlStateNormal];
}

@end
