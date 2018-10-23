//
//  LTToppicCell.h
//  百思不得姐
//
//  Created by 李霆 on 2018/9/21.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTEssenceModel;
@class XMGTopicVideoView;

@interface LTToppicCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/*** 数据model ****/
@property(nonatomic,strong) LTEssenceModel *model;
/** 视频控件 */
@property (nonatomic, strong) XMGTopicVideoView  *videoView;

@end
