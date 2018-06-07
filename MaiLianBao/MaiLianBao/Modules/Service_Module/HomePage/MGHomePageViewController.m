//
//  MGHomePageViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGHomePageViewController.h"
#import "NavButton.h"
#import "MGSerLoginViewController.h"
#import "MGHPTopTableViewCell.h"
#import "MGHPMidTableViewCell.h"
#import "MGHPBotTableViewCell.h"
#import "MGHPRoteTableViewCell.h"
#import "MJRefresh.h"
#import "RESideMenu.h"
#import "MGHPRebateRequest.h"
#import "MGHPRenewRequest.h"
#import "MGHPRebateModel.h"
#import "MGMineRequest.h"
#import "MGMineModel.h"
#import "MGWebViewController.h"
#import "MGHeaderView.h"
#import "MGRefreshHeader.h"

// 刷新中间cell，web的通知
#define RefreshMidCellNotice @"RefreshMidCellNotice"

// 更新我的模块Item信息通知
#define UpdateMineItemInfoNotice @"UpdateMineItemInfoNotice"

@interface MGHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,TopCellImgTapDelegate,MidCellCheckDelegate,BotCellTapDelegate>

@property (nonatomic,weak) MGHeaderView *headerView;
// 主体表视图
@property(nonatomic,strong)UITableView *mainTableView;

// 首页返利model
@property(nonatomic,strong)MGHPRebateModel *rebateModel;

// 是否是第一次进入(防止首页进入，多次刷新web)
@property(nonatomic,assign)BOOL isFirstInto;

@end

static NSString *topIdenty = @"topCell";
static NSString *midIdenty = @"midCell";
static NSString *botIdenty = @"botCell";
static NSString *roteIdenty = @"roteIdenty";

@implementation MGHomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    // 标志第一次进入
    self.isFirstInto = YES;
    
    [self configNavUI];
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    
    // 首次进来，自动下拉刷新
    [_mainTableView.mj_header beginRefreshing];
    
    // 监听左侧菜单栏切换用户的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchUserNotice) name:SwithUserNotice object:nil];
}

// 切换用户的通知响应
- (void)switchUserNotice
{
   [_mainTableView.mj_header beginRefreshing];
}

- (UITableView *)mainTableView
{
    if (_mainTableView == nil)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
       
        weakSelf(self);
        // 表的头部视图
        MGHeaderView *headerView = [[MGHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, AdaptH(95))];
        [headerView setHeaderBlock:^{
            [weakSelf handleMore];
        }];
        self.headerView = headerView;
        _mainTableView.tableHeaderView = headerView;
        
        // 注册 上、中、下 三种类型的cell
        [_mainTableView registerClass:[MGHPRoteTableViewCell class] forCellReuseIdentifier:roteIdenty];
        
        [_mainTableView registerClass:[MGHPTopTableViewCell class] forCellReuseIdentifier:topIdenty];
        
        [_mainTableView registerClass:[MGHPMidTableViewCell class] forCellReuseIdentifier:midIdenty];
        
        [_mainTableView registerClass:[MGHPBotTableViewCell class] forCellReuseIdentifier:botIdenty];
        
#ifdef __IPHONE_11_0
        if ([_mainTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                _mainTableView.contentInset = UIEdgeInsetsMake(kTopSubHeight, 0, 0, 0);
            } else {
                // Fallback on earlier versions
            }
        }
#endif
        // 下拉刷新
        _mainTableView.mj_header = [MGRefreshHeader headerWithRefreshingBlock:^{
           
           // "首页"返利请求
           MGHPRebateRequest *rebateRequest = [[MGHPRebateRequest alloc] initWithHoldId:HoldId isSync:0];

//           // "我的"模块请求
//           MGMineRequest *mineRequest = [[MGMineRequest alloc] initWithHoldId:LoginHoldId];

            // 按数组排放顺序进行请求
            YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[rebateRequest]];
            batchRequest.delegate = self;
            [batchRequest start];

            [SVProgressHUD showWithTips:@"加载中..."];

            if (self.isFirstInto == NO)
            {
                // 刷新web的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMidCellNotice object:nil];
            }

            // 第一次进入该控制器，自动下拉刷新，改变self.isFirstInto的值，后续下拉，每次都会刷新web
            self.isFirstInto = NO;
        }];
    }
    
    return _mainTableView;
}

- (void)configNavUI
{
   // 设置导航栏左侧按钮
    weakSelf(self);
    self.navigationItem.leftBarButtonItem = [[NavButton alloc] initWithBtnImg:@"switch" btnActionBlock:^{
        
        [weakSelf presentLeftMenuViewController:nil];
    }];

}

#pragma mark - 网络请求协议
// 请求成功
- (void)batchRequestFinished:(YTKBatchRequest *)batchRequest
{
    [SVProgressHUD dismiss];
    [_mainTableView.mj_header endRefreshing];
    
    [MGHPRebateRequest requestArray:batchRequest.requestArray successBlock:^(__kindof NSDictionary *dic) {
        
        MGHPRebateModel *model = [MGHPRebateModel mj_objectWithKeyValues:NetParse.result(dic)];
        self.rebateModel = model;
        self.headerView.rebateModel = model;
        [_mainTableView reloadData];
    }];
    
    [MGMineRequest requestArray:batchRequest.requestArray successBlock:^(__kindof NSDictionary *dic) {
        
        MGMineModel *model = [MGMineModel mj_objectWithKeyValues:NetParse.result(dic)];
        
        // 保存“我的”模块信息，用于在“我的”界面显示
        [MGUserDefaultUtil saveMineInfo:model];
        
        // 发送更新我的模块Item的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMineItemInfoNotice object:nil];
    }];

}

