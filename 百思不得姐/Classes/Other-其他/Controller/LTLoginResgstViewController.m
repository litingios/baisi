//
//  LTLoginResgstViewController.m
//  百思不得其解
//
//  Created by 李霆 on 2018/9/14.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTLoginResgstViewController.h"
#import "LTFollowViewController.h"

@interface LTLoginResgstViewController ()<UITextFieldDelegate>
/*** 手机号码输入框 ****/
@property(nonatomic,strong) UITextField *numberTextFile;
/*** 密码输入框 ****/
@property(nonatomic,strong) UITextField *passWroldFile;

@end

@implementation LTLoginResgstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    /*** 创建UI ****/
    [self creatUI];
}

- (void)creatUI{
    NSArray * imageArr = @[@"login_QQ_icon",@"login_sina_icon",@"login_tecent_icon"];
    NSArray * titleArr = @[@"QQ登录",@"微博登录",@"腾讯微博"];
    
    /*** 背景图 ****/
    UIImageView * backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, iPhone_Height)];
    backImage.image = [UIImage imageNamed:@"login_register_background"];
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [backImage addGestureRecognizer:tapGesture];
    [self.view addSubview:backImage];
    /*** 叉号 ****/
    UIButton * closeBtn =[LTControl createButtonWithFrame:CGRectMake(50*WidthScale, 90*HeightScale, 40*WidthScale, 40*WidthScale) ImageName:@"login_close_icon" Target:self Action:@selector(closeBtnCiled) Title:@""];
    [backImage addSubview:closeBtn];
    /*** 注册账号 ****/
    UIButton * rigstBtn =[LTControl createButtonWithFrame:CGRectMake(iPhone_Width-190*WidthScale, 90*HeightScale, 160*WidthScale, 40*WidthScale) ImageName:@"" Target:self Action:@selector(rigstBtnCiled) Title:@"注册账号"];
    rigstBtn.titleLabel.font = FONT(15);
    [backImage addSubview:rigstBtn];
    /*** 输入框背景 ****/
    UIView * shuView = [[UIView alloc]initWithFrame:CGRectMake(100*WidthScale, CGRectGetMaxY(closeBtn.frame)+140*HeightScale, iPhone_Width-200*WidthScale, 200*HeightScale)];
    shuView.backgroundColor = LTColor(71, 57, 61);
    LRViewBorderRadius(shuView, 20*WidthScale, 1, [UIColor clearColor]);
    [backImage addSubview:shuView];
    /*** 输入手机号 ****/
    _numberTextFile = [LTControl createTextFieldWithFrame:CGRectMake(30*WidthScale, 0, shuView.lt_width-60*WidthScale,99.5*HeightScale) placeholder:@"手机号" KeyboardType:UIKeyboardTypeNumberPad Font:18 PlaceColor:[UIColor clearColor]];
    _numberTextFile.delegate = self;
    [shuView addSubview:_numberTextFile];
    /*** 分割线 ****/
    UILabel * lineLable = [LTControl createLineLabWithFrame:CGRectMake(0, CGRectGetMaxY(_numberTextFile.frame), shuView.lt_width, 1*HeightScale)];
    lineLable.backgroundColor = [UIColor grayColor];
    [shuView addSubview:lineLable];
    /*** 输入密码 ****/
    _passWroldFile = [LTControl createTextFieldWithFrame:CGRectMake(30*WidthScale, 100.5*HeightScale, shuView.lt_width-60*WidthScale,99*HeightScale) placeholder:@"密码" KeyboardType:UIKeyboardTypeDefault Font:18 PlaceColor:[UIColor clearColor]];
    _passWroldFile.delegate = self;
    [shuView addSubview:_passWroldFile];
    /*** 登录按钮 ****/
    UIButton * loginBtn = [LTControl createButtonWithFrame:CGRectMake(shuView.lt_x, CGRectGetMaxY(shuView.frame)+30*HeightScale, shuView.lt_width, 70*HeightScale) ImageName:@"" Target:self Action:@selector(loginBtnCiled) Title:@"登录"];
    loginBtn.backgroundColor = LTColor(216, 87, 87);
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LRViewBorderRadius(loginBtn, 10*WidthScale, 1, LTColor(216, 87, 87));
    [backImage addSubview:loginBtn];
    /*** 忘记密码 ****/
    UIButton * forgetBtn =[LTControl createButtonWithFrame:CGRectMake(loginBtn.lt_right-160*WidthScale, loginBtn.lt_bottom+30*HeightScale, 140*WidthScale, 40*WidthScale) ImageName:@"" Target:self Action:@selector(forgetBtnCiled) Title:@"忘记密码?"];
    forgetBtn.titleLabel.font = FONT(15);
    [backImage addSubview:forgetBtn];
    /*** 快速登录 ****/
    UILabel * queckLable = [LTControl createLabelWithFrame:CGRectMake(0, iPhone_Height-350*HeightScale, 160*WidthScale, 40*HeightScale) Font:14 Text:@"快速登录"];
    queckLable.lt_centerX = iPhone_Width/2;
    queckLable.textColor = [UIColor whiteColor];
    queckLable.textAlignment = NSTextAlignmentCenter;
    [backImage addSubview:queckLable];
    /*** 左边渐变线 ****/
    UIImageView *leftLine =[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(queckLable.frame)-460*WidthScale, queckLable.lt_centerY, 300*WidthScale, 2*HeightScale)];
    leftLine.image = [UIImage imageNamed:@"login_register_left_line"];
    [backImage addSubview:leftLine];
    /*** 右边渐变线 ****/
    UIImageView *rightLine =[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(queckLable.frame), queckLable.lt_centerY, 300*WidthScale, 2*HeightScale)];
    rightLine.image = [UIImage imageNamed:@"login_register_right_line"];
    [backImage addSubview:rightLine];
    /*** 三种三方登录 ****/
    for (int i = 0; i<imageArr.count; i++) {
        LTCustomBtn *thirdBtn = [LTCustomBtn buttonWithType:UIButtonTypeCustom];
        thirdBtn.frame = CGRectMake(20*WidthScale+WidthScale+(iPhone_Width)/3*i, rightLine.lt_bottom+30*HeightScale,(iPhone_Width)/3-60*HeightScale, 380*HeightScale);
        thirdBtn.bottomLbl.textColor = [UIColor whiteColor];
        thirdBtn.bottomLbl.font = FONT(18);
        thirdBtn.topImage.image = [UIImage imageNamed:imageArr[i]];
        [thirdBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        thirdBtn.widthScale = 0.8;
        [thirdBtn addTarget:self action:@selector(thirdLoginCiled:) forControlEvents:UIControlEventTouchUpInside];
        [backImage addSubview:thirdBtn];
    }
}

/*** 关闭界面 ****/
- (void)closeBtnCiled{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*** 注册事件 ****/
- (void)rigstBtnCiled{
    
}

/*** 收起键盘 ****/
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

/*** 登录 ****/
- (void)loginBtnCiled{
   
}

/*** 忘记密码 ****/
- (void)forgetBtnCiled{
    
}

/*** 设置状态栏 ****/
- (UIStatusBarStyle)preferredStatusBarStyle{
    //自动在黑白之间进行处理
    return UIStatusBarStyleLightContent;
}

/**
 三方登录按钮
 @param btn
 tag == 1 qq登录
 tag == 2 微博登录
 */
- (void)thirdLoginCiled:(UIButton *)btn{
    
}

#pragma mark <======  键盘协议方法  ======>
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
}
/*** 是否隐藏状态栏 ****/
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}


@end
