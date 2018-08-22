//
//  MGNewUserStatisticViewController.m
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/8.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGNewUserStatisticViewController.h"
#import "UIViewController+RESideMenu.h"

#import "MGUserStatisticTableCell.h"
#import "MGRefreshHeader.h"
#import "MGRefreshFooter.h"
#import "SCAdView.h"
#import "MGPageFlowModel.h"
#import "MGRenewTableView.h"
#import "MGUserStatisticRequest.h"
#import "MGUserStatisticListRequest.h"
#import "MGChannelManageOutModel.h"
#import "MGItemTool.h"
#import "QFDatePickerView.h"

static NSString *identy = @"cell";
@interface MGNewUserStatisticViewController ()<UITableViewDelegate,UITableViewDataSource,SCAdViewDelegate,YTKRequestDelegate>

@property(nonatomic,strong)QFDatePickerView *datePickerView;

@property(nonatomic,strong)UITableView *tableView;

// 续费tableView
@property(nonatomic,strong)MGRenewTableView *renewTableView;

@property(nonatomic,strong)NSMutableArray *dataList;

@property(nonatomic,strong)SCAdView *pageFlowView;

// QFDatePickerView对象中，选择出来的时间，格式: 2018-04
@property(nonatomic,assign)NSString *yearAndMonth;

// 渠道管理输出模型
@property(nonatomic,strong)MGChannelManageOutModel *channelModel;

// 用户综合使用模型
@property(nonatomic,strong)MGUserSynthesisUseOutModel *synthesisUseOutModel;

// 顶部滑动轮播图
@property(nonatomic,strong)NSMutableArray *flowArr;

// 顶部滑动到的index
@property(nonatomic,assign)NSInteger flowIndex;

/* 列表显示数据*/
// 注册用户
@property(nonatomic,strong)NSMutableArray *registerUserArr;
// 活跃用户
@property(nonatomic,strong)NSMutableArray *activieUserArr;
// 首次入网
@property(nonatomic,strong)NSMutableArray *firstActivationArr;
// 续费
@property(nonatomic,strong)NSMutableArray *renewArr;
// 停机
@property(nonatomic,strong)NSMutableArray *stopArr;

// 首次入网总量
@property(nonatomic,assign)double firstActivationTotal;
// 续费总量
@property(nonatomic,assign)double renewTotal;
// 停机总量
@property(nonatomic,assign)double stopTotal;
// 注册用户总量
@property(nonatomic,assign)double registerUserTotal;
// 活跃用户总量
@property(nonatomic,assign)double activieUserTotal;

@end

@implementation MGNewUserStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self configNav];
    
    [self configFilterView];
    
    [self configScrollView];
    
    [self configTableView];
    
    // 默认，首次进来拉取一次数据
    [self requestUserStatisticRequest];
    
    // 接收侧滑栏切换用户通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchUserNotice) name:SwithUserNotice object:nil];
}

// 接收侧滑栏切换用户通知响应
- (void)switchUserNotice{
    
    [SVProgressHUD showWithTips:@"加载中..."];
    
    MGLeftMenuModel *model =  [MGUserDefaultUtil getCurrentUser];
    self.navigationItem.title = model.name;
    
    [self requestUserStatisticRequest];
}

// 获取用户请求
- (void)requestUserStatisticRequest{
    
    NSString *yearAndMonth = [MGItemTool getCurrentYearAndMonthOtherType2];
    NSInteger holdId = [MGUserDefaultUtil getUserHoldId];
    // 测试holdid：4123
    [[[MGUserStatisticRequest alloc] initWithHoldId:holdId starMonth:yearAndMonth delegate:self] start];
}

