//
//  SavedLoginViewController.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 6/7/16.
//  Copyright © 2016 Xinhou Jiang. All rights reserved.
//
#import "SavedLoginViewController.h"
#import "LoginSelectViewController.h"
#import "AccountTableViewController.h"
#import "AccountLoginViewController.h"
#import "UserInfo.h"
#import "TitleButton.h"
#import "PhoneLoginViewController.h"

//#import "RequestSingleton.h"
@interface SavedLoginViewController ()<AccountDelegate>

/**
 * 账号数据
 */
@property (nonatomic) NSMutableArray *dataSource;

/**
 * 当前账号选择框
 */
@property (nonatomic, copy) UIButton *curAccount;

/**
 *  当前选中账号
 */
@property (nonatomic, strong) UserInfo *curAcc;

/**
 * 当前账号头像
 */
@property (nonatomic, copy) UIImageView *icon;

/**
 *  账号下拉列表
 */
@property (nonatomic, strong) AccountTableViewController *accountList;

/**
 *  下拉列表的frame
 */
@property (nonatomic) CGRect listFrame;

/**
 *  tips
 */
@property (nonatomic, strong) UILabel *tips;

@end

@implementation SavedLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加UI
    [self addUI];
}

- (void)viewWillAppear:(BOOL)animated {
    // 请求数据
    [self request];
    // 更新数据
    _accountList.accountSource = _dataSource;
    [_accountList.tableView reloadData];
    // 初始化下拉列表高度
    [self updateListH];
    // 隐藏下拉菜单
    _accountList.isOpen = NO;
    _accountList.view.frame = CGRectZero;
    // 默认当前账号为当前登录帐号,如果没有登录则默认第一个
    if (_dataSource.count) {
        _curAcc = [XiaoxiSDK Ins].curUser;
        if (!_curAcc) {
            _curAcc = _dataSource[0];
        }
        [_curAccount setTitle:_curAcc.username forState:UIControlStateNormal];
        [_icon setImage:[UIImage imageNamed:_curAcc.avatar]];
    }
}

/**
 * 添加UI元素
 */
