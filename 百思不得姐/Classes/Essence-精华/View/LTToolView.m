//
//  LTToolView.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/21.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTToolView.h"
#import "LTToolButton.h"

@implementation LTToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        //文字内容
        NSArray * titleArr = @[@"赞",@"踩",@"分享",@"评论"];
        //图片内容
        NSArray * imageArr = @[@"mainCellDing",@"mainCellCai",@"mainCellShare",@"mainCellComment"];
        //高亮图片内容
        NSArray * HightimageArr = @[@"mainCellDingClick",@"mainCellCaiClick",@"mainCellShareClick",@"mainCellCommentClick"];
        //总个数
        NSUInteger count = 4;
        //方块的尺寸
        int maxColsCount = 4; //一行最多4列
        CGFloat buttonW = self.lt_width / maxColsCount;
        CGFloat buttonH = self.lt_height;
        /*** 创建按钮 ****/
        for (int i = 0; i<count; i++) {
            LTToolButton * button = [LTToolButton buttonWithType:UIButtonTypeCustom];
            button.tag = 100+i;
            [self addSubview:button];
            LRViewBorderRadius(button, 0, 1*HeightScale, LTCommonBgColor);
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            //设置fram
            button.lt_x = (i % maxColsCount) * buttonW;
            button.lt_y = (i / maxColsCount) * buttonH;
            button.lt_width = buttonW+1*WidthScale;
            button.lt_height = buttonH - 2*WidthScale;
            
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:HightimageArr[i]] forState:UIControlStateHighlighted];
        }
    }
    return self;
}

- (void)setToolDict:(NSDictionary *)toolDict{
    _toolDict = toolDict;
    for (int i = 0; i<4; i++) {
        UIButton * ding = [self viewWithTag:100+i];
        if (i == 0) {
            [self setupButton:ding number:[toolDict[@"ding"] integerValue] placeholder:@"顶"];
        }else if (i == 1){
            [self setupButton:ding number:[toolDict[@"cai"] integerValue] placeholder:@"踩"];
        }else if (i == 2){
            [self setupButton:ding number:[toolDict[@"repost"] integerValue] placeholder:@"分享"];
        }else{
            [self setupButton:ding number:[toolDict[@"comment"] integerValue] placeholder:@"评论"];
        }
    }
}

/**
 *  设置按钮的数字 (placeholder是一个中文参数, 故意留到最后, 前面的参数就可以使用点语法等智能提示)
 */
- (void)setupButton:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

#pragma mark ------  按钮点击点赞评论...  ------
- (void)buttonClick:(UIButton *)button{
    
}

@end
