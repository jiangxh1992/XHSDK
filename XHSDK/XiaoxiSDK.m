//
//  XiaoxiSDK.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/30/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//

#import "XiaoxiSDK.h"
#import "AccountLoginViewController.h"
#import "SavedLoginViewController.h"
#import "RegisterViewController.h"
#import "UserCenterViewController.h"
#import "LoginSelectViewController.h"
#import "SDKWindowNavController.h"

@interface XiaoxiSDK()

@property (nonatomic, strong) NSString *AppID;
@property (nonatomic, strong) NSString *DeviceId;
@property (nonatomic, weak) UIViewController *unityVC;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation XiaoxiSDK

- (id)init {
    if ([super init]) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)initWithAppID:(NSString *)appid deviceid:(NSString *)deviceid unityVC:(UIViewController *)unityVC {
    _AppID = appid;
    _DeviceId = deviceid;
    _unityVC = unityVC;
}

#pragma mark - getters
/**
 * SDK单例
 */
+ (XiaoxiSDK *)Ins {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)AppID {
    return _AppID;
}
- (NSString *)DeviceId {
    return _DeviceId;
}

- (UIViewController *)unityVC {
    return _unityVC;
}
- (NSMutableArray *)SavedUsers {
    
    // 读取字符串数据
    NSString *data = [_defaults objectForKey:@"sdkUsers"];
    if (!data) {
        return nil;
    }
    // 解密
    NSString *dataS = [DES3Util AES128Decrypt:data];
    // 去掉末尾的\0\0\0...
    const char *convert = [dataS UTF8String];
    NSString *jsonTrim = [NSString stringWithCString:convert encoding:NSUTF8StringEncoding];
    // 字符串转json
    NSMutableArray *usersKeyValues = [NSJSONSerialization JSONObjectWithData:[jsonTrim dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    // 转成对象
    NSMutableArray *users = [UserInfo mj_objectArrayWithKeyValuesArray:usersKeyValues];
    return users;
}
- (XXRequestIns *)HttpManager {
    return [XXRequestIns Ins];// 加密post
}

/**
 *  回调
 */
- (void) returnLoginSuccess: (UserInfo *)info {
    // 添加新本地用户并更新当前登录用户
    _curUser = info;
    [self addSavedUserWithUserInfo:info];
    NSMutableArray *arr = [self SavedUsers];
    NSLog(@"%@",arr);
    
    // 显示悬浮窗
    [XHFloatWindow xh_setHideWindow:NO];
    
    [XiaoxiSDK showTip:[NSString stringWithFormat:@"%@:Wellcome!",[XiaoxiSDK Ins].curUser.username]];
    
    // 回调
    if (_logincallback) {
        _logincallback(0,info);
    }
}
- (void) returnLoginCancel {
    if (_logincallback) {
        _logincallback(2,nil);
    }
}
- (void) returnLoginFailure {
    if (_logincallback) {
        _logincallback(1,nil);
    }
}

/**
 * 本地帐户数据的添加删除
 */
- (void) addSavedUserWithUserInfo:(UserInfo *)userinfo {
    NSMutableArray *users = [self SavedUsers];
    if (!users) {
        users = [[NSMutableArray alloc]init];
    }
    // 遍历判断是否有重复数据
    if (users) {
        for (int i = 0; i < users.count; i++) {
            UserInfo *acc = users[i];
            if ([acc.username isEqualToString:userinfo.username]) {
                // 如果重复删掉旧的存入新的
                NSNumber *indexNum = [NSNumber numberWithInt:i];
                [users removeObjectAtIndex:[indexNum integerValue]];
            }
        }
    }
    // 添加新数据
    [users addObject:userinfo];
    
    NSMutableArray *dicArr = [NSMutableArray mj_keyValuesArrayWithObjectArray:users];
    NSString *jsonS = [dicArr mj_JSONString];
    // 加密
    NSString *aes128 = [DES3Util AES128Encrypt:jsonS];
    // 重新写入
    [_defaults setObject:aes128 forKey:@"sdkUsers"];
}

- (void) removeUserInfoWithUsername:(NSString *)username {
    NSMutableArray *users = [self SavedUsers];
    if (!users) {
        users = [[NSMutableArray alloc]init];
    }
    if (users) {
        // 搜索删除
        UserInfo *toRemove;
        for (UserInfo *search in users) {
            if ([search.username isEqualToString:username]) {
                toRemove = search;
                break;
            }
        }
        [users removeObject:toRemove];
        NSMutableArray *dicArr = [NSMutableArray mj_keyValuesArrayWithObjectArray:users];
        NSString *jsonS = [dicArr mj_JSONString];
        // 加密
        NSString *aes128 = [DES3Util AES128Encrypt:jsonS];
        // 重新写入
        [_defaults setObject:aes128 forKey:@"sdkUsers"];
    }
}
/**
 * 等待提示
 */
+ (void)showWaitingWithTip:(NSString *)tip {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 添加hud
        [XiaoxiSDK Ins].hud = [MBProgressHUD showHUDAddedTo:[XiaoxiSDK Ins].unityVC.view.window animated:YES];
        [XiaoxiSDK Ins].hud.removeFromSuperViewOnHide = YES;
        [XiaoxiSDK Ins].hud.label.text = tip;
    });
}
+ (void)hideWaiting {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[XiaoxiSDK Ins].hud hideAnimated:YES];
    });
}
+ (void)showTip:(NSString *)tip {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[XiaoxiSDK Ins].unityVC.view.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = tip;
        hud.label.font = fontSmall;
        hud.offset = CGPointMake(0.f, -MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:1.5f];
    });
}

@end
