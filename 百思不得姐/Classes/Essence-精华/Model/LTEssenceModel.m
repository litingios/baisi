//
//  LTEssenceModel.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/20.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTEssenceModel.h"
#import "LTHotModel.h"
#import "LTUserModel.h"

@implementation LTEssenceModel
#pragma mark - 其他
static NSDateFormatter *fmt_;
static NSCalendar *calendar_;

+ (void)initialize
{
    fmt_ = [[NSDateFormatter alloc] init];
    calendar_ = [NSCalendar calendar];
}

- (NSString *)created_at
{
    // 获得发帖日期
    fmt_.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdAtDate = [fmt_ dateFromString:_created_at];
    
    if (createdAtDate.isThisYear) { // 今年
        if (createdAtDate.isToday) { // 今天
            // 手机当前时间
            NSDate *nowDate = [NSDate date];
            NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *cmps = [calendar_ components:unit fromDate:createdAtDate toDate:nowDate options:0];
            
            if (cmps.hour >= 1) { // 时间间隔 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间间隔 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 分钟
                return @"刚刚";
            }
        } else if (createdAtDate.isYesterday) { // 昨天
            fmt_.dateFormat = @"昨天 HH:mm:ss";
            return [fmt_ stringFromDate:createdAtDate];
        } else { // 其他
            fmt_.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt_ stringFromDate:createdAtDate];
        }
    } else { // 非今年
        return _created_at;
    }
}

// 屏幕宽度 == 375
// 图片显示出来的宽度 == 355
// 图片显示出来的高度 == 355 * 300 / 710

// 服务器返回的图片宽度 == 710
// 服务器返回的图片高度 == 300

- (CGFloat)cellHeight
{
    // 如果cell的高度已经计算过, 就直接返回
    if (_cellHeight) return _cellHeight;
    
    // 1.头像
    _cellHeight = 55;
    
    // 2.文字
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * LTMargin;
    CGSize textMaxSize = CGSizeMake(textMaxW, MAXFLOAT);
    CGSize textSize = [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
    _cellHeight += textSize.height + LTMargin;
    
    /*** 文字内容的高度 ****/
    self.textHeight = textSize.height;
    
    // 3.中间的内容
    if (self.type != LTModelTypeWord) { // 如果是图片\声音\视频帖子, 才需要计算中间内容的高度
        // 中间内容的高度 == 中间内容的宽度 * 图片的真实高度 / 图片的真实宽度
        CGFloat contentH = textMaxW * self.height / self.width;
        
        if (contentH >= [UIScreen mainScreen].bounds.size.height) { // 超长图片
            // 将超长图片的高度变为200
            contentH = 200;
            self.bigPicture = YES;
        }

        // 这里的cellHeight就是中间内容的y值
        self.contentF = CGRectMake(LTMargin, _cellHeight, textMaxW, contentH);
        
        // 累加中间内容的高度
        _cellHeight += contentH + LTMargin;
    }
    
    // 4.最热评论
    if (self.top_cmt) { // 如果有最热评论
        // 最热评论-标题
        _cellHeight += 20;
        // 最热评论-内容
        NSString *content = self.top_cmt.content;
        if (self.top_cmt.voiceuri.length) {
            content = @"[语音评论]";
        }
        NSString *topCmtContent = [NSString stringWithFormat:@"%@ : %@", self.top_cmt.user.username, content];
        CGSize topCmtContentSize = [topCmtContent boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        _cellHeight += topCmtContentSize.height + LTMargin;
        /*** 热评文字内容的高度 ****/
        self.hotTextHeight = topCmtContentSize.height;
    }
    
    // 5.底部 - 工具条
    _cellHeight += 40 + LTMargin;
    
    return _cellHeight;
}


@end
