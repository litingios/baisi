//
//  LTCustomBtn.h
//  百思不得其解
//
//  Created by 李霆 on 2018/9/15.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTCustomBtn : UIButton

/*** 图片 ****/
@property (nonatomic,strong) UIImageView * topImage;
/*** 内容 ****/
@property (nonatomic,strong) UILabel * bottomLbl;
/*** 图片宽度是button宽度的多少 ****/
@property(nonatomic)float widthScale;

@end
