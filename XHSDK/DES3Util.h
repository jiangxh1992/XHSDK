//
//  DES3Util.h
//  Unity-iPhone
//
//  Created by Xinhou Jiang on 6/28/16.
//
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject

// 加密
+ (NSString*) AES128Encrypt:(NSString *)plainText;
// 解密
+ (NSString*) AES128Decrypt:(NSString *)encryptText;

@end
