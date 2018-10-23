//
//  XMGTopicPictureView.m
//  4期-百思不得姐
//
//  Created by xiaomage on 15/10/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGTopicPictureView.h"
#import "UIImageView+WebCache.h"
#import "LTEssenceModel.h"
//#import <DALabeledCircularProgressView.h>
#import "DALabeledCircularProgressView.h"
#import "XMGSeeBigViewController.h"

@interface XMGTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@end

@implementation XMGTopicPictureView

- (void)awakeFromNib
{
    // 从xib中加载进来的控件的autoresizingMask默认是UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.progressView.roundedCorners = 5;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBig)]];
}

- (void)seeBig
{
    XMGSeeBigViewController *seeBig = [[XMGSeeBigViewController alloc] init];
    seeBig.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBig animated:YES completion:nil];
}

- (void)setTopic:(LTEssenceModel *)topic
{
    _topic = topic;
    
    if (topic.is_gif == YES) {
        UIImage * image =[UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:topic.large_image]]];
        self.imageView.image = image;
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            // receivedSize : 已经接收的图片大小
            // expectedSize : 图片的总大小
            CGFloat progress = 1.0 * receivedSize / expectedSize;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.hidden = NO;
                self.progressView.progress = progress;
                self.progressView.progressLabel.textColor = [UIColor whiteColor];
                self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
            });
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.progressView.hidden = YES;
        }];
    }
    
    // gif
    self.gifView.hidden = !topic.is_gif;
    
    // 查看大图
    if (topic.isBigPicture) { // 超长图片
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    } else {
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
    
    // 网络判断
    //        AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    //        if (status == AFNetworkReachabilityStatusReachableViaWWAN) { // 手机自带网络
    //            [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.small_image]];
    //        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) { // WIFI
    //            [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    //        } else { // 网络有问题, 清空当前显示的图片
    //            self.imageView.image = nil;
    //        }
    
    // http://4234234.GIF -> http://4234234.gif
    
    // gif
    //    if ([topic.large_image.lowercaseString hasSuffix:@"gif"]) {
    //    if ([topic.large_image.pathExtension.lowercaseString isEqualToString:@"gif"]) {
    //    if (topic.is_gif) {
    //        self.gifView.hidden = NO;
    //    } else {
    //        self.gifView.hidden = YES;
    //    }
}

@end
