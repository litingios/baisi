//
//  LTExtensionConfig.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/26.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTExtensionConfig.h"
#import "LTHotModel.h"
#import "LTEssenceModel.h"

@implementation LTExtensionConfig

+ (void)load{
    [LTEssenceModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"top_cmt" : @"top_cmt[0]",
                 @"small_image" : @"image0",
                 @"middle_image" : @"image2",
                 @"large_image" : @"image1"};
    }];
    
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
}

@end