#pragma mark - 网络响应
// 请求成功
- (void)requestFinished:(YTKBaseRequest *)request{
    
    [super requestFinished:request];
    
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.renewTableView.tableView.mj_header endRefreshing];
    
    // 用户统计模块筛选条件返回
    if ([request isKindOfClass:[MGUserStatisticRequest class]]) {
        
        [request requestSuccessBlock:^(__kindof NSDictionary *dic) {
            
        MGChannelManageOutModel *model = [MGChannelManageOutModel mj_objectWithKeyValues:NetParse.result(dic)];
        NSMutableArray *arr = model.rptUserSynthesisUseEntity;
      
        // 处理列表需要展示数据展示
        [self handleSelectDataDisplay:arr];
            
        NSString *firstActivationTotalStr = Formart.num(self.firstActivationTotal);
        NSString *renewTotallStr = [NSString stringWithFormat:@"¥%@",Formart.num(self.renewTotal)];
        NSString *stopTotalStr = Formart.num(self.stopTotal);
        NSString *registerUserTotalStr = Formart.num(self.registerUserTotal);
        NSString *activieUserTotalStr = Formart.num(self.activieUserTotal);
       
        // 处理顶部滑动视图需要展示数据
        MGPageFlowModel *renew = [[MGPageFlowModel alloc] initWithTitle:@"续费" num:renewTotallStr];
        MGPageFlowModel *firstIntoNet = [[MGPageFlowModel alloc] initWithTitle:@"首次入网" num:firstActivationTotalStr];
        MGPageFlowModel *stop = [[MGPageFlowModel alloc] initWithTitle:@"停机" num:stopTotalStr];
        MGPageFlowModel *registerUser = [[MGPageFlowModel alloc] initWithTitle:@"注册用户" num:registerUserTotalStr];
        MGPageFlowModel *activityUser = [[MGPageFlowModel alloc] initWithTitle:@"活跃用户" num:activieUserTotalStr];
            
        [self.flowArr removeAllObjects];
        [self.flowArr addObject:renew];
        [self.flowArr addObject:firstIntoNet];
        [self.flowArr addObject:stop];
        [self.flowArr addObject:registerUser];
        [self.flowArr addObject:activityUser];
            
        [_pageFlowView reloadWithDataArray:self.flowArr];
            
        } failBlock:^(__kindof NSString *reason) {
            [SVProgressHUD showWithToast:reason superView:self.view];
        }];
    }
}

// 请求失败
- (void)requestFailed:(YTKBaseRequest *)request{
    
    [super requestFailed:request];
    
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.renewTableView.tableView.mj_header endRefreshing];
    
    [SVProgressHUD showWithToast:@"网络请求失败" superView:self.view];
}

