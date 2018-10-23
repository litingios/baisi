//
//  XMGTopicVideoView.h
//  4期-百思不得姐
//
//  Created by xiaomage on 15/10/22.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LTEssenceModel;

@interface XMGTopicVideoView : UIView
/** 模型数据 */
@property (nonatomic, strong) LTEssenceModel *topic;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *playVideoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *ciledImageView;
@property (nonatomic,assign)NSIndexPath * indexPath;
@end