- (void)addUI {
    
    // 帐号选择框
    _curAccount = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
    _curAccount.center = CGPointMake(SDKWindowW/2, self.logoView.frame.origin.y + self.logoView.frame.size.height + _curAccount.frame.size.height/2 + UIBorder);
    // 默认当前账号为已有账号的第一个
    //Account *acc = _dataSource[0];
    //[_curAccount setTitle:acc.account forState:UIControlStateNormal];
    // 字体
    [_curAccount setTitleColor:TextColorNormal forState:UIControlStateNormal];
    _curAccount.titleLabel.font = fontNormal;
    // 边框
    //_curAccount.layer.borderWidth = 0.5;
    // 显示框背景
    [_curAccount setBackgroundImage:[UIImage imageNamed:@"input"] forState:UIControlStateNormal];
    //[_curAccount setBackgroundColor:[UIColor whiteColor]];
    [_curAccount addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_curAccount];
    
    // 图标
    _icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, inputH, inputH)];
    //[_icon setImage:[UIImage imageNamed:acc.avatar]];
    [_curAccount addSubview:_icon];
    
    // 下拉菜单弹出按钮
    UIButton *openBtn = [[UIButton alloc]initWithFrame:CGRectMake(inputW - inputH, 0, inputH, inputH)];
    [openBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
    [_curAccount addSubview:openBtn];
    
    // 提示
    _tips = [[UILabel alloc]initWithFrame:CGRectMake(0, _curAccount.frame.origin.y + _curAccount.frame.size.height + UIBorderS, SDKWindowW, 20)];
    [_tips setTextAlignment:NSTextAlignmentCenter];
    [_tips setText:@""];
    [_tips setFont:fontSmall];
    [_tips setTextColor:[UIColor redColor]];
    [self.view addSubview:_tips];
    
    // 登录游戏按钮
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inputW, inputH)];
    loginBtn.center = CGPointMake(SDKWindowW/2, _tips.frame.origin.y + _tips.frame.size.height+loginBtn.frame.size.height/2);
    [loginBtn setBackgroundColor:LoginBtnColor];
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = fontLarge;
    // 按钮事件
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    // 其他账号登录
    UILabel *tip2 = [[UILabel alloc]init];
    [tip2 setText:@"Other accounts login"];
    [tip2 setFont:fontNormal];
    [tip2 setTextColor:TextColorNormal];
    [tip2 sizeToFit];
    tip2.center = CGPointMake(SDKWindowW/2, loginBtn.frame.origin.y+_curAccount.frame.size.height+tip2.frame.size.height/2+UIBorderS);
    [self.view addSubview:tip2];
    // 分割线
    CGFloat separatorW =  SDKWindowW - 2*UIBorder;
    UIImageView *separator = [[UIImageView alloc]initWithFrame:CGRectMake(UIBorder, tip2.frame.origin.y + tip2.frame.size.height + 5,separatorW, 0.5)];
    [separator setImage:[UIImage imageNamed:@"line"]];
    [self.view addSubview:separator];
    
    // 快速游戏按钮
    TitleButton *leftBtn = [[TitleButton alloc]initWithFrame:CGRectMake(separator.frame.origin.x, separator.frame.origin.y, separatorW/3, separatorW/3+10)];
    [leftBtn setImage:[UIImage imageNamed:@"xiaoxisdk_channel_visitor"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"Visitor" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = fontNormal;
    [leftBtn setTitleColor:TextColorNormal forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(instantLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    // 手机快速登录按钮
    TitleButton *phoneBtn = [[TitleButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), leftBtn.frame.origin.y, separatorW/3, separatorW/3+10)];
    [phoneBtn setImage:[UIImage imageNamed:@"xiaoxisdk_channel_phone"] forState:UIControlStateNormal];
    [phoneBtn setTitle:@"PhoneNumber" forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = fontNormal;
    [phoneBtn setTitleColor:TextColorNormal forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneBtn];
    
    // 小西账号登录按钮
    TitleButton *rightBtn = [[TitleButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneBtn.frame), leftBtn.frame.origin.y, separatorW/3, separatorW/3+10)];
    [rightBtn setTitle:@"Account" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"xiaoxisdk_channel_account"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = fontNormal;
    [rightBtn setTitleColor:TextColorNormal forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(xiaoxiLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    // 设置账号弹出菜单(最后添加显示在顶层)
    _accountList = [[AccountTableViewController alloc] init];
    // 设置弹出菜单的代理为当前这个类
    _accountList.delegate = self;
    // 将下拉列表作为子页面添加到当前视图，同时添加子控制器
    [self addChildViewController:_accountList];
    [self.view addSubview:_accountList.view];
   }

/**
 *  监听代理更新下拉菜单
 */
- (void)updateListH {
    CGFloat listH;
    if (_dataSource.count > 3) {
        listH = inputH * 3.5;
    }else{
        listH = inputH * _dataSource.count;
    }
    _listFrame = CGRectMake(_curAccount.frame.origin.x, _curAccount.frame.origin.y + _curAccount.frame.size.height, inputW, listH);
    _accountList.view.frame = _listFrame;
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:_listFrame];
    [bgView setImage:[UIImage imageNamed:@"input"]];
    [_accountList.tableView setBackgroundView:bgView];
}

/**
 *  登录游戏
 */
- (void)login {
    if ([_curAcc.username isEqualToString:[XiaoxiSDK Ins].curUser.username]) {
        [self updateTipWithString:@"Current account is already logined"];
        return;
    }
    
    // 登录提示
    [XiaoxiSDK showWaitingWithTip:@"Logining..."];
    
    // 请求数据库验证
    ParamBase *p = [ParamBase param];
    p.username = _curAcc.username;
    p.password = _curAcc.password;
    
    [[XXRequestIns Ins] postAPIWithM:@"User" A:@"Login" P:p.mj_keyValues success:^(id json) {
        // 隐藏进度
        [XiaoxiSDK hideWaiting];
        NSNumber *code = [json objectForKey:@"code"];
        if ([code isEqual:@0]) {
            //登录成功
            // 取出token
            NSDictionary *datadic = [json objectForKey:@"data"];
            // 新绑定用户信息
            UserInfo *newInfo = [UserInfo UserInfo:_curAcc.username openid:[datadic objectForKey:@"open_id"] token:[datadic objectForKey:@"token"] isVisitor:_curAcc.IsVisitor];
            newInfo.password = _curAcc.password;
            // 登录时间戳
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            newInfo.loginTime = (long long int)time;
            [[XiaoxiSDK Ins] returnLoginSuccess:newInfo];
            [self close];
        }else{
            [[XiaoxiSDK Ins] returnLoginFailure];
            NSString *msg = [json objectForKey:@"msg"];
            [self updateTipWithString:msg];
        }
    } failure:^(NSError *error) {
        // 隐藏进度
        [XiaoxiSDK hideWaiting];
        [[XiaoxiSDK Ins] returnLoginFailure];
        [self updateTipWithString:ErrorTip];
    }];
}

/**
 * 主线程更新错误提示
 */
- (void)updateTipWithString: (NSString *)tip {
    if ([NSThread isMainThread]){
        _tips.text = tip;
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            _tips.text = tip;
        });
    }
}

/**
 * 请求数据
 */
- (void)request {
    // 按照登录时间排序
    _dataSource = [self sortUsersByTime:[[XiaoxiSDK Ins] SavedUsers]];
}

/**
 *  账户按照登录时间戳排序
 */
- (NSMutableArray *)sortUsersByTime: (NSMutableArray *)users {
    // 时间key字符串格式
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-DDThh:mm:ss.sTZD"];
    // 时间戳数组
    NSMutableArray *timeArr = [[NSMutableArray alloc]init];
    // 时间key字符串数组
    NSMutableDictionary *usersKeyDate = [[NSMutableDictionary alloc]init];
    
    for (UserInfo *user in users) {
        // 时间戳转成时间对象用于排序
        NSDate  *date = [NSDate dateWithTimeIntervalSince1970:user.loginTime];
        [timeArr addObject:date];
        // 时间戳转成时间戳字符串作为key
        NSNumber *dataNum = [NSNumber numberWithLongLong:user.loginTime];
        NSString *datekey = [dataNum stringValue];
        [usersKeyDate setObject:user forKey:datekey];
    }
    // 将时间数组排序
    NSArray *orderedDateArray = [timeArr sortedArrayUsingComparator:^NSComparisonResult(NSDate *date1, NSDate *date2) {
        return [date2 compare:date1];
    }];
    // 存储排序后的用户数组
    NSMutableArray *sortedusers = [[NSMutableArray alloc]init];
    // 输入排序后的结点数据
    NSDate *datekey = [[NSDate alloc]init];
    for (int i = 0; i<orderedDateArray.count; i++) {
        datekey = orderedDateArray[i];
        // 日期对象转换成时间戳字符串key
        NSString *datekey2 = [NSString stringWithFormat:@"%lld", (long long)[datekey timeIntervalSince1970]];
        [sortedusers addObject:[usersKeyDate objectForKey:datekey2]];
    }
    return sortedusers;
}

/**
 * 弹出账号选择列表
 */
- (void)openAccountList {
    _accountList.isOpen = !_accountList.isOpen;
    if (_accountList.isOpen) {
        _accountList.view.frame = _listFrame;
    }
    else {
        _accountList.view.frame = CGRectZero;
    }
}

/**
 * 监听代理选定cell获取选中账号
 */
- (void)selectedCell:(NSInteger)index {
    // 更新当前选中账号
    _curAcc = _dataSource[index];
    [_icon setImage:[UIImage imageNamed:_curAcc.avatar]];
    [_curAccount setTitle:_curAcc.username forState:UIControlStateNormal];
    [self openAccountList];
}

/**
 *  快速游戏
 */
- (void)instantLogin {
    
    [XiaoxiSDK showWaitingWithTip:@"Logining..."];
    
    ParamBase *param = [ParamBase param];
    
    [[XiaoxiSDK Ins].HttpManager postAPIWithM:@"User" A:@"RegisterVisitor" P:param.mj_keyValues success:^(id json) {
        [XiaoxiSDK hideWaiting];
        NSNumber *code = [json objectForKey:@"code"];
        if ([code isEqual:@0]) {
            // 取出data
            NSDictionary *datadic = [json objectForKey:@"data"];
            UserInfo *info = [UserInfo mj_objectWithKeyValues:datadic];
            info.avatar = @"xiaoxisdk_user_icon";
            info.IsVisitor = YES;
            // 登录时间戳
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            info.loginTime = (long long int)time;
            // 登录成功
            [[XiaoxiSDK Ins] returnLoginSuccess:info];
            // 关闭登录窗口
            [self close];
        }
        else {
            [[XiaoxiSDK Ins] returnLoginFailure];
            [self updateTipWithString:[json objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [XiaoxiSDK hideWaiting];
        [[XiaoxiSDK Ins] returnLoginFailure];
        NSLog(@"请求错误：%@",error);
        [self updateTipWithString:ErrorTip];
    }];
}

/**
 * 手机快速登录
 */
- (void)phoneLogin {
    PhoneLoginViewController *phoneLogin = [[PhoneLoginViewController alloc]init];
    phoneLogin.isBind = NO;
    [self.navigationController pushViewController:phoneLogin animated:YES];
}

/**
 * 小西账号登录
 */
- (void)xiaoxiLogin {
    [self.navigationController pushViewController:[[AccountLoginViewController alloc]init] animated:YES];
}

- (void)viewWillLayoutSubviews {
    [self openAccountList];
    [self openAccountList];
}

@end