#pragma mark - 处理查询数据(包含列表与顶部滑动视图相关数据)
- (void)handleSelectDataDisplay:(NSMutableArray *)arr{
    
    [self.registerUserArr removeAllObjects];
    [self.activieUserArr removeAllObjects];
    [self.firstActivationArr removeAllObjects];
    [self.renewArr removeAllObjects];
    [self.stopArr removeAllObjects];
    
    self.registerUserTotal = 0;
    self.activieUserTotal = 0;
    self.firstActivationTotal = 0;
    self.renewTotal = 0;
    self.stopTotal = 0;
    
    // 反向遍历，便于删除
    for (MGUserSynthesisUseOutModel *model in arr.reverseObjectEnumerator) {
        
        // 删除与当前用户相同holdId的数据
        NSInteger currentHoldId = [MGUserDefaultUtil getUserHoldId];
        if (model.HoldID == currentHoldId) {
            // 分别取出首次入网、停机、注册用户、活跃用户、续费的总量
            self.registerUserTotal = model.RegisterUser;
            self.activieUserTotal = model.ActiveUser;
            self.firstActivationTotal = model.FirstActivation;
            self.renewTotal = model.RenewAmount;
            self.stopTotal = model.Stopped;
            [arr removeObject:model];
            continue;
        }
        
        // 注册用户
        MGUserSynthesisUseOutModel *aModel = [model mutableCopy];
        // self.registerUserTotal += aModel.RegisterUser;
        aModel.modelType = RegisterUserType;
        [self.registerUserArr addObject:aModel];
        
        // 活跃用户
        MGUserSynthesisUseOutModel *bModel = [model mutableCopy];
//        self.activieUserTotal += bModel.ActiveUser;
        bModel.modelType = ActivieUserType;
        [self.activieUserArr addObject:bModel];
        
        // 首次入网
        MGUserSynthesisUseOutModel *cModel = [model mutableCopy];
//        self.firstActivationTotal += cModel.FirstActivation;
        cModel.modelType = FirstActivationType;
        [self.firstActivationArr addObject:cModel];
        
        // 续费
        MGUserSynthesisUseOutModel *dModel = [model mutableCopy];
//        self.renewTotal += dModel.RenewAmount;
        dModel.modelType = RenewType;
        [self.renewArr addObject:dModel];
        
        // 停机
        MGUserSynthesisUseOutModel *eModel = [model mutableCopy];
//        self.stopTotal += eModel.Stopped;
        eModel.modelType = StopType;
        [self.stopArr addObject:eModel];
    }
    
    // 获取数组中最大值(用户绘制柱状图)
    MGUserSynthesisUseOutModel *RegisterUserMax = [arr getMaxModel_MaxValueWithProperty:@"RegisterUser"];
    MGUserSynthesisUseOutModel *ActiveUserMax = [arr getMaxModel_MaxValueWithProperty:@"ActiveUser"];
    MGUserSynthesisUseOutModel *FirstActivationMax = [arr getMaxModel_MaxValueWithProperty:@"FirstActivation"];
    MGUserSynthesisUseOutModel *StoppedMax = [arr getMaxModel_MaxValueWithProperty:@"Stopped"];

    // 将最大值赋值给原数组
    for (MGUserSynthesisUseOutModel *model in self.registerUserArr) {
        model.maxValue = RegisterUserMax.RegisterUser;
    }
    for (MGUserSynthesisUseOutModel *model in self.activieUserArr) {
        model.maxValue = ActiveUserMax.ActiveUser;
    }
    for (MGUserSynthesisUseOutModel *model in self.firstActivationArr) {
        model.maxValue = FirstActivationMax.FirstActivation;
    }
    for (MGUserSynthesisUseOutModel *model in self.stopArr) {
        model.maxValue = StoppedMax.Stopped;
    }
    
    // 将首次入网、停机、注册用户、活跃用户数组进行降序排列
    self.firstActivationArr = [self.firstActivationArr getRankArray_DescendRankWithProperty:@"FirstActivation"];
    self.stopArr = [self.stopArr getRankArray_DescendRankWithProperty:@"Stopped"];
    self.registerUserArr = [self.registerUserArr getRankArray_DescendRankWithProperty:@"RegisterUser"];
    self.activieUserArr = [self.activieUserArr getRankArray_DescendRankWithProperty:@"ActiveUser"];
    
    // 防止用户在还未请求到的时候滑动头部视图，给于对应的显示
    // 续费
    if (self.flowIndex == 0) {
        self.renewTableView.dataList = self.renewArr;
        [self.renewTableView reloadTableView];
    }
    // 首次入网
    else if (self.flowIndex == 1){
        self.dataList = self.firstActivationArr;
        [self.tableView reloadData];
    }
    // 停机
    else if (self.flowIndex == 2){
        self.dataList = self.stopArr;
        [self.tableView reloadData];
    }
    // 注册用户
    else if (self.flowIndex == 3){
        self.dataList = self.registerUserArr;
        [self.tableView reloadData];
    }
    // 活跃用户
    else if (self.flowIndex == 4){
        self.dataList = self.activieUserArr;
        [self.tableView reloadData];
    }
}

// 获取数组模型中最大值
- (id)getMaxValueWithProperty:(NSString *)property arr:(NSMutableArray *)arr {

    NSParameterAssert(property.length != 0 && property != nil);
    NSMutableArray *mArr = [arr mutableCopy];
    // 降序排列
    NSSortDescriptor *descRank = [NSSortDescriptor sortDescriptorWithKey:property ascending:false];
    [mArr sortUsingDescriptors:@[descRank]];
    id model = [mArr firstObject];
    return model;
}

