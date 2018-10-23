//
//  textTableViewCell.h
//  百思不得姐
//
//  Created by 李霆 on 2018/10/19.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTEssenceModel;

@interface textTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
/*** 注释内容 ****/
@property(nonatomic,strong) LTEssenceModel *model;


@end
