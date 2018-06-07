//
//  MGPerHomePageViewController.m
//  MaiLianBao
//
//  Created by 伟华 on 17/1/4.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerHomePageViewController.h"
#import "MGPerCardListViewController.h"
#import "ZLCWebView.h"
#import "WXApi.h"
#import "MGOpenApi.h"
#import "MGPerMsgViewController.h"
#import "MGCardListReqeust.h"
#import "MGCardListModel.h"

#define USERCENTERID @"131415929"
#define KEYCENTER @"379C68321D4C3FD90E139A2EB982189E"

@interface MGPerHomePageViewController () <ZLCWebViewDelegate>
@property (nonatomic, strong) ZLCWebView *webView;
@property (nonatomic, strong) NSArray *cardArray;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *errorLabel;
@end

@implementation MGPerHomePageViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (![MGUserDefaultUtil getSelectCard])
//    {
//        [self requestCardList];
//    }
//    else
//    {
//        [self loadingCodeInfo:[MGUserDefaultUtil getSelectCard]];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)requestCardList
{
    MGCardListReqeust *request = [[MGCardListReqeust alloc] initWithToken:[MGUserDefaultUtil getUserToken]];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSInteger errorCode = [request.responseJSONObject[@"error"] integerValue];
        NSLog(@"%@",request.responseJSONObject);
        
        // 默认获取第一张卡
        NSArray *listArray = [MGCardListModel mj_objectArrayWithKeyValuesArray:request.responseJSONObject[@"result"]];
        MGCardListModel *model = listArray[0];
        
        if (0 == errorCode) {
            NSString *codeStr = model.ICCID;
            [MGUserDefaultUtil setSelectCard:codeStr];
            
            [self loadingCodeInfo:codeStr];
            [self.errorLabel setHidden:YES];
            [self.webView setHidden:NO];
        }
        else
        {
            [self.errorLabel setHidden:NO];
            [self.webView setHidden:YES];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayResult:) name:@"kWXPayResultNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeData:) name:@"kRefreshHomeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCardList) name:@"kDeleteRefreshNotification" object:nil];
    
    [self requestCardList];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupNav];
    [self setupWebView];
}

- (void)setupWebView
{
    [self.view addSubview:self.webView];
}

- (void)setupNav
{
    self.navigationItem.title = @"首页";
    
    weakSelf(self);
    
    NavButton *listButton = [[NavButton alloc] initWithBtnImg:@"per_list" btnActionBlock:^{
        
        MGPerCardListViewController *viewController = [[MGPerCardListViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:viewController animated:YES];
        
    }];
    self.navigationItem.rightBarButtonItem = listButton;
    
    // 返回按钮
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = backBar;
}

// 更换卡后通知处理事件
- (void)refreshHomeData:(NSNotification *)notification
{
    [self loadingCodeInfo:notification.object];
}

- (void)loadingCodeInfo:(NSString *)code
{
    NSString *timestamp = [NSString timestamp];
    NSString *key = [NSString stringWithFormat:@"%@%@%@",USERCENTERID,KEYCENTER,timestamp];
    NSURL *URL = [MGOpenApi openApiWithFlowQuery:USERCENTERID
                                           mchId:WXMerchantID
                                             num:code
                                        num_type:@"iccid"
                                       timestamp:timestamp
                                            sign:[[key MD5String] uppercaseString]
                                         os_type:@"iOS"];
    
//    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://open.m-m10010.com/Html/terminal/searchsims.aspx?fromapp=h5&iccid=%@", code]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.f]];
}

#pragma mark - 微信通知回调
- (void)wxPayResult:(NSNotification *)notification
{
    BaseResp *resp = [notification object];
    NSLog(@"请求结果代码:%@, 错误描述:%@, 错误类型:%@",@(resp.errCode), resp.errStr, @(resp.type));
    
    if (0 != resp.errCode) {
        NSLog(@"支付失败");
        [MGAlertUtil mg_alertWithTitle:@"支付失败,请重新支付" superController:self sureBtnActionBlock:^{
            
        }];
    }
    else {
        NSLog(@"支付成功");
        [MGAlertUtil mg_alertWithTitle:@"支付成功!" superController:self sureBtnActionBlock:^{
            [self.webView reload];
        }];
    }
}

#pragma mark - WebView Delegate
- (void)zlcwebViewDidStartLoad:(ZLCWebView *)webview
{
    NSLog(@"页面开始加载");
}

- (void)zlcwebView:(ZLCWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    NSLog(@"截取到URL：%@",URL);
//    NSString *requestStr = [[URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    // 对URL用":"进行拆分组成数组
//    NSArray *components = [requestStr componentsSeparatedByString:@":"];
//    // 在返回的字符串中搜索要截取的字段"apppay"
//    if ([requestStr rangeOfString:@"apppay"].length > 1)
//    {
//
//        if (![WXApi isWXAppInstalled])
//        {
//            NSString *strUrl = @"itms-apps://itunes.apple.com/app";
//            NSURL *url = [NSURL URLWithString:strUrl];
//            [[UIApplication sharedApplication] openURL:url];
//        }
//        else
//        {
//            PayReq *req = [[PayReq alloc] init];
//            req.partnerId = components[1];
//            req.prepayId = components[2];
//            req.nonceStr = components[3];
//            req.timeStamp = [components[4] intValue];
//            req.package = components[5];
//            req.sign = components[6];
//            req.openID = components[7];
//            [WXApi sendReq:req];
//        }
//    }

    NSString *requestStr = [[URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([requestStr containsString:@"alipay://"] || [requestStr containsString:@"weixin://"])
    {
        [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {

        }];
    }
}
- (void)zlcwebView:(ZLCWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    NSLog(@"页面加载完成");
    self.navigationItem.title = [webview title];
    
    [self updateNavigationItems];
    
    // 判断是不是返回首页
    NSString *requestStr = [[URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([requestStr rangeOfString:@"simcard_lt_new"].length >1 || [requestStr rangeOfString:@"simcard_yd"].length > 1)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.backButton.hidden = YES;
    }
}

- (void)zlcwebView:(ZLCWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    NSLog(@"加载出现错误");
    [self updateNavigationItems];
}

#pragma mark - 点击时间

- (void)backButtonClicked:(UIButton *)button
{
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
    }
}

- (void)updateNavigationItems
{
    if (self.webView.canGoBack)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.backButton.hidden = NO;
    }
    else
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.backButton.hidden = YES;
    }
}

#pragma mark - 懒加载
- (UIButton *)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 44, 44);
        [_backButton setImage:[UIImage imageNamed:@"nav_per_back"] forState:UIControlStateNormal];
        _backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        _backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.hidden = YES;
    }
    return _backButton;
}

- (ZLCWebView *)webView
{
    if (!_webView)
    {
        _webView = [[ZLCWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabBarHeight - kTopSubHeight)];
        [_webView setTintColor:[UIColor orangeColor]];
        [_webView setProgressTop:0];
        _webView.delegate = self;
    }
    return _webView;
}

- (UILabel *)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        _errorLabel.text = @"当前账号尚未绑定流量卡";
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.font = [UIFont systemFontOfSize:14.f];
        _errorLabel.textColor = [UIColor darkTextColor];
        _errorLabel.hidden = YES;
        [self.view addSubview:_errorLabel];
    }
    return _errorLabel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kRefreshHomeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kDeleteRefreshNotification" object:nil];
}

@end