// 布局筛选视图UI
- (void)configFilterView{
    
    weakSelf(self);
    self.datePickerView = [[QFDatePickerView alloc] initDatePackerWithResponse:^(NSString *yearAndMonth) {
        NSLog(@"选择的日期===>%@",yearAndMonth);
        
        NSArray *arr = [yearAndMonth componentsSeparatedByString:@"-"];
        NSString *year = [arr firstObject];
        NSString *month = [arr lastObject];
      
        // 表示1-9月份，则在前面插入一个0
        if (month.length == 1) {
            month = [NSString stringWithFormat:@"0%@",month];
            weakSelf.yearAndMonth = [NSString stringWithFormat:@"%@-%@",year,month];
        }
        else{
            weakSelf.yearAndMonth = yearAndMonth;
        }
        
        [SVProgressHUD showWithTips:@"加载中..."];
        NSInteger holdId = [MGUserDefaultUtil getUserHoldId];
        // 发送查询列表数据请求
        [[[MGUserStatisticRequest alloc] initWithHoldId:holdId starMonth:self.yearAndMonth delegate:self] start];
    }];
}

// 布局顶部滑动缩放视图UI
- (void)configScrollView{
    
    MGPageFlowModel *firstIntoNet = [[MGPageFlowModel alloc] initWithTitle:@"首次入网" num:@"0"];
    MGPageFlowModel *renew = [[MGPageFlowModel alloc] initWithTitle:@"续费" num:@"¥0"];
    MGPageFlowModel *stop = [[MGPageFlowModel alloc] initWithTitle:@"停机" num:@"0"];
    MGPageFlowModel *registerUser = [[MGPageFlowModel alloc] initWithTitle:@"注册用户" num:@"0"];
    MGPageFlowModel *activityUser = [[MGPageFlowModel alloc] initWithTitle:@"活跃用户" num:@"0"];
    [self.flowArr addObject:renew];
    [self.flowArr addObject:firstIntoNet];
    [self.flowArr addObject:stop];
    [self.flowArr addObject:registerUser];
    [self.flowArr addObject:activityUser];
    
    _pageFlowView = [[SCAdView alloc] initWithBuilder:^(SCAdViewBuilder *builder) {
        builder.adArray = self.flowArr;
        builder.viewFrame = (CGRect){0,64,self.view.bounds.size.width,120};
        builder.adItemSize = (CGSize){self.view.bounds.size.width/3.0f,60};

        builder.minimumLineSpacing = 20;
        builder.secondaryItemMinAlpha = 0.5;
        builder.threeDimensionalScale = 1.45;
        builder.itemCellClassName = @"MGPageFlowCell";
    }];

    _pageFlowView.backgroundColor = [UIColor whiteColor];
    _pageFlowView.delegate = self;
    [self.view addSubview:_pageFlowView];
}

#pragma mark -SCAdViewDelegate
// 点击触发
- (void)sc_didClickAd:(id)adModel{
    NSLog(@"sc_didClickAd-->%@",adModel);
}
// 滑动触发
- (void)sc_scrollToIndex:(NSInteger)index{
    
    // 顶部滑动视图，滑动到的index
    self.flowIndex = index;
    
    // 续费模块，表视图显示切换
    if (index == 0) {
        self.tableView.hidden = true;
        self.renewTableView.hidden = false;
        
        self.renewTableView.dataList = self.renewArr;
        [self.renewTableView reloadTableView];
    }
    else{
        self.tableView.hidden = false;
        self.renewTableView.hidden = true;
        
        if (index == 1) {
            self.dataList = self.firstActivationArr;
        }
        else if (index == 2){
            self.dataList = self.stopArr;
        }
        else if (index == 3){
            self.dataList = self.registerUserArr;
        }
        else if (index == 4){
            self.dataList = self.activieUserArr;
        }
        
        [self.tableView reloadData];
    }
    
    NSLog(@"sc_scrollToIndex-->%ld",index);
}

