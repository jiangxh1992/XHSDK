//
//  SDKBaseViewController.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 7/1/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//

#import "SDKBaseViewController.h"

@interface SDKBaseViewController ()

@end

@implementation SDKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 白色背景
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 添加基础UI
    [self addBaseUI];
}

/**
 * 添加基础UI元素
 */
- (void)addBaseUI {
    
    // 添加logo
    UIImage *logo = [UIImage imageNamed:@"unisdk_protocol_logo"];
    _logoView = [[UIImageView alloc]initWithImage:logo];
    _logoView.frame = CGRectMake(0, 0, logoW, logoH);
    _logoView.center = CGPointMake(SDKWindowW/2, UIBorderM + _logoView.frame.size.height/2);
    [self.view addSubview:_logoView];
    
    // 如果不是根控制器添加返回按钮
    if (!_isRoot) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BtnSizeM, BtnSizeM)];
        [_backBtn setImage:[UIImage imageNamed:@"xiaoxisdk_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
    }
    // 关闭按钮
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SDKWindowW - BtnSizeM, 0, BtnSizeM, BtnSizeM)];
    [closeBtn setImage:[UIImage imageNamed:@"xiaoxisdk_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
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
    if ([NSThread isMainThread]){
        // 关闭动画
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.view.center = CGPointMake(ScreenW/2, ScreenH + SDKWindowH);
        } completion:^(BOOL finished) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController.view removeFromSuperview];
            [[XiaoxiSDK Ins] floatBtnShow];
        }];
        
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            // 关闭动画
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationController.view.center = CGPointMake(ScreenW/2, ScreenH + SDKWindowH);
            } completion:^(BOOL finished) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController.view removeFromSuperview];
                [[XiaoxiSDK Ins] floatBtnShow];
            }];
        });
    }
}

@end
