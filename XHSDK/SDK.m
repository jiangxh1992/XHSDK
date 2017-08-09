//
//  SDK.m
//  XXSDK
//
//  Created by Xinhou Jiang on 7/8/16.
//  Copyright © 2016 Xiaoxi Tech. All rights reserved.
//


#import "SDK.h"
#import "SDKBaseViewController.h"
#import "AccountLoginViewController.h"
#import "SavedLoginViewController.h"
#import "RegisterViewController.h"
#import "UserCenterViewController.h"
#import "LoginSelectViewController.h"
#import "SDKWindowNavController.h"

@implementation SDK

/**
 * 初始化接口
 */
+ (void)SDKInitWithAppID:(NSString *)appid unityVC:(UIViewController *)unityVC{
    NSString *adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[XiaoxiSDK Ins] initWithAppID:appid deviceid:adid unityVC:unityVC];

    [XHFloatWindow xh_addWindowOnTarget:unityVC onClick:^{
        // 隐藏悬浮按钮
        [XHFloatWindow xh_setHideWindow:YES];
        // 进入用户中心接口
        [SDK EnterUserCenter:^(NSInteger result, UserInfo *info) {
            
        }];
    }];
    
    [XHFloatWindow xh_setBackgroundImage:XHIMG_CHANNEL_ACCOUNT forState:UIControlStateNormal];
    // 默认隐藏悬浮按钮
    [XHFloatWindow xh_setHideWindow:YES];
}

/**
 *  登录
 */
+ (void)Login:(void (^)(NSInteger, UserInfo *))callback {
    if (!callback) {
        return;
    }
    if (![XiaoxiSDK Ins].AppID) {
        NSLog(@"%@",@"SDK未初始化!");
    }
    // 创建我们需要打开的view
    SDKBaseViewController *loginVC;
    if ([XiaoxiSDK Ins].SavedUsers.count > 0) {
        loginVC = [[SavedLoginViewController alloc]init];
        loginVC.isRoot = YES;
    }else {
        loginVC = [[LoginSelectViewController alloc]init];
        loginVC.isRoot = YES;
    }
    //添加一个自定义导航视图
    SDKWindowNavController *navVC = [[SDKWindowNavController alloc] initWithRootViewController:loginVC];
    navVC.view.center = CGPointMake(ScreenW/2, 0);
    // 隐藏导航条
    [navVC.navigationBar setHidden:YES];
    //添加到Unity场景的rootview
    [[XiaoxiSDK Ins].unityVC addChildViewController:navVC];
    [[XiaoxiSDK Ins].unityVC.view addSubview:navVC.view];
    // 登录界面弹出动画
    [UIView animateWithDuration:0.3 animations:^{
        navVC.view.center = [XiaoxiSDK Ins].unityVC.view.center;
    }];
    // 回调sdk引用
    [XiaoxiSDK Ins].logincallback = callback;
}

/**
 * 进入用户中心
 */
+ (void)EnterUserCenter:(void (^)(NSInteger, UserInfo *))callback {
    if (!callback) {
        return;
    }
    if (![XiaoxiSDK Ins].AppID) {
        NSLog(@"%@",@"SDK未初始化!");
    }
    // 回调sdk引用
    [XiaoxiSDK Ins].usercentercallback = callback;
    if ([XiaoxiSDK Ins].curUser) {
        //添加一个自定义导航视图
        UserCenterViewController *userVC = [[UserCenterViewController alloc]init];
        userVC.isRoot = YES;
        SDKWindowNavController *navVC = [[SDKWindowNavController alloc]initWithRootViewController:userVC];
        navVC.view.center = CGPointMake(ScreenW/2, 0);
        // 隐藏导航条
        [navVC.navigationBar setHidden:YES];
        //添加到Unity场景的rootview
        [[XiaoxiSDK Ins].unityVC addChildViewController:navVC];
        [[XiaoxiSDK Ins].unityVC.view addSubview:navVC.view];
        // 用户中心界面弹出动画
        [UIView animateWithDuration:0.3 animations:^{
            navVC.view.center = [XiaoxiSDK Ins].unityVC.view.center;
        }];
    }else {
        // 没有登录用户，不允许进入用户中心
        [XiaoxiSDK showTip:@"没有登录用户，不允许进入用户中心"];
        callback(1,nil);
    }
}

@end
