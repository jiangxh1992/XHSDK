//
//  RegisterViewController.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/7/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//
#import "RegisterViewController.h"
#import "LoginSelectViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

/**
 *  当前编辑的输入框
 */
@property (nonatomic)UITextField *curInput;

/**
 * 输入框防遮挡调整的offset
 */
@property (nonatomic)CGFloat offset;

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
 * 确认密码输入框
 */
@property (nonatomic, strong) UITextField *confirm;

/**
 *  tips
 */
@property (nonatomic, strong) UILabel *tips;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _originalFrame = self.view.frame;
    // 添加UI
    [self addUI];
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 * 添加UI元素
 */
- (void)addUI {
    
    // 帐号输入框
    _account = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
    _account.center = CGPointMake(SDKWindowW/2, self.logoView.frame.origin.y + self.logoView.frame.size.height+inputH/2+UIBorder);
//    _account.borderStyle = UITextBorderStyleLine;
//    _account.layer.borderWidth = 0.5;
//    _account.layer.borderColor = [RGBColor(230, 230, 230) CGColor];
    [_account setBackground:[UIImage imageNamed:@"input"]];
    UIImageView *accountLView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiaoxisdk_user_icon"]];
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
//    _password.borderStyle = UITextBorderStyleLine;
//    _password.layer.borderColor = [RGBColor(230, 230, 230) CGColor];
//    _password.layer.borderWidth = 0.5;
    [_password setBackground:[UIImage imageNamed:@"input"]];
    UIImageView *pswLView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiaoxisdk_security_icon"]];
    pswLView.frame = CGRectMake(0, 0, inputH, inputH);
    _password.leftView = pswLView;
    _password.leftViewMode = UITextFieldViewModeAlways;
    _password.placeholder = @"Please input password";
    _password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _password.font = fontNormal;
    _password.delegate = self;
    _password.secureTextEntry = YES;
    [self.view addSubview:_password];
    
    // 确认密码输入框
    _confirm = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
    _confirm.center = CGPointMake(SDKWindowW/2, _password.frame.origin.y+_password.frame.size.height+inputH/2+UIBorderS);
//    _confirm.borderStyle = UITextBorderStyleLine;
//    _confirm.layer.borderColor = [RGBColor(230, 230, 230) CGColor];
//    _confirm.layer.borderWidth = 0.5;
    [_confirm setBackground:[UIImage imageNamed:@"input"]];
    UIImageView *conLView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiaoxisdk_security_icon"]];
    conLView.frame = CGRectMake(0, 0, inputH, inputH);
    _confirm.leftView = conLView;
    _confirm.leftViewMode = UITextFieldViewModeAlways;
    _confirm.placeholder = @"Please input password again";
    _confirm.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _confirm.font = fontNormal;
    _confirm.delegate = self;
    _confirm.secureTextEntry = YES;
    [self.view addSubview:_confirm];
    
    // 提示
    _tips = [[UILabel alloc]initWithFrame:CGRectMake(0, _confirm.frame.origin.y+_confirm.frame.size.height + UIBorderM/2, SDKWindowW, 20)];
    [_tips setTextAlignment:NSTextAlignmentCenter];
    [_tips setText:@""];
    [_tips setFont:fontSmall];
    [_tips setTextColor:[UIColor redColor]];
    [self.view addSubview:_tips];
    
    // 注册并登录游戏按钮
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
    [loginBtn setBackgroundColor:LoginBtnColor];
    // 按钮title
    NSString *title = _isBind ? @"Bind and login" : @"Register and login";
    [loginBtn setTitle:title forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = fontLarge;
    loginBtn.center = CGPointMake(SDKWindowW/2, _tips.frame.origin.y + _tips.frame.size.height+loginBtn.frame.size.height/2);
    // 按钮事件
    [loginBtn addTarget:self action:@selector(regLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

/**
 * 注册并登录
 */
- (void)regLogin {
    
    // 账号密码
    NSString *account = _account.text;
    NSString *password = _password.text;
    NSString *conform = _confirm.text;
    if ([account isEqualToString:@""] || [password isEqualToString:@""] || [conform isEqualToString:@""]){
        _tips.text = @"Account or password can not be empty";
        return;
    }
    else if (![password isEqualToString:conform]){
        _tips.text = @"Two inputs are not matched";
        return;
    }
    
    // 开始请求，显示等待提示
    [XiaoxiSDK showWaitingWithTip:@"Registering..."];
    
    ParamBase *baseParam = [ParamBase param];
    baseParam.username = account;
    baseParam.password = password;
    
    // 注册
    [[XXRequestIns Ins] POSTWithUrl:UrlRegister param:baseParam.mj_keyValues success:^(id json) {
        [XiaoxiSDK hideWaiting];
        NSNumber *code = [json objectForKey:@"code"];
        if ([code isEqual:@0]) {
            // 取出data
            NSDictionary *datadic = [json objectForKey:@"data"];
            UserInfo *info = [UserInfo mj_objectWithKeyValues:datadic];
            info.avatar = @"xiaoxisdk_user_icon";
            info.IsVisitor = NO;
            info.password = password;
            // 登录时间戳
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            info.loginTime = (long long int)time;
            // 注册登录成功
            [[XiaoxiSDK Ins] returnLoginSuccess:info];
            [self close];
        }else {
            NSString *msg = [json objectForKey:@"msg"];
            [self updateTipWithString:msg];
            // 登录失败
            [[XiaoxiSDK Ins] returnLoginFailure];
        }
    } failure:^(NSError *error) {
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
 * 键盘即将弹出
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
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = _originalFrame;
        } completion:^(BOOL finished) {
            
        }];
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
