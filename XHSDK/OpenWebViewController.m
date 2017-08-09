//
//  OpenWebViewController.m
//  Demo
//
//  Created by 919575700@qq.com on 10/15/15.
//  Copyright (c) 2015 Jiangxh. All rights reserved.
//
#import "OpenWebViewController.h"

@interface OpenWebViewController ()<UIWebViewDelegate>

@end

@implementation OpenWebViewController

/**
 *  视图加载
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _url;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // webview
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    //自适应
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    _webView.scalesPageToFit = YES;
    //设置webview的代理
    _webView.delegate = self;
    //添加到页面
    [self.view addSubview:_webView];
    
    // 导航栏按钮
    UIButton *preBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 20)];
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 20)];
    [preBtn setImage:[UIImage imageNamed:XHIMG_LEFTARROW] forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage imageNamed:XHIMG_RIGHTARROW] forState:UIControlStateNormal];
    [preBtn addTarget:self action:@selector(prePage) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *Pre = [[UIBarButtonItem alloc]initWithCustomView:preBtn];
    UIBarButtonItem *Next = [[UIBarButtonItem alloc]initWithCustomView:nextBtn];
    UIBarButtonItem *Refresh = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    self.navigationItem.leftBarButtonItems = @[Pre,Next,Refresh];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //打开网址页面
    [self loadWebViewWithString:_url];
}

/**
 *  加载网址页面
 */
- (void)loadWebViewWithString:(NSString*)urlStr {
    // 网址字符串转URL
    NSURL *url = [NSURL URLWithString:urlStr];
    // url请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 加载url请求
    [_webView loadRequest:request];
}

/**
 *  上一页
 */
- (void)prePage {
    if ([_webView canGoForward]) {
        [_webView goBack];
    }
}

/**
 * 下一页
 */
- (void)nextPage {
    if ([_webView canGoBack]) {
        [_webView goForward];
    }
}

/**
 *  重新加载
 */
- (void)refresh {
    [_webView reload];
}

/**
 *  关闭
 */
- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController.view removeFromSuperview];
}

#pragma mark webview委托方法
/**
 *  开始加载
 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //[[XiaoxiSDK Ins] showWaitingWithTip:@"加载中..."];
    NSLog(@"开始加载...");
}

/**
 *  加载完成
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //[[XiaoxiSDK Ins] hideWaiting];
    NSLog(@"加载完成...");
}

/**
 *  加载出错
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //[[XiaoxiSDK Ins] hideWaiting];
    NSLog(@"加载出错！");
}

@end
