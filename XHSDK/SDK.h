//
//  SDK.h
//  XXSDK
//
//  Created by Xinhou Jiang on 7/8/16.
//  Copyright © 2016 Xiaoxi Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface SDK : NSObject

/**
 * 初始化接口
 */
+ (void)SDKInitWithAppID: (NSString *)appid unityVC:(UIViewController *)unityVC;

/**
 * 登录
 */
+ (void)Login:(void(^)(NSInteger result, UserInfo *info))callback;

/**
 * 进入用户中心
 */
+ (void)EnterUserCenter:(void(^)(NSInteger result, UserInfo *info))callback;

@end