// 请求失败
- (void)batchRequestFailed:(YTKBatchRequest *)batchRequest
{
    [SVProgressHUD dismiss];
    [_mainTableView.mj_header endRefreshing];
    
    [MGHPRebateRequest requestArray:batchRequest.requestArray failBlock:^(__kindof NSString *reason) {
        [SVProgressHUD showWithToast:reason superView:self.view];
    }];
    
    [MGMineRequest requestArray:batchRequest.requestArray failBlock:^(__kindof NSString *reason) {
        [SVProgressHUD showWithToast:reason superView:self.view];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
// 返回section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

// 返回row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MGHPRoteTableViewCell *roteCell = [tableView dequeueReusableCellWithIdentifier:roteIdenty forIndexPath:indexPath];
        
        roteCell.model = self.rebateModel;
        
        return roteCell;
    }
    else if (indexPath.section == 1)
    {
        MGHPTopTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:topIdenty forIndexPath:indexPath];
       
        // 设置Imgv点击代理
        topCell.delegate = self;
        
        // cell赋值
        topCell.model = self.rebateModel;
        
        return topCell;
    }
    else
    {
        MGHPMidTableViewCell *midCell = [tableView dequeueReusableCellWithIdentifier:midIdenty forIndexPath:indexPath];
        
        // 设置上部view点击代理
        midCell.delegate = self;
        
        return midCell;
    }
//    else
//    {
//        MGHPBotTableViewCell *botCell = [tableView dequeueReusableCellWithIdentifier:botIdenty forIndexPath:indexPath];
//
//        // 设置cell点击代理
//        botCell.delegate = self;
//
//        // cell赋值
//        botCell.model = self.rebateModel;
//
//        return botCell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self handleMore];
    }
}

// 返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [MGUserDefaultUtil isLogicalUser] ? 0 : AdaptH(44);
    }
    else if (indexPath.section == 1)
    {
        return AdaptH(120);
    }
    else if (indexPath.section == 2)
    {
        return AdaptH(245) - kTabbarSafeBottomMargin + ([MGUserDefaultUtil isLogicalUser] ? AdaptH(44) : 0);
    }
    else
    {
        return AdaptH(80);
    }
}


// 返回组的头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else if (section == 1)
    {
        return AdaptH(10);
    }
    else if (section == 2)
    {
        return AdaptH(10);
    }
    else
    {
        return AdaptH(5);
    }
}


#pragma mark - TopCellImgTapDelegate
- (void)handleImgvTapWithImgvPosition:(ImgvPosition)imgvPosition
{
//    // 点击左侧Imgv
//    if (imgvPosition == LeftPosition)
//    {
//        MGWebViewController *mgMonthRebateVC = [[MGWebViewController alloc] initWihtURL:URL_HPMonthRebate(HoldId,Token) title:@"本月返利"];
//        [self.navigationController pushViewController:mgMonthRebateVC animated:YES];
//    }
//    // 点击右侧Imgv
//    else if (imgvPosition == RightPosition)
//    {
//        MGWebViewController *mgAccumulateRebateVC = [[MGWebViewController alloc] initWihtURL:URL_HPAccumulateRebate(HoldId,Token) title:@"累积返利"];
//        [self.navigationController pushViewController:mgAccumulateRebateVC animated:YES];
//    }
    
    if (imgvPosition == LeftPosition) {
        MGWebViewController *mgAccumulateRebateVC = [[MGWebViewController alloc] initWihtURL:URL_HPAccumulateRebate(HoldId,Token,@"month") title:@"本月返利"];
        [self.navigationController pushViewController:mgAccumulateRebateVC animated:YES];
    }
    else if (imgvPosition == RightPosition) {
        MGWebViewController *mgAccumulateRebateVC = [[MGWebViewController alloc] initWihtURL:URL_HPAccumulateRebate(HoldId,Token,@"lastMonth") title:@"上月返利"];
        [self.navigationController pushViewController:mgAccumulateRebateVC animated:YES];
    }

}

#pragma mark - BotCellTapDelegate
- (void)handleBotCellTap
{
    MGWebViewController *mgRebateDetailVC = [[MGWebViewController alloc] initWihtURL:URL_HPBotWeb(HoldId,Token) title:@"上月详情"];
    [self.navigationController pushViewController:mgRebateDetailVC animated:YES];
}

#pragma mark - MidCellCheckDelegate
- (void)handleCheckRecentRebate
{
    MGWebViewController *mgRecentRebateVC = [[MGWebViewController alloc] initWihtURL:URL_HPRecentRebate(HoldId,Token) title:@"近期续费"];
    [self.navigationController pushViewController:mgRecentRebateVC animated:YES];
}

- (void)handleMore
{
    MGWebViewController *webvc = [[MGWebViewController alloc] initWihtURL:URL_HPMoreWeb(HoldId, Token) title:@"激活统计"];
    [self.navigationController pushViewController:webvc animated:YES];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

@end

