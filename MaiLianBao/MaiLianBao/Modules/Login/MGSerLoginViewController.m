//
//  MGLoginViewController.m
//  MaiLianBao
//
//  Created by 谭伟华 on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGSerLoginViewController.h"
#import "MGLoginInputView.h"
#import "UIView+BSLine.h"
#import "MGSerTabbarViewController.h"
#import "AppDelegate.h"
#import "MGLoginRequest.h"
#import "MGUserDefaultUtil.h"
#import "MGPerTabbarController.h"

@interface MGSerLoginViewController ()<YTKRequestDelegate,UITextFieldDelegate>

// 底层滑动视图
@property(nonatomic,strong)UIScrollView *bgScrollView;
// 账户输入框
@property(nonatomic,strong)MGLoginInputView *accountView;
// 密码输入框
@property(nonatomic,strong)MGLoginInputView *passwordView;

@end

@implementation MGSerLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configUI];
    
    // 监听键盘弹出
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotif) name:UIKeyboardWillShowNotification object:nil];
    
    // 监听键盘收回
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotif) name:UIKeyboardWillHideNotification object:nil];
}

// 布局UI界面
- (void)configUI
{
    UIScrollView *bgScrollView = [[UIScrollView alloc] init];
    self.bgScrollView = bgScrollView;
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    [bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeKeyboard)];
    [bgScrollView addGestureRecognizer:tap];
    
    UIImageView *logoImgv = [[UIImageView alloc] init];
    logoImgv.contentMode = UIViewContentModeScaleAspectFit;
    logoImgv.image = [UIImage imageNamed:@"logo"];
    [bgScrollView addSubview:logoImgv];
    [logoImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgScrollView);
        make.centerY.equalTo(bgScrollView).mas_offset(-AdaptH(200));
        make.size.mas_equalTo(CGSizeMake(AdaptW(105),AdaptW(105)));
    }];
   
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"运营商";
    titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgScrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImgv.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(AdaptH(15));
    }];
    
    // 账户输入框
    MGLoginInputView *accountView = [[MGLoginInputView alloc] initWithFrame:CGRectZero leftImg:@"user" rightTfPlaceholder:@"请输入登录账号"];
    accountView.inputTf.delegate = self;
    accountView.inputTf.returnKeyType = UIReturnKeyNext;
    self.accountView = accountView;
    [bgScrollView addSubview:accountView];
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenW-AdaptW(50),AdaptH(46.5)));
        make.centerX.equalTo(bgScrollView);
        make.centerY.equalTo(bgScrollView).mas_offset(-AdaptH(40));
    }];
    
    // 获取上一次用户登录的账号
    NSString *lastUserNameStr = [MGUserDefaultUtil getLastLoginUserName];
    if (lastUserNameStr.length != 0)
    {
        accountView.inputTf.text = lastUserNameStr;
    }
    
    // 给账号输入框添加上下方横线
    [accountView addTopLineWithLeftPading:0 andRightPading:0];
    [accountView addBottomLineWithLeftPading:0 andRightPading:0];
    
    // 密码输入框
    MGLoginInputView *passwordView = [[MGLoginInputView alloc] initWithFrame:CGRectZero leftImg:@"lock" rightTfPlaceholder:@"请输入登陆密码"];
    passwordView.inputTf.delegate = self;
    passwordView.inputTf.returnKeyType = UIReturnKeyDone;
    self.passwordView = passwordView;
    passwordView.inputTf.secureTextEntry = YES;
    [bgScrollView addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.mas_bottom);
        make.centerX.equalTo(accountView);
        make.size.mas_equalTo(CGSizeMake(kScreenW-AdaptW(50),AdaptH(46.5)));
    }];
    
    // 给密码输入框添加下方横线
    [passwordView addBottomLineWithLeftPading:0 andRightPading:0];
   
    // 忘记密码btn
//    UIButton *forgetPWBtn = [[UIButton alloc] init];
//    [forgetPWBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
//    forgetPWBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [forgetPWBtn setTitleColor:UIColorFromRGB(0xfb7e01) forState:UIControlStateNormal];
//    [bgScrollView addSubview:forgetPWBtn];
//    [forgetPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(passwordView.mas_bottom).mas_offset(AdaptH(15));
//        make.right.equalTo(passwordView);
//    }];
    
    // 登陆btn
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"button-press"] forState:UIControlStateHighlighted];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(19)];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(accountView);
        make.top.equalTo(passwordView).mas_offset(AdaptH(100));
        make.height.mas_equalTo(AdaptH(47));
        make.left.equalTo(bgScrollView).mas_offset(AdaptW(20));
        make.right.equalTo(bgScrollView).mas_offset(-AdaptW(20));
    }];
    
//    _accountView.inputTf.text = @"mapgoo_test";
//    _passwordView.inputTf.text = @"123456";
}

// 收回键盘
- (void)hiddeKeyboard
{
    [self.view endEditing:YES];
}

// 登陆事件
- (void)loginAction
{
    if (_accountView.inputTf.text.length == 0)
    {
        [SVProgressHUD showWithToast:@"请输入账号" superView:self.bgScrollView];
         return;
    }
    else if (_passwordView.inputTf.text.length == 0)
    {
        [SVProgressHUD showWithToast:@"请输入密码" superView:self.bgScrollView];
         return;
    }
    
    // 密码MD5加密
    NSString *pwStr = [_passwordView.inputTf.text MD5String];
    
    // TODO: 发送“登陆”请求
   [[[MGLoginRequest alloc] initWithUserName:_accountView.inputTf.text
                                     password:pwStr
                                     showTips:@"登陆中..."
                                     delegate:self] start];
}

// 键盘弹出事件
- (void)keyboardWillShowNotif
{
    CGPoint point = CGPointMake(0,AdaptH(80));
    [self.bgScrollView setContentOffset:point animated:YES];
}

// 键盘收回事件
- (void)keyboardWillHideNotif
{
    CGPoint point = CGPointMake(0,0);
    [self.bgScrollView setContentOffset:point animated:YES];
}

#pragma mark - UITextFieldDelegate
// 点击键盘return位置按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  
    if (textField == self.accountView.inputTf)
    {
        [self.accountView.inputTf resignFirstResponder];
        [self.passwordView.inputTf becomeFirstResponder];
    }
    else
    {
         [self.view endEditing:YES];
        
         // 登陆事件
         [self loginAction];
    }

    return YES;
}

#pragma mark - 网络请求协议
// 请求成功
- (void)requestFinished:(YTKBaseRequest *)request
{
    [super requestFinished:request];
    
    [request requestSuccessBlock:^(__kindof NSDictionary *dic) {
        
        NSLog(@"%@", dic);
        
        // 保存用户信息
        MGUserModel *userModel = [MGUserModel mj_objectWithKeyValues:NetParse.result(dic)];
        [MGUserDefaultUtil saveUserInfo:userModel];
        
        NSLog(@"登陆的用户信息====>%@",[MGUserDefaultUtil getUserInfo]);
        
        // 切换根控制器
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate handlePerRootVC];
        
    } failBlock:^(__kindof NSString *reason) {
        
         [SVProgressHUD showWithToast:reason superView:self.bgScrollView];
    }];
}

// 请求失败
- (void)requestFailed:(YTKBaseRequest *)request
{
    [super requestFailed:request];
    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
