//
//  UserInfo.h
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/30/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *avatar;          // 用户头像
@property (nonatomic, copy) NSString *username;        // 用户名
@property (nonatomic, copy) NSString *password;        // 用户密码
@property (nonatomic, copy) NSString *open_id;         // 用户open_id
@property (nonatomic, copy) NSString *token;           // 用户token

@property (nonatomic, assign) BOOL IsVisitor;          // 是否是游客
@property (nonatomic, assign) long long int loginTime; // 用户最近登录时间戳

/**
 *  构造
 */
+(UserInfo *)UserInfo: (NSString *)username openid: (NSString *)openid token: (NSString *)token isVisitor: (BOOL)isVisitor;

@end
