//
//  UnityViewController.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/16/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//

#import "UnityViewController.h"
#import "LoginSelectViewController.h"
#import "SDKWindowNavController.h"

@interface UnityViewController ()

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *logoutBtn;

@end

@implementation UnityViewController

- (void)viewDidAppear:(BOOL)animated {
    /*****************************************************/
    // 初始化sdk
    [SDK SDKInitWithAppID:@"123456789" unityVC:self];
    /*****************************************************/
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor purpleColor]];
    
    // 登录按钮
    _loginBtn = [[UIButton alloc]init];
    [_loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginBtn setBackgroundColor:[UIColor whiteColor]];
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    // 注销按钮
    _logoutBtn = [[UIButton alloc]init];
    [_logoutBtn setTitle:@"Logout" forState:UIControlStateNormal];
    [_logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_logoutBtn setBackgroundColor:[UIColor whiteColor]];
    [_logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logoutBtn];
    
}

- (void)viewWillLayoutSubviews {
    
    _loginBtn.frame = CGRectMake(10, 100, 100, 25);
    _logoutBtn.frame = CGRectMake(10, 150, 100, 25);
}

/**
 * 1.登录注销
 */
- (void)login {
    
    // 登录接口
    [SDK Login:^(NSInteger result, UserInfo *info) {
        // ... ...
    }];
}
- (void)logout {
    // 注销接口
    [SDK logout:^(NSUInteger result) {
        if (result == 0) {
            // 注销成功
            [XiaoxiSDK showTip:@"Logout successfully"];
            // 隐藏悬浮按钮
            [XHFloatWindow xh_setHideWindow:YES];
        }else {
            // 当前没有用户登录
            [XiaoxiSDK showTip:@"No current account"];
        }
    }];
}

@end
