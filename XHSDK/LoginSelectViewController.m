//
//  LoginSelectViewController.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/7/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//
#define bgMargin 40
#import "LoginSelectViewController.h"
#import "AccountLoginViewController.h"
#import "SavedLoginViewController.h"
#import "UserCenterViewController.h"
#import "PhoneLoginViewController.h"
#import "TitleButton.h"

@interface LoginSelectViewController ()

/**
 * bgview
 */
@property (nonatomic, strong)UIView *bgView;

/**
 *  错误提示
 */
@property (nonatomic, strong) UILabel *tips;

@end

@implementation LoginSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // bg
    [self.view setBackgroundColor:[UIColor clearColor]];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, bgMargin, SDKWindowW, SDKWindowH - 2*bgMargin)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    // 添加UI
    [self addBaseUI];
}

/**
 * 添加基础UI元素
 */
- (void)addBaseUI {
    
    // 如果不是根控制器添加返回按钮
    if (!self.isRoot) {
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BtnSizeM, BtnSizeM)];
        [backBtn setImage:[UIImage imageNamed:@"xiaoxisdk_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:backBtn];
    }
    
    // 添加logo
    UIImage *logo = [UIImage imageNamed:@"unisdk_protocol_logo"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:logo];
    logoView.frame = CGRectMake(0, 0, logoW, logoH);
    logoView.center = CGPointMake(SDKWindowW/2, UIBorderM + logoView.frame.size.height/2);
    [_bgView addSubview:logoView];
    
    // 关闭按钮
    // 如果不是根控制器添加返回按钮
    if (self.navigationController.viewControllers > 0) {
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SDKWindowW - BtnSizeM, 0, BtnSizeM, BtnSizeM)];
        [closeBtn setImage:[UIImage imageNamed:@"xiaoxisdk_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:closeBtn];
    }
    
    // 提示
    _tips = [[UILabel alloc]initWithFrame:CGRectMake(0, logoView.frame.origin.y + logoView.frame.size.height + 5, SDKWindowW, 20)];
    [_tips setTextAlignment:NSTextAlignmentCenter];
    [_tips setText:@""];
    [_tips setFont:fontSmall];
    [_tips setTextColor:[UIColor redColor]];
    [_bgView addSubview:_tips];
    
    // 快速游戏按钮
    TitleButton *leftBtn = [[TitleButton alloc]initWithFrame:CGRectMake(0, SDKWindowH/4, SDKWindowW/3, SDKWindowW/3)];
    [leftBtn setImage:[UIImage imageNamed:@"xiaoxisdk_channel_visitor"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"Visitor" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = fontNormal;
    [leftBtn setTitleColor:TextColorNormal forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(instantLogin) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:leftBtn];
    
    // 手机快速登录按钮
    TitleButton *phoneBtn = [[TitleButton alloc]initWithFrame:CGRectMake(SDKWindowW/3, SDKWindowH/4, SDKWindowW/3, SDKWindowW/3)];
    [phoneBtn setImage:[UIImage imageNamed:@"xiaoxisdk_channel_phone"] forState:UIControlStateNormal];
    [phoneBtn setTitle:@"PhoneNumber" forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = fontNormal;
    [phoneBtn setTitleColor:TextColorNormal forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneLogin) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:phoneBtn];
    
    // 小西账号登录按钮
    TitleButton *rightBtn = [[TitleButton alloc]initWithFrame:CGRectMake(SDKWindowW/3*2, SDKWindowH/4, SDKWindowW/3, SDKWindowW/3)];
    [rightBtn setTitle:@"Account" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"xiaoxisdk_channel_account"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = fontNormal;
    [rightBtn setTitleColor:TextColorNormal forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(xiaoxiLogin) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:rightBtn];
    
    // 推荐标志
    UIButton *flag = [[UIButton alloc]initWithFrame:CGRectMake(BtnSize/2+5, 5, BtnSize/2, BtnSize/4)];
    [flag setBackgroundImage:[UIImage imageNamed:@"xiaoxisdk_channel_hot"] forState:UIControlStateNormal];
    [flag setTitle:@"Hot" forState:UIControlStateNormal];
    flag.titleLabel.font = fontSmall;
    [rightBtn addSubview:flag];
}

/**
 *  返回
 */
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  关闭
 */
- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController.view removeFromSuperview];
}

/**
 * 主线程更新错误提示
 */
- (void)updateTipWithString: (NSString *)tip {
    if ([NSThread isMainThread]){
        _tips.text = tip;
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            _tips.text = tip;
        });
    }
}

/**
 *  快速游戏
 */
- (void)instantLogin {
    
    [XiaoxiSDK showWaitingWithTip:@"Logining..."];
    
    ParamBase *param = [ParamBase param];
    
    [[XiaoxiSDK Ins].HttpManager postAPIWithM:@"User" A:@"RegisterVisitor" P:param.mj_keyValues success:^(id json) {
        [XiaoxiSDK hideWaiting];
        NSNumber *code = [json objectForKey:@"code"];
        if ([code isEqual:@0]) {
            // 取出data
            NSDictionary *datadic = [json objectForKey:@"data"];
            UserInfo *info = [UserInfo mj_objectWithKeyValues:datadic];
            info.avatar = @"xiaoxisdk_user_icon";
            info.IsVisitor = YES;
            // 登录时间戳
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            info.loginTime = (long long int)time;
            // 登录成功
            [[XiaoxiSDK Ins] returnLoginSuccess:info];
            // 关闭登录窗口
            [self close];
        }
        else {
            [[XiaoxiSDK Ins] returnLoginFailure];
            [self updateTipWithString:[json objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [XiaoxiSDK hideWaiting];
        [[XiaoxiSDK Ins] returnLoginFailure];
        [self updateTipWithString:ErrorTip];
    }];
    
}

/**
 * 手机快速登录
 */
- (void)phoneLogin {
    PhoneLoginViewController *phoneLogin = [[PhoneLoginViewController alloc]init];
    phoneLogin.isBind = NO;
    [self.navigationController pushViewController:phoneLogin animated:YES];
}

/**
 * 小西账号登录
 */
- (void)xiaoxiLogin {
    
        if ([XiaoxiSDK Ins].SavedUsers.count > 0) {
            [self.navigationController pushViewController:[[SavedLoginViewController alloc]init] animated:YES];
        }else{
            AccountLoginViewController *accountVC = [[AccountLoginViewController alloc]init];
            accountVC.isBind = NO;
            [self.navigationController pushViewController:accountVC animated:YES];
        }
}

@end
