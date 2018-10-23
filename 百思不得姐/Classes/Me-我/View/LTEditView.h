//
//  LTEditView.h
//  百思不得姐
//
//  Created by 李霆 on 2018/10/20.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol editViewDelegate <NSObject>
@optional
- (void)confirMothed:(UIButton *)button;
- (void)cancelMothed;
@end

@interface LTEditView : UIView

/*** 确定 ****/
@property(nonatomic,strong) UIButton *confirmBtn;
/*** 取消 ****/
@property(nonatomic,strong) UIButton *cancelBtn;
/*** 分割线 ****/
@property(nonatomic,strong) UILabel *lineLable;
/*** 代理 ****/
@property(nonatomic,weak)id<editViewDelegate>delegate;

@end
