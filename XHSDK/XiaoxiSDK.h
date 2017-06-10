//
//  XiaoxiSDK.h
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/30/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "XXRequestIns.h"

// 登录回调代码块，result（0:登录成功，1:登录失败，2:登录取消）
typedef void (^CallbackBlock)(NSInteger result, UserInfo *info);

@class SDKWindowNavController;
@interface XiaoxiSDK : NSObject

@property (nonatomic, strong) NSMutableArray *SavedUsers;          // 获取保存的本地账户
@property (nonatomic, strong) UserInfo *curUser;                   // 登录的账户
@property (nonatomic, strong) XXRequestIns *HttpManager;           // post请求单例

@property (nonatomic, copy) CallbackBlock logincallback;           // 登录回调
@property (nonatomic, copy) CallbackBlock usercentercallback;      // 进入用户中心回调

/**
 * SDK单例
 */
+ (XiaoxiSDK *)Ins;

/**
 * 初始化SDK
 */
- (void)initWithAppID:(NSString *)appid deviceid:(NSString *)deviceid unityVC:(UIViewController *)unityVC;

/**
 * getters
 */
- (NSString *)AppID;
- (NSString *)DeviceId;
- (UIViewController *)unityVC;

/**
 * 本地帐户数据的添加删除
 */
- (void) addSavedUserWithUserInfo: (UserInfo *)userinfo;
- (void) removeUserInfoWithUsername: (NSString *)username;

/**
 *  回调
 */
- (void) returnLoginSuccess: (UserInfo *)info;
- (void) returnLoginCancel;
- (void) returnLoginFailure;

/**
 * 等待提示
 */
+ (void)showWaitingWithTip: (NSString *)tip;
+ (void)hideWaiting;
+ (void)showTip: (NSString *)tip;

@end
