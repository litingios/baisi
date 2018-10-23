//
//  LTClearCell.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/18.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTClearCell.h"

#define ClearPath  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/default"]

@implementation LTClearCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = NSStringFromClass([self class]);
    LTClearCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LTClearCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /*** 创建UI ****/
        [self creatUI];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)creatUI{
    //转圈
    UIActivityIndicatorView * loadView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [loadView startAnimating];
    self.accessoryView = loadView;
    self.textLabel.text = @"清除缓存(正在计算缓存大小...)";
    __weak typeof(self) weakSelf = self;
    //子线程计算缓存大小
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        /*** cachePath获取到Caches文件夹 ****/
//        NSString * cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        /*** 强制sleep ****/
        [NSThread sleepForTimeInterval:2.0];
        
        /*** 拼接到default文件夹路径 ****/
        unsigned long long size = ClearPath.fileSize;
        size += [SDImageCache sharedImageCache].getSize;
        
        /*** 发现weakSelf被block释放则返回 ****/
        if(weakSelf == nil) return ;
        
        NSString * sizeText = nil;
        if (size >= pow(10, 9)) {
            //大于1G
            sizeText = [NSString stringWithFormat:@"%.1fGB",size/pow(10, 9)];
        }else if (size >= pow(10, 6)){
            //大于1G小于1MB
            sizeText = [NSString stringWithFormat:@"%.1fMB",size/pow(10, 6)];
        }else if(size >= pow(10, 3)){
            //大于1KB小于1MB
            sizeText = [NSString stringWithFormat:@"%.1fMB",size/pow(10, 3)];
        }else{
            //小于1KB
            sizeText = [NSString stringWithFormat:@"%lluB",size];
        }
        //生成文字
        NSString * text = [NSString stringWithFormat:@"清除缓存(%@)",sizeText];
        
        //回到主线程设置文字
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.textLabel.text = text;
            weakSelf.accessoryView = nil;
            weakSelf.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //添加手势监听
            [weakSelf addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearCache)]];
            weakSelf.userInteractionEnabled = YES;
        });
    });
}

/*** 清除缓存 ****/
- (void)clearCache{
    //弹出指示器
    [SVProgressHUD showWithStatus:@"正在清除缓存"];
    //删除缓存 SDWebImage
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //自定义缓存
            NSFileManager *mgr = [[NSFileManager alloc]init];
            [mgr removeItemAtPath:ClearPath error:nil];
            [mgr createDirectoryAtPath:ClearPath withIntermediateDirectories:YES attributes:nil error:nil];
        });
        
        //所有的缓存全部清除完毕
        dispatch_async(dispatch_get_main_queue(), ^{
            /*** 强制sleep ****/
            [NSThread sleepForTimeInterval:2.0];
            //释放指示器
            [SVProgressHUD dismiss];
            //设置文字
            self.textLabel.text = @"清除缓存(0B)";
        });
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    /*** 界面的重新布局 ****/
    UIActivityIndicatorView * loadingView = (UIActivityIndicatorView *)self.accessoryView;
    [loadingView startAnimating];
}

@end
