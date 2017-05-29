//
//  UserInfo.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/30/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (UserInfo *)UserInfo:(NSString *)username openid:(NSString *)openid token:(NSString *)token isVisitor:(BOOL)isVisitor {
    UserInfo *info = [[UserInfo alloc]init];
    // 默认头像
    info.avatar = @"xiaoxisdk_user_icon";
    info.username = username;
    info.open_id = openid;
    info.token = token;
    info.IsVisitor = isVisitor;
    return info;
}

@end
