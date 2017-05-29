//
//  XXRequestIns.h
//  JXHDemo
//
//  Created by Xinhou Jiang on 6/29/16.
//  Copyright © 2016 Jiangxh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXRequestIns : NSObject

/**
 *  获取QueuesSingleton单例对象
 */
+ (XXRequestIns *)Ins;

/**
 *  POST请求
 */
- (void) postAPIWithM: (NSString *)m A: (NSString *)a P: (NSDictionary *)p success:(void(^)(id json))success failure: (void(^)(NSError *error))flaiure;

/**
 * POSTBASE
 */
- (void) POST: (NSString *)Apiurl form: (NSString *)param success:(void(^)(id json))success failure: (void(^)(NSError *error))flaiure;

@end
