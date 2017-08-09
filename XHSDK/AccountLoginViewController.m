//
//  AccountLoginViewController.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/7/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//

#import "AccountLoginViewController.h"
#import "RegisterViewController.h"
#import "OpenWebViewController.h"
#import "UserInfo.h"

@interface AccountLoginViewController ()<UITextFieldDelegate>

/**
 *  当前编辑的输入框
 */
@property (nonatomic, strong) UITextField *curInput;

/**
 * 输入框防遮挡调整的offset
 */
@property (nonatomic) CGFloat offset;

/*
 * 视图原frame,用于恢复视图位置
 */
@property (nonatomic) CGRect originalFrame;

/**
 * 账号输入框
 */
@property (nonatomic, strong) UITextField *account;

/**
 * 密码输入框
 */
@property (nonatomic, strong) UITextField *password;

/**
 *  webview
 */
@property (nonatomic, strong) UIWebView *webView;

/**
 *  错误提示
 */
@property (nonatomic, strong) UILabel *tips;

@end

@implementation AccountLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 初始化
    [self initElement];
    // 添加UI
    [self addUI];
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  初始化
 */
- (void) initElement {
    _originalFrame = self.view.frame;
}

/**
 * 添加UI元素
 */
- (void)addUI {
    // 帐号输入框
    _account = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
    _account.center = CGPointMake(SDKWindowW/2, self.logoView.frame.origin.y + self.logoView.frame.size.height+inputH/2+UIBorder);
    //_account.borderStyle = UITextBorderStyleLine;
    //_account.layer.borderWidth = 0.5;
    //_account.layer.borderColor = [RGBColor(230, 230, 230) CGColor];
    [_account setBackground:[UIImage imageNamed:XHIMG_INPUTBG]];
    UIImageView *accountLView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:XHIMG_ICON_USER]];
    accountLView.frame = CGRectMake(0, 0, inputH, inputH);
    _account.leftView = accountLView;
    _account.leftViewMode = UITextFieldViewModeAlways;
    _account.placeholder = @"Phone number／Account／Email";
    _account.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _account.font = fontNormal;
    _account.delegate = self;
    [self.view addSubview:_account];
    
    // 密码输入框
    _password = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
    _password.center = CGPointMake(SDKWindowW/2, _account.frame.origin.y+_account.frame.size.height+inputH/2+UIBorderS);
    //_password.borderStyle = UITextBorderStyleLine;
    //_password.layer.borderWidth = 0.5;
    //_password.layer.borderColor = [UIColor colorWithRed:230 green:230 blue:230 alpha:1.0].CGColor;
    [_password setBackground:[UIImage imageNamed:XHIMG_INPUTBG]];
    UIImageView *pswLView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:XHIMG_ICON_FORGET]];
    pswLView.frame = CGRectMake(0, 0, inputH, inputH);
    _password.leftView = pswLView;
    _password.leftViewMode = UITextFieldViewModeAlways;
    _password.placeholder = @"Please input  password";
    _password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _password.font = fontNormal;
    _password.delegate = self;
    _password.secureTextEntry = YES;
    [self.view addSubview:_password];
    
    // 提示
    _tips = [[UILabel alloc]initWithFrame:CGRectMake(0, _password.frame.origin.y + _password.frame.size.height + UIBorderM/2, SDKWindowW, 20)];
    [_tips setTextAlignment:NSTextAlignmentCenter];
    [_tips setText:@""];
    [_tips setFont:fontSmall];
    [_tips setTextColor:[UIColor redColor]];
    [self.view addSubview:_tips];
    
    // 登录游戏按钮
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
    [loginBtn setBackgroundColor:LoginBtnColor];
    NSString *title = _isBind ? @"Binding" : @"Login";
    [loginBtn setTitle:title forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = fontLarge;
    loginBtn.center = CGPointMake(SDKWindowW/2, _tips.frame.origin.y + _tips.frame.size.height +loginBtn.frame.size.height/2);
    // 按钮事件
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    // 忘记密码按钮
    UIButton *forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inputH, inputH)];
    [forgetBtn setBackgroundImage:[UIImage imageNamed:XHIMG_ICON_FORGET] forState:UIControlStateNormal];
    forgetBtn.center = CGPointMake(forgetBtn.frame.size.width/2 + UIBorderM*4, loginBtn.center.y + loginBtn.frame.size.height + 5);
    // 按钮事件
    [forgetBtn addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    // 标签
    UIButton *forgetTip = [[UIButton alloc]init];
    [forgetTip setTitle:@"Forget password>" forState:UIControlStateNormal];
    forgetTip.titleLabel.font = fontSmall;
    [forgetTip setTitleColor:TextColorNormal forState:UIControlStateNormal];
    [forgetTip sizeToFit];
    forgetTip.center = CGPointMake(forgetBtn.center.x, forgetBtn.center.y + forgetBtn.frame.size.height/2 + 5);
    [forgetTip addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetTip];
    
    // 帐号注册按钮
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inputH, inputH)];
    [registerBtn setBackgroundImage:[UIImage imageNamed:XHIMG_ICON_USER] forState:UIControlStateNormal];
    registerBtn.center = CGPointMake(SDKWindowW - registerBtn.frame.size.width/2 - UIBorderM*4, loginBtn.center.y + loginBtn.frame.size.height + 5);
    // 按钮事件
    [registerBtn addTarget:self action:@selector(regNewAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    // 标签
    UIButton *regTip = [[UIButton alloc]init];
    [regTip setTitle:@"Register>" forState:UIControlStateNormal];
    regTip.titleLabel.font = fontSmall;
    [regTip setTitleColor:TextColorNormal forState:UIControlStateNormal];
    [regTip sizeToFit];
    regTip.center = CGPointMake(registerBtn.center.x, registerBtn.center.y + registerBtn.frame.size.height/2 + 5);
    [regTip addTarget:self action:@selector(regNewAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regTip];
}

/**
 *  登录游戏
 */
- (void)login {
    // 账号密码
    NSString *account = _account.text;
    NSString *password = _password.text;
    if (([account isEqual: @""]) || ([password isEqual: @""])) {
        _tips.text = @"Account or password can not be empty";
        return;
    }
    
    // 登录提示
    [XiaoxiSDK showWaitingWithTip:@"Logining..."];
    
    // 请求数据库验证
    ParamBase *p = [ParamBase param];
    p.username = account;
    p.password = password;
    
    // 普通登录
    [[XXRequestIns Ins] POSTWithUrl:UrlLogin param:p.mj_keyValues success:^(id json) {
        [XiaoxiSDK hideWaiting];
        NSNumber *code = [json objectForKey:@"code"];
        if ([code isEqual:@0]) {
            // 取出data
            NSDictionary *datadic = [json objectForKey:@"data"];
            
            UserInfo *info = [UserInfo mj_objectWithKeyValues:datadic];
            info.avatar = XHIMG_ICON_USER;
            info.username = account;
            info.password = password;
            info.IsVisitor = NO;
            // 登录时间戳
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            info.loginTime = (long long int)time;
            //登录成功,回调userinfo
            [[XiaoxiSDK Ins] returnLoginSuccess:info];
            [self close];
        }
        else {
            // 登录失败
            [[XiaoxiSDK Ins] returnLoginFailure];
            NSString *msg = [json objectForKey:@"msg"];
            [self updateTipWithString:msg];
        }
    } failure:^(NSError *error) {
        // 隐藏进度
        [XiaoxiSDK hideWaiting];
        // 登录失败
        [[XiaoxiSDK Ins] returnLoginFailure];
        [self updateTipWithString:ErrorTip];
    }];
}

/**
 * 主线程更新错误提示
 */
- (void)updateTipWithString: (NSString *)tip {
    dispatch_async(dispatch_get_main_queue(), ^{
        _tips.text = tip;
    });
}

/**
 *  忘记密码
 */
- (void)forget {
    //获取Unity rootviewcontroller
    //UIViewController *unityRootVC = UnityGetGLViewController();
    //UIView *unityView = UnityGetGLView();
    // wenview
    OpenWebViewController *webVC = [[OpenWebViewController alloc]init];
    webVC.url = ForgetUrl;
    // nav
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    [self.navigationController.parentViewController addChildViewController:navVC];
    [self.navigationController.view.superview addSubview:navVC.view];
}

/**
 *  帐号注册
 */
- (void)regNewAccount {
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    registerVC.isBind = _isBind;
    [self.navigationController pushViewController:registerVC animated:YES];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification*)notificationShow {
    // 获取键盘信息数据
    NSDictionary *keyboardInfo = [notificationShow userInfo];
    // 获取键盘高度
    CGFloat keyboardH = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    // 获取键盘动画时间
    double duration = [[notificationShow.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 计算遮挡的offset
    _offset = (ScreenH - SDKWindowH)/2 + _curInput.frame.origin.y + _curInput.frame.size.height + keyboardH + minDistance - ScreenH;
    if(_offset > 0) {
        // 将当前view往上移动offset距离
        CGRect frame = _originalFrame;
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0, frame.origin.y-_offset, frame.size.width, frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 * 键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification*)notificationHide {
    // 获取键盘动画时间
    double duration = [[notificationHide.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 将当前view移回
    if(_offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = _originalFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 * 调用当前view的触摸事件撤销键盘
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[self.view endEditing:YES];//取消第一响应者
    [_curInput resignFirstResponder];//直接取消输入框的第一响应
}

/**
 * 输入框开始编辑
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // 设置当前输入框
    _curInput = textField;
    return YES;
}

@end
