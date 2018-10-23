//
//  LTRecommendModel.h
//  百思不得姐
//
//  Created by 李霆 on 2018/9/28.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTRecommendModel : NSObject

/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;

@end
