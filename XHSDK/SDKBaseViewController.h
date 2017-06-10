//
//  SDKBaseViewController.h
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 7/1/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//  基本视图控制类

#import <UIKit/UIKit.h>

@interface SDKBaseViewController : UIViewController

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, assign) BOOL isRoot;

- (void) back;
- (void) close;

/**
 * 覆盖父类方法添加基础UI元素
 */
- (void)addBaseUI;

@end
