//
//  XXRequestIns.m
//  JXHDemo
//
//  Created by Xinhou Jiang on 6/29/16.
//  Copyright © 2016 Jiangxh. All rights reserved.
//
#import "XXRequestIns.h"

@interface XXRequestIns()

/**
 * session
 */
@property(nonatomic, strong)NSURLSession *session;

@end

@implementation XXRequestIns

/**
 *  获取单例对象
 */
+ (XXRequestIns *)Ins
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 *  init
 */
- (id)init
{
    if (self = [super init])
    {
        _session = [NSURLSession sharedSession];
    }
    return self;
}

/**
 *  发送MAP请求
 */
- (void)postAPIWithM:(NSString *)m A:(NSString *)a P:(NSDictionary *)p success:(void (^)(id json))success failure:(void(^)(NSError *))flaiure {
    // 组装参数
    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    [map setObject:m forKey:@"m"];
    [map setObject:a forKey:@"a"];
    [map setObject:p forKey:@"p"];
    NSString *json = [map mj_JSONString];
    NSLog(@"参数：%@",json);
    NSString *aes128 = [DES3Util AES128Encrypt:json];//  加密
    NSString *pack = [NSString stringWithFormat:@"pack=%@",[self AES128Convert:aes128]];
    
    // 请求
    [self POST:ApiUrl form:pack success:^(id data) {
        success(data);
    } failure:^(NSError *error) {
        flaiure(error);
    }];
}

/**
 * Post with dic
 */
- (void)POSTWithUrl:(NSString *)url param:(NSDictionary *)dic success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *json = [dic mj_JSONString];
    NSString *param = [NSString stringWithFormat:@"param=%@",json];
    [self POST:url form:param success:^(id json) {
        success(json);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 * Post base
 */
- (void)POST:(NSString *)Apiurl form:(NSString *)param success:(void (^)(id json))success failure:(void (^)(NSError *))failure {
    // 根据会话对象创建task
    NSURL *URL = [NSURL URLWithString:Apiurl];
    // 创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    // 修改请求方法为POST
    request.HTTPMethod = @"POST";
    // 参数
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    // 请求超时
    request.timeoutInterval = 30;
    //根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 解密解析数据
        id aesjson = [self decrypeJsonWithData:data];
        if (!error) {
            success(aesjson);
            NSLog(@"返回数据：%@",aesjson);
        }else {
            failure(error);
        }
    }];
    //执行任务
    [dataTask resume];
}

/**
 *  NSData转JSON(解密)
 */
- (id)decrypeJsonWithData:(NSData *)data
{
    // 转成字符串
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 2 解密
    //jsonStr = [DES3Util AES128Decrypt:jsonStr];
    // 去掉末尾的\0\0\0...
    //const char *convert = [jsonStr UTF8String];
    //NSString *jsonTrim = [NSString stringWithCString:convert encoding:NSUTF8StringEncoding];
    // 3 转json
    return [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}

/**
 *  aes128加密后的密文编码处理，参数为128加密后的密文
 */
- (NSString *)AES128Convert: (NSString *)aes128 {
    
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    
    return [aes128 stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

@end
