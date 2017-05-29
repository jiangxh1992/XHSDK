//
//  UserCenterViewController.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/30/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//

#import "UserCenterViewController.h"
#import "SavedLoginViewController.h"
#import "RegisterViewController.h"
#import "AccountLoginViewController.h"
#import "OpenWebViewController.h"
#import "LoginSelectViewController.h"
#import "PhoneLoginViewController.h"
#import "TitleButton.h"

@interface UserCenterViewController()

@property (nonatomic, strong)UILabel *curlogin;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10;
    
    [[XiaoxiSDK Ins] floatBtnHide];
    
    // 添加UI
    [self addUI];
}

/**
 *  添加ui
 */
- (void)addUI {
    
    // title
    _curlogin = [[UILabel alloc]init];
    _curlogin.text = [NSString stringWithFormat:@"%@",[XiaoxiSDK Ins].curUser.username];
    _curlogin.font = fontNormal;
    _curlogin.textColor = TextColorNormal;
    [_curlogin sizeToFit];
    [_curlogin setCenter:CGPointMake(self.logoView.frame.size.width/2, self.logoView.frame.size.height + _curlogin.frame.size.height)];
    [self.logoView addSubview:_curlogin];
    
    
    // 创建按钮所在scrollView视图
    UIScrollView *btnScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, SDKWindowW, SDKWindowH - 65)];
    [self.view addSubview:btnScrollView];
    
    // 按钮为一行3个
    int totalloc = 3;
    CGFloat btnViewWH = SDKWindowW * 0.3;
    // 按钮间距
    CGFloat margin = (self.view.frame.size.width - totalloc * btnViewWH) / (totalloc + 1);
    // 按钮总数为5
    int count = 5;
    for (int i = 0; i < count; i++)
    {
        // 行号
        int row = i / totalloc;
        // 列号
        int loc = i % totalloc;
        CGFloat btnViewX = margin + (margin + btnViewWH) * loc;
        CGFloat btnViewY = margin + (margin + btnViewWH) * row;
        // 创建按钮
        TitleButton *btn = [[TitleButton alloc] init];
        btn.tag = i;
        btn.frame = CGRectMake(btnViewX, btnViewY, btnViewWH, btnViewWH);
        btn.titleLabel.font = fontNormal;
        [btn setTitleColor:TextColorNormal forState:UIControlStateNormal];
        // 设置按钮标题和图标
        [self setBtn:btn];
        // 监听点击
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [btnScrollView addSubview:btn];
        
        // 根据最后一个按钮的最大y值计算scrollView视图的contentSize
        if (i == (count - 1) ) {
            btnScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(btn.frame));
        }
    }
    
}

/**
 *  设置按钮标题和图标
 */
- (void)setBtn:(TitleButton *)btn
{
    BOOL isvisitor = [XiaoxiSDK Ins].curUser.IsVisitor;
    NSString *title = isvisitor ? @"Visitor Binidng" : @"User Center";
    NSString *image = isvisitor ? @"xiaoxisdk_channel_visitor" : @"xiaoxisdk_icon_126_home";
    switch (btn.tag)
    {
        case 0:
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
            break;
        case 1:
            [btn setTitle:@"Forum" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"xiaoxisdk_icon_126_discuz"] forState:UIControlStateNormal];
            break;
        case 2:
            [btn setTitle:@"Packages" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"xiaoxisdk_icon_126_gift"] forState:UIControlStateNormal];
            break;
        case 3:
            [btn setTitle:@"Logout" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"xiaoxisdk_icon_126_change"] forState:UIControlStateNormal];
            break;
        case 4:
            [btn setTitle:@"Hide the Ball" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"xiaoxisdk_icon_126_hide"] forState:UIControlStateNormal];
            break;
    }
}

/**
 *  按钮点击相关事件
 */
- (void)click:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
            // 游客绑定
            [self toVisitorBind];
            break;
        case 1:
            // 游戏论坛
            [self toUserCenter];
            break;
        case 2:
            // 礼包领取
            break;
        case 3:
            // 注销账号
            [self toChangeAcc];
            break;
        case 4:
            // 隐藏悬浮球
            break;
        default:
            break;
    }
}

/**
 *  用户中心
 */
- (void)toUserCenter {
    // wenview
    OpenWebViewController *webVC = [[OpenWebViewController alloc]init];
    webVC.url = UserCenterUrl;
    // nav
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    [[XiaoxiSDK Ins].unityVC addChildViewController:navVC];
    [[XiaoxiSDK Ins].unityVC.view addSubview:navVC.view];
}

/**
 *  切换账号
 */
- (void)toChangeAcc {
    if ([[XiaoxiSDK Ins] SavedUsers].count > 0) {
        [self.navigationController pushViewController:[[SavedLoginViewController alloc]init] animated:YES];
    }else {
        [self.navigationController pushViewController:[[LoginSelectViewController alloc]init] animated:NO];
    }
    
}

/**
 *  游客绑定或个人中心
 */
- (void)toVisitorBind {
    
    if (![XiaoxiSDK Ins].curUser.IsVisitor) {
        // 个人中心
        OpenWebViewController *selfCenter = [[OpenWebViewController alloc]init];
        selfCenter.url = UserCenterUrl;
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:selfCenter];
        [self.navigationController.parentViewController addChildViewController:navVC];
        [self.navigationController.view.superview addSubview:navVC.view];
        
    }else {
        // 游客绑定
        PhoneLoginViewController *registerVC = [[PhoneLoginViewController alloc]init];
        registerVC.isBind = YES;
        [self.navigationController pushViewController:registerVC animated:YES];
    }
}

@end
