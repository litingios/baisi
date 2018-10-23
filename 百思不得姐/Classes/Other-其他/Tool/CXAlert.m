//
//  CXAlert.m
//  CarMessage
//
//  Created by 李霆 on 2018/5/18.
//  Copyright © 2018年 车讯. All rights reserved.
//

#import "CXAlert.h"

@implementation CXAlert
//提示信息
+ (void)showMessage:(NSString *)message Time:(double)time{
    // 获取window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *showView = [[UIView alloc] init];
    showView.backgroundColor = LTRGB(51,51,51);
    showView.frame = CGRectMake(1, 1, 1, 1);
    showView.alpha = 1.0f;
    showView.layer.cornerRadius = 5.0f;
    showView.layer.masksToBounds = YES;
    [window addSubview:showView];
    
    UILabel *label = [[UILabel alloc] init];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGRect labelRect = [message boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    label.frame = CGRectMake(10, 5, ceil(CGRectGetWidth(labelRect)), CGRectGetHeight(labelRect));
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [showView addSubview:label];
    showView.frame = CGRectMake((iPhone_Width - CGRectGetWidth(labelRect) - 20)/2, iPhone_Height-120, CGRectGetWidth(labelRect)+20, CGRectGetHeight(labelRect)+10);
    double t = time>0?time:2;
    [UIView animateWithDuration:t animations:^{
        showView.alpha = 0;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
        
    }];
    
}
+ (void)showCenterMessage:(NSString *)message Time:(double)time {
    // 获取window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *showView = [[UIView alloc] init];
    showView.backgroundColor = LTRGB(51,51,51);
    showView.frame = CGRectMake(1, 1, 1, 1);
    showView.alpha = 1.0f;
    showView.layer.cornerRadius = 5.0f;
    showView.layer.masksToBounds = YES;
    [window addSubview:showView];
    
    UILabel *label = [[UILabel alloc] init];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGRect labelRect = [message boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    label.frame = CGRectMake(10, 5, ceil(CGRectGetWidth(labelRect)), CGRectGetHeight(labelRect));
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [showView addSubview:label];
    showView.frame = CGRectMake((iPhone_Width - CGRectGetWidth(labelRect) - 20)/2, iPhone_Height/2-47, CGRectGetWidth(labelRect)+20, CGRectGetHeight(labelRect)+10);
    double t = time>0?time:2;
    [UIView animateWithDuration:t animations:^{
        showView.alpha = 0;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
        
    }];
    
}

@end
