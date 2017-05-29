//
//  SDKWindowNavController.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/30/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//

#import "SDKWindowNavController.h"

@interface SDKWindowNavController ()

@end

@implementation SDKWindowNavController

/**
 *  屏幕旋转调整
 */
- (void)viewWillLayoutSubviews {
    self.view.frame = CGRectMake(0, 0, SDKWindowW, SDKWindowH);
    self.view.center = self.view.superview.center;
}

@end
