//
//  LTDownSecondCell.m
//  百思不得姐
//
//  Created by 李霆 on 2018/10/19.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTDownSecondCell.h"
#import "LTEssenceModel.h"

@interface LTDownSecondCell ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *categrayLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *downView;

@end

@implementation LTDownSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _videoImageView.clipsToBounds = YES;
    _downView.userInteractionEnabled = YES;
    [self.downView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downLoadCiled)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(LTEssenceModel *)model{
    _model = model;
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.small_image] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLable.text = model.text;
    if ([model.theme_name isEqualToString:@""]) {
        self.categrayLable.text = @"社会新鲜事";
    }else{
        self.categrayLable.text = model.theme_name;
    }
    self.timeLable.text = [NSString stringWithFormat:@"%@发布",model.created_at];
    if (model.isDownLoad) {
        _downView.image = IMAGE(@"bendi");
    }else{
        _downView.image = IMAGE(@"publish-offline");
    }
}

- (void)downLoadCiled{
    if (self.downBlock) {
        self.downBlock();
    }
}

@end
