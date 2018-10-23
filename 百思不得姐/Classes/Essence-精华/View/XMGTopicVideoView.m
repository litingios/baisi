//
//  XMGTopicVideoView.m
//  4期-百思不得姐
//
//  Created by xiaomage on 15/10/22.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGTopicVideoView.h"
#import "LTEssenceModel.h"
#import "UIImageView+WebCache.h"
#import "LTPlayVideoVC.h"
#import "JPVideoPlayerDetailViewController.h"
#import "LTToppicCell.h"

@interface XMGTopicVideoView()
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@end

@implementation XMGTopicVideoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    _playVideoBtn.userInteractionEnabled = NO;
    self.imageView.userInteractionEnabled = YES;
    self.ciledImageView.userInteractionEnabled = YES;
    [self.ciledImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBig)]];
}

- (void)seeBig
{
//    LTPlayVideoVC * play = [[LTPlayVideoVC alloc]init];
//    play.videoUrl = [NSURL URLWithString:_topic.videouri];
//
    
    JPVideoPlayerDetailViewController *single = [JPVideoPlayerDetailViewController new];
    single.hidesBottomBarWhenPushed = YES;
    single.videoPath = _topic.videouri;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:single animated:NO completion:nil];
}

- (void)setTopic:(LTEssenceModel *)topic
{
    _topic = topic;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    
    // %04zd - 占据4位,空出来的位用0来填补
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
    
}
@end
