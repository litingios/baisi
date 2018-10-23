//
//  LTMeCell.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/15.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTMeCell.h"

@implementation LTMeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = NSStringFromClass([self class]);
    LTMeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LTMeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.textLabel.textColor = [UIColor grayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /*** 创建UI ****/
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    /*** 设置左侧的按钮 ****/
//    self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    /*** 设置cell的背景图片 ****/
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageView.image == nil) return;
    // imageView
    self.imageView.lt_y = LTSmallMargin;
    self.imageView.lt_height = self.contentView.lt_height - 2 * LTSmallMargin;
    self.imageView.lt_width = self.imageView.lt_height;
    // label
    self.textLabel.lt_x = self.imageView.lt_right + LTSmallMargin;
    
}

@end
