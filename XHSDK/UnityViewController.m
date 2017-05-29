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
@property (nonatomic, strong) UIButton *userCenter;
@property (nonatomic, strong) UIButton *payBtn;

@end

@implementation UnityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor purpleColor]];
    
    /*****************************************************/
    // 初始化sdk
    [SDK SDKInitWithAppID:@"46571891337916" unityVC:self];
    /*****************************************************/
    
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
    
    // 用户中心
    _userCenter = [[UIButton alloc]init];
    [_userCenter setTitle:@"User Center" forState:UIControlStateNormal];
    [_userCenter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_userCenter setBackgroundColor:[UIColor whiteColor]];
    [_userCenter addTarget:self action:@selector(user) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userCenter];
    
}

- (void)viewWillLayoutSubviews {
    
    _loginBtn.frame = CGRectMake(10, 100, 100, 25);
    _logoutBtn.frame = CGRectMake(10, 150, 100, 25);
    _userCenter.frame = CGRectMake(10, 200, 100, 25);
    _payBtn.frame = CGRectMake(10, 250, 100, 25);
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
        }else {
            // 当前没有用户登录
            [XiaoxiSDK showTip:@"No current account"];
        }
    }];
}

/**
 * 2.用户中心
 */
- (void)user {
    // 进入用户中心接口
    [SDK EnterUserCenter:^(NSInteger result, UserInfo *info) {
       // ... ...
    }];
}

@end
