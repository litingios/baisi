//
//  LTBaseViewController.h
//  百思不得姐
//
//  Created by 李霆 on 2018/9/26.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTEssenceModel.h"
#import "UITableView+WebVideoCache.h"

@interface LTBaseViewController : UITableViewController

- (LTModelType)type;

@property(nonatomic, assign, readonly) JPScrollPlayStrategyType scrollPlayStrategyType;

- (instancetype)initWithPlayStrategyType:(JPScrollPlayStrategyType)playStrategyType;

@end
