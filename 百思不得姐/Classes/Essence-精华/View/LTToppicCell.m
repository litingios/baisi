//
//  LTToppicCell.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/21.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTToppicCell.h"
#import "LTToolView.h"
#import "LTHotCommentView.h"
#import "LTEssenceModel.h"
#import "LTUserModel.h"
#import "LTHotModel.h"
#import "XMGTopicVideoView.h"
#import "XMGTopicVoiceView.h"
#import "XMGTopicPictureView.h"

@interface LTToppicCell()
/*** 头像 ****/
@property(nonatomic,strong) UIImageView *iconView;
/*** 昵称 ****/
@property(nonatomic,strong) UILabel *nickNameLable;
/*** 时间 ****/
@property(nonatomic,strong) UILabel *timeLable;
/*** 点击更多 ****/
@property(nonatomic,strong) UIButton *moreBtn;
/*** 文字内容 ****/
@property(nonatomic,strong) UILabel *descLable;
/** 图片控件 */
@property (nonatomic, weak)  XMGTopicPictureView *pictureView;
/** 声音控件 */
@property (nonatomic, weak) XMGTopicVoiceView *voiceView;
/** 视频控件 */
//@property (nonatomic, strong) XMGTopicVideoView  *videoView;
/*** 最热评论工具条 ****/
@property(nonatomic,strong) LTHotCommentView *hotView;
/*** 底部工具条 ****/
@property(nonatomic,strong) LTToolView *toolView;
@end

@implementation LTToppicCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = NSStringFromClass([self class]);
    LTToppicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LTToppicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - 懒加载
- (XMGTopicPictureView *)pictureView
{
    if (!_pictureView) {
        XMGTopicPictureView *pictureView = [XMGTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (XMGTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        XMGTopicVoiceView *voiceView = [XMGTopicVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

//- (XMGTopicVideoView *)videoView
//{
//    if (!_videoView) {
//        XMGTopicVideoView *videoView = [XMGTopicVideoView viewFromXib];
//        [self.contentView addSubview:videoView];
//        _videoView = videoView;
//    }
//    return _videoView;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /*** 创建UI ****/
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(20*WidthScale, 20*HeightScale, 70*WidthScale, 70*WidthScale)];
    LRViewBorderRadius(_iconView, 35*WidthScale, 0, [UIColor clearColor]);
    [self addSubview:_iconView];
    
    _videoView = [XMGTopicVideoView viewFromXib];
    [self.contentView addSubview:_videoView];
    
    _nickNameLable = [LTControl createLabelWithFrame:CGRectMake(_iconView.lt_right+20*WidthScale, _iconView.lt_y, 200*WidthScale, 30*HeightScale) Font:14 Text:@"名字"];
    _nickNameLable.textColor = [UIColor grayColor];
    [self addSubview:_nickNameLable];
    
    _timeLable = [LTControl createLabelWithFrame:CGRectMake(_iconView.lt_right+20*WidthScale, _nickNameLable.lt_bottom+10*HeightScale, 200*WidthScale, 30*HeightScale) Font:14 Text:@""];
    _timeLable.textColor = [UIColor grayColor];
    [self addSubview:_timeLable];
    
    _moreBtn = [LTControl createButtonWithFrame:CGRectMake(iPhone_Width-90*WidthScale, _iconView.lt_y, 72*WidthScale, 60*WidthScale) ImageName:@"cellmorebtnnormal" Target:self Action:@selector(moreBtnCiled:) Title:@""];
    [_moreBtn setImage:[UIImage imageNamed:@"cellmorebtnclick"] forState:UIControlStateHighlighted];
    [self addSubview:_moreBtn];
    
    _descLable = [LTControl createLabelWithFrame:CGRectMake(20*WidthScale, _iconView.lt_bottom+20*HeightScale, iPhone_Width-40*WidthScale, 70*HeightScale) Font:15 Text:@""];
    _descLable.numberOfLines = 0;
    _descLable.textColor = [UIColor grayColor];
    [self addSubview:_descLable];
    
    _hotView = [[LTHotCommentView alloc]initWithFrame:CGRectMake(0, _descLable.lt_bottom, iPhone_Width, 200*HeightScale)];
    [self addSubview:_hotView];
    
    _toolView = [[LTToolView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, 80*HeightScale)];
    LRViewBorderRadius(_toolView, 0, 1*HeightScale, LTCommonBgColor);
    [self addSubview:_toolView];
}

/*** 点击更多按钮 ****/
- (void)moreBtnCiled:(UIButton *)btn{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [controller addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
        
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
}

- (void)setModel:(LTEssenceModel *)model{
    _model = model;
    /*** 传递踩顶...的数据 ****/
    _toolView.toolDict = @{@"ding":[NSString stringWithFormat:@"%zd",model.ding],@"cai":[NSString stringWithFormat:@"%zd",model.cai],@"repost":[NSString stringWithFormat:@"%zd",model.repost],@"comment":[NSString stringWithFormat:@"%zd",model.comment]};
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.profile_image] placeholderImage:[UIImage imageNamed:@"setup-head-default"]];
    _nickNameLable.text = model.name;
    _timeLable.text = model.created_at;
    _descLable.text = model.text;
    _descLable.lt_height = model.textHeight;
    /*** 最热评论 ****/
    if (model.top_cmt) {
        _hotView.hidden = NO;
        NSString *userName = model.top_cmt.user.username;
        NSString *content = model.top_cmt.content;
        if (model.top_cmt.voiceuri.length) {
            content = @"[语音评论]";
        }
        _hotView.lt_y = _descLable.lt_bottom;
        _hotView.hotDesLable.text = [NSString stringWithFormat:@"%@ : %@",userName,content];
        _hotView.hotDesLable.numberOfLines = 0;
        _hotView.lt_height = model.hotTextHeight+30*HeightScale;
        _hotView.hotDesLable.lt_height = model.hotTextHeight;
    }else{
        _hotView.hidden = YES;
    }
    /*** 中间内容 ****/
    if (model.type == LTModelTypeVideo) { // 视频
        self.videoView.hidden = NO;
        self.videoView.frame = model.contentF;
        self.videoView.topic = model;
        
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    } else if (model.type == LTModelTypeVoice) { // 音频
        self.voiceView.hidden = NO;
        self.voiceView.frame = model.contentF;
        self.voiceView.topic = model;
        
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
    } else if (model.type == LTModelTypeWord) { // 段子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    } else if (model.type == LTModelTypePicture) { // 图片
        self.pictureView.hidden = NO;
        self.pictureView.frame = model.contentF;
        self.pictureView.topic = model;
        
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }
    /*** 更新底部工具条frame ****/
    _toolView.lt_y = model.cellHeight-80*HeightScale-LTMargin;
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= LTMargin;
    /*** 使每个cell整体下移10的单位,相当于修改了tableview的偏移量 ****/
    frame.origin.y += LTMargin;
//    frame.origin.x += LTMargin;
//    frame.size.width -= 2*LTMargin;
    [super setFrame:frame];
}


@end
