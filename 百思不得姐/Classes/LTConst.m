//
//  LTConst.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/15.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 通用的间距值 */
CGFloat const LTMargin = 10;
/** 通用的小间距值 */
CGFloat const LTSmallMargin = LTMargin * 0.5;
/*** 缓存视频表名 ****/
NSString * const TableName = @"videoModel";

/** 公共的URL */
NSString * const LTCommonURL = @"http://api.budejie.com/api/api_open.php";

/** LTUser - sex - male */
NSString * const LTUserSexMale = @"m";

/** LTUser - sex - female */
NSString * const LTUserSexFemale = @"f";

/*** 通知 ***/
/** TabBar按钮被重复点击的通知 */
NSString * const LTTabBarButtonDidRepeatClickNotification = @"LTTabBarButtonDidRepeatClickNotification";
/** 标题按钮被重复点击的通知 */
NSString * const LTTitleButtonDidRepeatClickNotification = @"LTTitleButtonDidRepeatClickNotification";
