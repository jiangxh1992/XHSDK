//
//  ParamBase.h
//  Unity-iPhone
//
//  Created by Xinhou Jiang on 6/28/16.
//
//

#import <Foundation/Foundation.h>

@interface ParamBase : NSObject

/**
 *  应用ID
 */
@property (nonatomic, copy) NSString *app_id;

/**
 *  设备
 */
@property (nonatomic, copy) NSString *device;

/**
 *  登陆验证码
 */
@property (nonatomic, copy) NSString *token;

/**
 *  用户名／手机号／邮箱
 */
@property (nonatomic, copy) NSString *username;

/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;

/**
 *  新密码
 */
//@property (nonatomic, copy) NSString *newPassword;

/**
 * 手机号
 */
@property (nonatomic, copy) NSString *phone;
/**
 * 验证码
 */
@property (nonatomic, copy) NSString *code;

/**
 *  身份证号
 */
@property (nonatomic, copy) NSString *id_num;

/**
 *  身份证姓名
 */
@property (nonatomic, copy) NSString *id_name;

/**
 *  邮箱
 */
@property (nonatomic, copy) NSString *email;

/**
 * param
 */
+(ParamBase *)param;

@end