//
//  LTEssenceViewController.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/13.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTEssenceViewController.h"
#import "LTTitleButton.h"
#import "LTAllViewController.h"
#import "LTVoiceViewController.h"
#import "LTWorldViewController.h"
#import "LTVideoViewController.h"
#import "LTAllViewController.h"
#import "LTPictureViewController.h"
#import "LTRecommendTagVCTableViewController.h"

@interface LTEssenceViewController ()<UIScrollViewDelegate>

/** UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 当前选中的标题按钮 */
@property (nonatomic, weak) LTTitleButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;

@end

@implementation LTEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*** 设置导航栏 ****/
    [self setupNav];
    /*** 添加控制器 ****/
    [self setupChiledViewController];
    /*** 创建scrollView ****/
    [self setScrollView];
    /*** 设置titleView ****/
    [self setTitleView];
    /*** 添加子视图控制器 ****/
    [self addChildVcView];
}

- (void)setupChiledViewController{
    LTAllViewController * all = [[LTAllViewController alloc]init];
    [self addChildViewController:all];
    
    LTVideoViewController * video = [[LTVideoViewController alloc]init];
    [self addChildViewController:video];
    
    LTVoiceViewController *voice = [[LTVoiceViewController alloc]init];
    [self addChildViewController:voice];
    
    LTPictureViewController * picture = [[LTPictureViewController alloc]init];
    [self addChildViewController:picture];
    
    LTWorldViewController * wrold = [[LTWorldViewController alloc]init];
    [self addChildViewController:wrold];
}

- (void)setupNav{
    self.view.backgroundColor = LTCommonBgColor;
    // 标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    // 左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}

- (void)setScrollView{
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = LTCommonBgColor;
    scrollView.frame = self.view.bounds;
    //分页
    scrollView.pagingEnabled = YES;
    //隐藏滚动条(左右)
    scrollView.showsHorizontalScrollIndicator = NO;
    //隐藏滚动条(上下)
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.lt_width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

}

#pragma mark <======  添加子视图控制器  ======>
- (void)addChildVcView{
    // 子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.lt_width;
    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

- (void)setTitleView{
    // 标题栏
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.frame = CGRectMake(0, 64, self.view.lt_width, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 添加标题
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSInteger count = titles.count;
    CGFloat titleButtonW = titlesView.lt_width / count;
    CGFloat titleButtonH = titlesView.lt_height;
    for (NSUInteger i = 0; i < count; i++) {
        // 创建
        LTTitleButton *titleButton = [LTTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        // 设置数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        // 设置frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
    }
    
    // 按钮的选中颜色
    LTTitleButton *firstTitleButton = titlesView.subviews.firstObject;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.lt_height = 1;
    indicatorView.lt_y = titlesView.lt_height - indicatorView.lt_height;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    // 立刻根据文字内容计算label的宽度
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.lt_width = firstTitleButton.titleLabel.lt_width;
    indicatorView.lt_centerX = firstTitleButton.lt_centerX;
    
    // 默认情况 : 选中最前面的标题按钮
    firstTitleButton.selected = YES;
    self.selectedTitleButton = firstTitleButton;
}

/**
 * 控制栏方法
 *
 */
- (void)titleClick:(LTTitleButton *)titleButton{
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LTTitleButtonDidRepeatClickNotification object:nil];
    }
    
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    
    // 指示器
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.lt_width = titleButton.titleLabel.lt_width;
        self.indicatorView.lt_centerX = titleButton.lt_centerX;
    }];
    
    // 让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.lt_width;
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)tagClick{
    LTRecommendTagVCTableViewController * view = [[LTRecommendTagVCTableViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 选中\点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / scrollView.lt_width;
    LTTitleButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    
    // 添加子控制器的view
    [self addChildVcView];
    
    // 当index == 0时, viewWithTag:方法返回的就是self.titlesView
    //    XMGTitleButton *titleButton = (XMGTitleButton *)[self.titlesView viewWithTag:index];
}

@end
