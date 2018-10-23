//
//  LTPlModel.h
//  百思不得姐
//
//  Created by 李霆 on 2018/10/20.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTPlModel : NSObject

/*** 评论内容 ****/
@property(nonatomic,copy) NSString *content;
/*** 评论时间 ****/
@property(nonatomic,copy) NSString *ctime;
/*** 点赞数量 ****/
@property(nonatomic,copy) NSString *like_count;
/*** 用户信息字典 ****/
@property(nonatomic,strong) NSDictionary *user;


@end
