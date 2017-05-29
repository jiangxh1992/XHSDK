//
//  ParamBase.m
//  Unity-iPhone
//
//  Created by Xinhou Jiang on 6/28/16.
//
//

#import "ParamBase.h"

@implementation ParamBase

- (id)init {
    if ([super init]) {
        _app_id = [XiaoxiSDK Ins].AppID;
        _device = [XiaoxiSDK Ins].DeviceId;
    }
    return self;
}

+(ParamBase *)param {
    return [[ParamBase alloc]init];
}

@end
