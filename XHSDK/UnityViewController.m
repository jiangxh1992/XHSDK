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
}

- (void)viewWillLayoutSubviews {
    
    _loginBtn.frame = CGRectMake(10, 100, 100, 25);
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

@end
