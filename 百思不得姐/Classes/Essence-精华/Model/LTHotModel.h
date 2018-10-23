//
//  LTHotModel.h
//  百思不得姐
//
//  Created by 李霆 on 2018/9/26.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LTUserModel;

@interface LTHotModel : NSObject

/** id */
@property (nonatomic, copy) NSString *ID;
/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 用户(发表评论的人) */
@property (nonatomic, strong) LTUserModel *user;

/** 被点赞数 */
@property (nonatomic, assign) NSInteger like_count;

/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;

/** 音频文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;

@end
