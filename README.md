# XHSDK

# 用于软件和游戏登录的SDK以及php服务器

![这里写图片描述](http://img.blog.csdn.net/20170610214610292?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvY29yZG92YQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

```
- (void)viewDidAppear:(BOOL)animated {
    [XHFloatWindow xh_addWindowOnTarget:self onClick:^{
        // 进入用户中心
        [self user];
        // 隐藏悬浮按钮
        [XHFloatWindow xh_setHideWindow:YES];
    }];
    [XHFloatWindow xh_setBackgroundImage:@"xh_float_normal" forState:UIControlStateNormal];
    // 默认隐藏悬浮按钮
    [XHFloatWindow xh_setHideWindow:YES];
}
```

```
/**
 * 1.登录注销
 */
- (void)login {
    
    // 登录接口
    [SDK Login:^(NSInteger result, UserInfo *info) {
        // ... ...
    }];
}
- (void)logout {
    // 注销接口
    [SDK logout:^(NSUInteger result) {
        if (result == 0) {
            // 注销成功
            [XiaoxiSDK showTip:@"Logout successfully"];
            // 隐藏悬浮按钮
            [XHFloatWindow xh_setHideWindow:YES];
        }else {
            // 当前没有用户登录
            [XiaoxiSDK showTip:@"No current account"];
        }
    }];
}

/**
 * 2.用户中心
 */
- (void)user {
    // 进入用户中心接口
    [SDK EnterUserCenter:^(NSInteger result, UserInfo *info) {
       // ... ...
    }];
}
```
