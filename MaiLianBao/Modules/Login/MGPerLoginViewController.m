//
//  MGPerLoginViewController.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/3.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerLoginViewController.h"
#import "MGLoginInputView.h"
#import "UIView+BSLine.h"
#import "AppDelegate.h"
#import "MGCountDownButton.h"
#import "UITextField+SCategory.h"
#import "MGCaptchaRequest.h"
#import "MGPerLoginRequest.h"
#import "MGUserModel.h"
#import "MGPerHomePageViewController.h"

#define PER_PHONENUM @"PER_PHONENUM"

@interface MGPerLoginViewController () <UITextFieldDelegate, MGCountdownButtonDelegate>

@property (nonatomic, weak) UIScrollView *bgScrollView;
@property(nonatomic, weak) MGLoginInputView *phoneView;
@property(nonatomic, weak) MGLoginInputView *countdownView;
@property(nonatomic, weak) MGCountDownButton *countdownButton;

@end

@implementation MGPerLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotif) name:UIKeyboardWillShowNotification object:nil];
    
    // 监听键盘收回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotif) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 将要消失
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    // 停止定时器
    [self.countdownButton countdownStop];
}

#pragma mark - 创建UI
- (void)setupUI
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
    titleLabel.text = @"个人用户";
    titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgScrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImgv.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(AdaptH(15));
    }];
    
    // 手机号输入
    MGLoginInputView *phoneView = [[MGLoginInputView alloc] initWithFrame:CGRectZero leftImg:@"user" rightTfPlaceholder:@"请输入手机号"];
    phoneView.inputTf.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView.inputTf limitTextLength:11];
    self.phoneView = phoneView;
    [bgScrollView addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenW-AdaptW(50),AdaptH(46.5)));
        make.centerX.equalTo(bgScrollView);
        make.centerY.equalTo(bgScrollView).mas_offset(-AdaptH(40));
    }];
    
    // 获取上一次用户登录的账号
    NSString *lastUserNameStr = [[NSUserDefaults standardUserDefaults] valueForKey:PER_PHONENUM];
    if (lastUserNameStr.length != 0)
    {
        phoneView.inputTf.text = lastUserNameStr;
    }
    
    // 给账号输入框添加上下方横线
    [phoneView addTopLineWithLeftPading:0 andRightPading:0];
    [phoneView addBottomLineWithLeftPading:0 andRightPading:0];
    
    // 验证码
    MGLoginInputView *countdownView = [[MGLoginInputView alloc] initWithFrame:CGRectZero leftImg:@"lock" rightTfPlaceholder:@"请输入验证码"];
    countdownView.inputTf.keyboardType = UIKeyboardTypeNumberPad;
    [countdownView.inputTf limitTextLength:6];
    self.countdownView = countdownView;
    countdownView.inputTf.secureTextEntry = YES;
    [bgScrollView addSubview:countdownView];
    [countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom);
        make.centerX.equalTo(phoneView);
        make.size.mas_equalTo(CGSizeMake(kScreenW-AdaptW(50),AdaptH(46.5)));
    }];
    
    countdownView.inputTf.rightViewMode = UITextFieldViewModeAlways;
    
    MGCountDownButton *countdownButton = [[MGCountDownButton alloc] init];
    self.countdownButton = countdownButton;
    countdownButton.delegate = self;
    countdownButton.frame = CGRectMake(0, 0, 70, 30);
    countdownButton.countdownBeginNumber = 60;
    countdownView.inputTf.rightView = countdownButton;
    
    // 给密码输入框添加下方横线
    [countdownView addBottomLineWithLeftPading:0 andRightPading:0];
    
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
        make.centerX.equalTo(phoneView);
        make.top.equalTo(countdownView).mas_offset(AdaptH(100));
        make.height.mas_equalTo(AdaptH(47));
        make.left.equalTo(bgScrollView).mas_offset(AdaptW(20));
        make.right.equalTo(bgScrollView).mas_offset(-AdaptW(20));
    }];
}

// 收回键盘
- (void)hiddeKeyboard
{
    [self.view endEditing:YES];
}

// 登陆事件
- (void)loginAction
{
    if (_phoneView.inputTf.text.length < 10)
    {
        [SVProgressHUD showWithToast:@"请输入手机号码" superView:self.bgScrollView];
        return;
    }
    else if (_countdownView.inputTf.text.length == 0)
    {
        [SVProgressHUD showWithToast:@"请输入收到的验证码" superView:self.bgScrollView];
        return;
    }
    
    [SVProgressHUD showWithTips:@"登录中..."];
    [self.view endEditing:YES];
    
    MGPerLoginRequest *request = [[MGPerLoginRequest alloc] initWithMobile:self.phoneView.inputTf.text
                                                                 validcode:self.countdownView.inputTf.text];
    
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSInteger errorCode = [request.responseJSONObject[@"error"] integerValue];
        if (0 == errorCode) {
            [SVProgressHUD dismiss];
            // 登录成功
            MGPerUserModel *userModel = [MGPerUserModel mj_objectWithKeyValues:request.responseJSONObject[@"result"]];
            [MGUserDefaultUtil savePerUserInfo:userModel];
            
            [[NSUserDefaults standardUserDefaults] setValue:self.phoneView.inputTf.text forKey:PER_PHONENUM];
        
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate handlePerRootVC];
            
        }
        else {
            NSLog(@"%@",request.responseJSONObject[@"reason"]);
            [SVProgressHUD showErrorWithStatus:request.responseJSONObject[@"reason"]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
        
    }];

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

// 获取验证码点击事件
- (void)countdownBtnClicked:(MGCountDownButton *)btn
{
    if (self.phoneView.inputTf.text.length >= 11)
    {
        [SVProgressHUD showWithTips:@"正在发送验证码"];
        [self.view endEditing:YES];
        
        // 获取验证码
        MGCaptchaRequest *reqeust = [[MGCaptchaRequest alloc] initWithMobile:self.phoneView.inputTf.text];
        [reqeust startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            [btn countdownBegin];
            
            [SVProgressHUD showSuccessWithStatus:@"验证码已发送,请注意查收"];
            
            [self.countdownView.inputTf becomeFirstResponder];
            
        } failure:^(__kindof YTKBaseRequest *request) {
            
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
            
        }];
        
    }
    else
    {
        [SVProgressHUD showWithToast:@"请输入手机号码" superView:self.bgScrollView];
    }
    
}


- (void)dealloc
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
