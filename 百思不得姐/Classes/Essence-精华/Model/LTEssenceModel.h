//
//  LTEssenceModel.h
//  百思不得姐
//
//  Created by 李霆 on 2018/9/20.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,LTModelType) {
    /** 全部 */
    LTModelTypeAll = 1,
    /** 图片 */
    LTModelTypePicture = 10,
    /** 段子 */
    LTModelTypeWord = 29,
    /** 声音 */
    LTModelTypeVoice = 31,
    /** 视频 */
    LTModelTypeVideo = 41
};

@class LTHotModel;

@interface LTEssenceModel : NSObject

/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 分类 */
@property (nonatomic, copy) NSString* theme_name;
/*** id ****/
@property(nonatomic,copy) NSString *id;
/** 最热评论 */
@property (nonatomic, strong) LTHotModel *top_cmt;
/** 帖子类型 */
@property (nonatomic, assign) LTModelType type;
/*** 判断是否进入编辑状态 ****/
@property(nonatomic) BOOL isEdit;
/*** 判断按钮的点击状态 ****/
@property(nonatomic) BOOL isSelect;

/******  图片相关的字段 - 方便找到 ********/
/** 图片的真实宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的真实高度 */
@property (nonatomic, assign) CGFloat height;
/** 小图 */
@property (nonatomic, copy) NSString *small_image;
/** 中图 */
@property (nonatomic, copy) NSString *middle_image;
/** 大图 */
@property (nonatomic, copy) NSString *large_image;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/******  音视频相关的字段 - 方便找到 ********/
/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频\视频的播放次数 */
@property (nonatomic, assign) NSInteger playcount;
/*** 视频地址 ****/
@property(nonatomic,copy) NSString *videouri;
/*** 是否下载 ****/
@property(nonatomic) BOOL isDownLoad;

/***** 额外增加的属性 - 方便开发 *****/
/*** 文字内容的高度 ****/
@property(nonatomic,assign) CGFloat textHeight;
/*** 最热评论的内容的高度 ****/
@property(nonatomic,assign) CGFloat hotTextHeight;
/** 是否为gif动画图片 */
@property (nonatomic, assign) BOOL is_gif;
/** 中间内容的frame */
@property (nonatomic, assign) CGRect contentF;
/** 是否为超长图片 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;

@end