- (void)configTableView{

    [self.view addSubview:self.tableView];
    self.tableView.hidden = true;
    
    [self.view addSubview:self.renewTableView];
    // self.renewTableView.hidden = true;
    
    weakSelf(self);
    self.tableView.mj_header = [MGRefreshHeader headerWithRefreshingBlock:^{
        
        NSString *yearAndMonth = nil;
        if (weakSelf.yearAndMonth.length != 0) {
            yearAndMonth = weakSelf.yearAndMonth;
        }
        else{
            yearAndMonth = [MGItemTool getCurrentYearAndMonthOtherType2];
        }
        
        NSInteger holdId = [MGUserDefaultUtil getUserHoldId];
        [[[MGUserStatisticRequest alloc] initWithHoldId:holdId starMonth:yearAndMonth delegate:self] start];
    }];
}

// 布局导航栏UI
- (void)configNav{
    
    MGLeftMenuModel *model =  [MGUserDefaultUtil getCurrentUser];
    if (model == nil) {
        MGUserModel *userModel = [MGUserDefaultUtil getUserInfo];
        self.navigationItem.title = userModel.userName;
    }
    else{
        self.navigationItem.title = model.name;
    }
    
    weakSelf(self);
    // 导航栏左侧切换树形图按钮
    self.navigationItem.leftBarButtonItem = [[NavButton alloc] initWithBtnImg:@"switch" btnActionBlock:^{
        
        [weakSelf presentLeftMenuViewController:nil];
    }];
    
    // 导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [[NavButton alloc] initWithBtnStr:@"筛选" btnActionBlock:^{

        [weakSelf.datePickerView show];
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
// row数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataList.count;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MGUserStatisticTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

// cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - 懒加载
- (NSMutableArray *)flowArr{
    
    if (_flowArr == nil) {
        
        _flowArr = [NSMutableArray array];
    }
    
    return _flowArr;
}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _pageFlowView.bottom + AdaptH(10), kScreenW, self.view.height - 64 - 49 - _pageFlowView.height - AdaptH(10)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[MGUserStatisticTableCell class] forCellReuseIdentifier:identy];
    }
    
    return _tableView;
}

- (MGRenewTableView *)renewTableView{
    
    if (_renewTableView == nil) {
        
        _renewTableView = [[MGRenewTableView alloc] initWithFrame:CGRectMake(0, _pageFlowView.bottom + AdaptH(10), kScreenW, self.view.height - 64 - 49 - _pageFlowView.height - AdaptH(10))];
        
        weakSelf(self);
        _renewTableView.refreshBlock = ^{
          
            NSString *yearAndMonth = nil;
            if (weakSelf.yearAndMonth.length != 0) {
                yearAndMonth = weakSelf.yearAndMonth;
            }
            else{
                yearAndMonth = [MGItemTool getCurrentYearAndMonthOtherType2];
            }
            
            NSInteger holdId = [MGUserDefaultUtil getUserHoldId];
            [[[MGUserStatisticRequest alloc] initWithHoldId:holdId starMonth:yearAndMonth delegate:weakSelf] start];
        };
    }
    
    return _renewTableView;
}

- (NSMutableArray *)dataList{
    
    if (_dataList == nil) {
    
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

// 注册用户数组
- (NSMutableArray *)registerUserArr{
    
    if (_registerUserArr == nil) {
    
        _registerUserArr = [NSMutableArray array];
    }
    
    return _registerUserArr;
}
// 活跃用户数组
- (NSMutableArray *)activieUserArr{
    
    if (_activieUserArr == nil) {
        
        _activieUserArr = [NSMutableArray array];
    }
    
    return _activieUserArr;
}
// 首次入网数组
- (NSMutableArray *)firstActivationArr{
    
    if (_firstActivationArr == nil) {
        
        _firstActivationArr = [NSMutableArray array];
    }
    
    return _firstActivationArr;
}
// 续费数组
- (NSMutableArray *)renewArr{
    
    if (_renewArr == nil) {
        
        _renewArr = [NSMutableArray array];
    }
    
    return _renewArr;
}
// 停机数组
- (NSMutableArray *)stopArr{
    
    if (_stopArr == nil) {
        
        _stopArr = [NSMutableArray array];
    }
    
    return _stopArr;
}

@end
