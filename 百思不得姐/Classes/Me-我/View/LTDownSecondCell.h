//
//  LTDownSecondCell.h
//  百思不得姐
//
//  Created by 李霆 on 2018/10/19.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTEssenceModel;

@interface LTDownSecondCell : UITableViewCell
/*** 数据模型 ****/
@property(nonatomic,strong) LTEssenceModel *model;
/*** 点击下载按钮 ****/
@property(nonatomic,copy) void (^downBlock)(void);

@end
