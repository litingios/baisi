//
//  LTTabBarController.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/12.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTTabBarController.h"
#import "LTTabBar.h"
#import "LTNavigationController.h"
#import "LTEssenceViewController.h"
#import "LTNewViewController.h"
#import "LTFollowViewController.h"
#import "LTMeViewController.h"

@interface LTTabBarController ()

@end

@implementation LTTabBarController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**** 设置所有UITabBarItem的文字属性 ****/
    [self setupItemTitleTextAttributes];
    
    /**** 添加子控制器 ****/
    [self setupChildViewControllers];
    
    /**** 更换TabBar ****/
    [self setupTabBar];
}

/**
 *  设置所有UITabBarItem的文字属性
 */
- (void)setupItemTitleTextAttributes
{
    UITabBarItem *item = [UITabBarItem appearance];
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateSelected];
}

/**
 *  添加子控制器
 */
- (void)setupChildViewControllers{
    [self setupOneChildViewController:[[LTNavigationController alloc] initWithRootViewController:[[LTEssenceViewController alloc] init]] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    [self setupOneChildViewController:[[LTNavigationController alloc] initWithRootViewController:[[LTEssenceViewController alloc] init]] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self setupOneChildViewController:[[LTNavigationController alloc] initWithRootViewController:[[LTFollowViewController alloc] init]] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    [self setupOneChildViewController:[[LTNavigationController alloc] initWithRootViewController:[[LTMeViewController alloc] init]] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];

}

/**
 *  初始化一个子控制器
 *
 *  @param vc            子控制器
 *  @param title         标题
 *  @param image         图标
 *  @param selectedImage 选中的图标
 */
- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    if (image.length) { // 图片名有具体值
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    [self addChildViewController:vc];
}

/**
 *  更换TabBar
 */
- (void)setupTabBar
{
    //通过KVC进行赋值
    [self setValue:[[LTTabBar alloc] init] forKeyPath:@"tabBar"];
}

@end
