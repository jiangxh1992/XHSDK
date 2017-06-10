//
//  OpenWebViewController.h
//  Demo
//
//  Created by 919575700@qq.com on 10/15/15.
//  Copyright (c) 2015 Jiangxh. All rights reserved.
//  WEB视图控制器

#import <UIKit/UIKit.h>

@interface OpenWebViewController : UIViewController

/**
 *  webview
 */
@property (nonatomic, strong)UIWebView *webView;

/**
 *  url
 */
@property (nonatomic, copy)NSString *url;

@end
