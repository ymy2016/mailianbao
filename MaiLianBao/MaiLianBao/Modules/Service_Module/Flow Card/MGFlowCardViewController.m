//
//  MGFlowCardViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGFlowCardViewController.h"
#import "MGFlowCardInformationViewController.h"
#import "MGQRViewController.h"

#import "JSDropDownMenu.h"

#import "MGRefreshHeader.h"
#import "MGRefreshFooter.h"
#import "MJRefresh.h"
#import "UIView+BSLine.h"
#import "UILabel+Category.h"

#import "MGFlowCardTableViewCell.h"

#import "MGFlowCardRequest.h"
#import "MGSimMenuRequest.h"

#import "MGSimMenuModel.h"
#import "MGFlowCardModel.h"

#import "MGSimMenuDB.h"
#import "MGNavigationController.h"

static NSString * CellIdentifier = @"MGFlowCardTableViewCell";

@interface MGFlowCardViewController ()<UITableViewDelegate, UITableViewDataSource, JSDropDownMenuDataSource, JSDropDownMenuDelegate, UISearchBarDelegate>
{
    NSMutableArray *_data1;         // 筛选菜单1组数据
    NSMutableArray *_data2;         // 筛选菜单2组数据
    NSMutableArray *_data3;         // 筛选菜单3组数据
    NSMutableArray *_data4;         // 筛选菜单4组数据
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    NSInteger _currentData4Index;
    NSString *_menuTitle2;
    
    NSInteger _page;
    SimCardType _cardType;         // 默认的类型卡
}
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JSDropDownMenu * dropDownMenu;
@property (nonatomic, strong) UISearchBar * searchBar;

@property (nonatomic, strong) NSArray *simData;                 // 卡集合
@property (nonatomic, strong) NSArray *packageTotalData;        // 卡套餐集合
@property (nonatomic, strong) NSArray *stateData;               // 卡状态集合

@property (nonatomic, strong) MGSimMenuModel *simMenuModel;
@property (nonatomic, strong) MGFlowCardModel *flowCardModel;   // 流量卡列表信息Model
@property (nonatomic, strong) MGFlowCardParams *params;         // 列表请求接口参数

@end

@implementation MGFlowCardViewController

#pragma mark - Left Cycle

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _data1 = [NSMutableArray arrayWithObject:@"类型"];
        _data2 = [NSMutableArray arrayWithObject:@"--"];
        _data3 = [NSMutableArray arrayWithObject:@"全部"];
        _data4 = [NSMutableArray arrayWithObjects:@"默认排序", @"剩余流量", @"剩余服务", nil];

        _dataArray = [NSMutableArray array];
        _menuTitle2 = @"全部";
        
        _params = [MGFlowCardParams param];
        
        _cardType = SimCardForNULL;
    }
    return self;
}

- (void)switchUserNotice
{
    _currentData1Index = 0;
    _cardType = SimCardForNULL;
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"流量卡";

    [self configNavUI];
    [self configUI];
    
    // 首次进入自动下拉刷新
    [self.tableView.mj_header beginRefreshing];
    
    // 监听左侧菜单栏切换用户的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchUserNotice) name:SwithUserNotice object:nil];
}

- (void)configNavUI
{
    // 导航栏右侧扫描QR按钮
    weakSelf(self);
    self.navigationItem.rightBarButtonItem = [[NavButton alloc] initWithBtnImg:@"fc_left_scan" btnActionBlock:^{
        MGQRViewController * viewController = [[MGQRViewController alloc] initWitType:QRTypeScan];
        viewController.navigationItem.title = @"扫一扫";
        viewController.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    }];
   
    MGUserModel *userModel = [MGUserDefaultUtil getUserInfo];
    // 有扫码入库功能
    if (userModel.isCanDistribute == 1) {
        self.navigationItem.leftBarButtonItem = [[NavButton alloc] initWithBtnImg:@"Scan_btn" btnActionBlock:^{
            MGQRViewController *scanVC = [[MGQRViewController alloc] initWitType:QRTypeInput];
            scanVC.navigationItem.title = @"扫码录入";
            MGNavigationController *nav = [[MGNavigationController alloc] initWithRootViewController:scanVC];
            [weakSelf presentViewController:nav animated:true completion:nil];
        }];
    }
}

- (void)configUI
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.dropDownMenu];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dropDownMenu.mas_bottom);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
}

// 获取主列表信息
- (void)loadListData
{
    [SVProgressHUD showWithTips:@"正在加载"];
    
    _page = 1;
    _params.P = _page;
    _params.holdId = HoldId;
    _params.simFromType = _cardType;
    
    MGFlowCardRequest *request = [[MGFlowCardRequest alloc] initWithParam:_params];
    request.tag = 100;
    request.delegate = self;
    [request start];
}

- (void)loadMoreData
{
    _page++;
    _params.P = _page;
    _params.holdId = HoldId;
    
    MGFlowCardRequest *request = [[MGFlowCardRequest alloc] initWithParam:_params];
    request.tag = 200;
    request.delegate = self;
    [request start];
}

#pragma mark - 网络请求协议
// 网络请求成功
- (void)requestFinished:(YTKBaseRequest *)request
{
    // 获取新内容
    if (request.tag == 100)
    {
        // 清空搜索字段
        _params.key = @"";
    
        [request requestSuccessBlock:^(__kindof NSDictionary *dic) {
            
            MGFlowCardModel *model = [MGFlowCardModel mj_objectWithKeyValues:NetParse.result(dic)];
            self.flowCardModel = model;
            
            _dataArray = [NSMutableArray arrayWithArray:self.flowCardModel.list];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            
        } failBlock:^(__kindof NSString *reason) {
            
            [SVProgressHUD showErrorWithStatus:reason];
            [_dataArray removeAllObjects];
            [self.tableView reloadData];
        }];
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    // 上拉加载
    if (request.tag == 200)
    {
        [request requestSuccessBlock:^(__kindof NSDictionary *dic) {
            
            MGFlowCardModel *model = [MGFlowCardModel mj_objectWithKeyValues:NetParse.result(dic)];
            for (MGListInfo * info in model.list)
            {
                [_dataArray addObject:info];
            }
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
        } failBlock:^(__kindof NSString *reason) {
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }];
    }
}

- (void)chainRequestFinished:(YTKChainRequest *)chainRequest
{
    
    [MGSimMenuRequest requestArray:chainRequest.requestArray successBlock:^(__kindof NSDictionary *dic) {
        
//        NSLog(@"%@",dic);
        
        MGSimMenuModel *model = [MGSimMenuModel mj_objectWithKeyValues:NetParse.result(dic)];
        self.simMenuModel = model;
        
//        _currentData1Index = 0;
        _currentData2Index = 0;
        _currentData3Index = 0;
        _currentData4Index = 0;
        _menuTitle2 = @"全部";
        [self.dropDownMenu clearCollectionMenuSelectWithIndex:1];
        
        // 筛选卡类型
        _data1 = [self.simMenuModel simData];

        // 筛选卡套餐
        _data2 = [self.simMenuModel packageDataWithType:_cardType];
        
        // 筛选卡状态
        _data3 = [self.simMenuModel stateDataWithType:_cardType];
    
        // 设置默认值
        _params.simFromType = _cardType;
        _params.packageType = nil;
        _params.simState = nil;
        _params.sortField = nil;
        
        [self.dropDownMenu reloadData];
        
    } failBlock:^(__kindof NSString *reason) {
        
    }];
    
    
    // 卡列表
    [MGFlowCardRequest requestArray:chainRequest.requestArray successBlock:^(__kindof NSDictionary *dic) {
        
        NSLog(@"~~~~~~~~~%@",dic);
        
        MGFlowCardModel *model = [MGFlowCardModel mj_objectWithKeyValues:NetParse.result(dic)];
        self.flowCardModel = model;
        
        _dataArray = [NSMutableArray arrayWithArray:self.flowCardModel.list];
        
    } failBlock:^(__kindof NSString *reason) {
        
        [SVProgressHUD showWithToast:reason superView:self.view];
        
        [_dataArray removeAllObjects];
        
    }];
    
    self.searchBar.userInteractionEnabled = YES;
    self.searchBar.hidden = NO;
    self.dropDownMenu.userInteractionEnabled = YES;
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer resetNoMoreData];
}

// 网络请求失败
- (void)requestFailed:(YTKBaseRequest *)request
{
    [request requestFailBlock:^(__kindof NSString *reason) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest *)request
{
    if (request.responseStatusCode == 0) {
        [SVProgressHUD showInfoWithStatus:@"获取失败,请检查您的网络后重试!"];
    }
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - SearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // 输入过程中
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    _params.key = searchBar.text;
    
    [self loadListData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    if (self.searchBar.text.length == 0 || [self.searchBar.text isEqualToString:@""])
    {
        [self loadListData];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGFlowCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
    MGListInfo *_listInfo = self.dataArray[indexPath.row];
    
    [cell setModel:_listInfo];

    return cell;
}

#pragma mark - TableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 != [self.dataArray count]) {
        // 流量卡header UI
        UIView * view = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenW, AdaptH(30)}];
        view.backgroundColor = [UIColor whiteColor];
        [view addBottomLineWithLeftPading:0 andRightPading:0];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:(CGRect){AdaptW(5), 0, view.width - AdaptW(10), AdaptH(30)}];
        [view addSubview:titleLabel];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13.f];
        titleLabel.textColor = UIColorFromRGB(0x666666);
        
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"共,"];
        NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"正常,"];
        NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"未激活,"];
        NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc] initWithString:@"停机"];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
        if (_cardType == SimCardForCUCC)
        {
            [string1 insertAttributedString:Formart.orangeNum(self.flowCardModel.total.allCount) atIndex:1];
            [string2 insertAttributedString:Formart.orangeNum(self.flowCardModel.total.activatedCount) atIndex:string2.length - 1];
            [string3 insertAttributedString:Formart.orangeNum(self.flowCardModel.total.unactivatedCount) atIndex:string3.length - 1];
            [string4 insertAttributedString:Formart.orangeNum(self.flowCardModel.total.deactivatedCount) atIndex:string4.length];
            
            [string appendAttributedString:string1];
            [string appendAttributedString:string2];
            [string appendAttributedString:string3];
            [string appendAttributedString:string4];
        }
        else
        {
            [string1 insertAttributedString:Formart.orangeNum(self.flowCardModel.total.allCount) atIndex:1];
            [string2 insertAttributedString:Formart.orangeNum(self.flowCardModel.total.activatedCount) atIndex:string2.length - 1];
            [string4 insertAttributedString:Formart.orangeNum(self.flowCardModel.total.deactivatedCount) atIndex:string4.length];
            [string appendAttributedString:string1];
            [string appendAttributedString:string2];
            [string appendAttributedString:string4];
        }
        
        titleLabel.attributedText = string;
        
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 != [self.dataArray count]) {
        return AdaptH(30);
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    if ([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
        return;
    }
    
    MGListInfo *model = self.dataArray[indexPath.row];
    
    MGFlowCardInformationViewController *viewController = [[MGFlowCardInformationViewController alloc] initWithCode:model.simId CardType:model.simFromType GetType:SimGetWithListType];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark JSDropDownMenu Delegate && DataSource

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu
{
    return 4;
}

// 是否需要显示为UICollectionView 默认为否
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column
{
    if (column == 1)
    {
        return YES;
    }
    return NO;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column
{
    if (column==0)
    {
        return _currentData1Index;
    }
    if (column==1)
    {
        return _currentData2Index;
    }
    if (column==2)
    {
        return _currentData3Index;
    }
    if (column==3) {
        return _currentData4Index;
    }
    return 0;
}

// 是否修改标题
- (BOOL)changeTitleInColumn:(NSInteger)column
{
    return YES;
}

// 表视图显示时，是否需要两个表显示
- (BOOL)haveRightTableViewInColumn:(NSInteger)column
{
    return NO;
}

// 表视图显示时，左边表显示比例
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column
{
    return 1;
}

// 每组有多少个元素
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow
{
    if (column==0)
    {
        return _data1.count;
    }
    else if (column==1)
    {
        return _data2.count;
    }
    else if (column==2)
    {
        return _data3.count;
    }
    else if (column==3)
    {
        return _data4.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    switch (column)
    {
        case 0: return _data1[_currentData1Index];
            break;
        case 1: return _menuTitle2;
            break;
        case 2: return _data3[_currentData3Index];
            break;
        case 3: return _data4[_currentData4Index];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath
{
    if (indexPath.column==0)
    {
        return _data1[indexPath.row];
    }
    else if (indexPath.column==1)
    {
        return _data2[indexPath.row];
    }
    else if (indexPath.column==2)
    {
        return _data3[indexPath.row];
    }
    else
    {
        return _data4[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        if (_currentData1Index == indexPath.row)
        {
            return;
        }
        _currentData1Index = indexPath.row;
        
        _menuTitle2 = @"全部";
        // 清除第二列的头部文字
        [self.dropDownMenu clearCollectionMenuSelectWithIndex:1];
        
        _cardType = [self.simMenuModel typeWithName:_data1[_currentData1Index]];
        
        [self.simMenuModel filterWithType:_cardType
                                   result:^(NSMutableArray *packageData, NSMutableArray *stateData) {
                                       _data2 = packageData;
                                       _data3 = stateData;
                                       // 刷新menu
                                       [self.dropDownMenu reloadData];
                                       
                                   }];
    }
    else if(indexPath.column == 1)
    {
    
    }
    else if(indexPath.column == 2)
    {
        if (_currentData3Index == indexPath.row)
        {
            return;
        }
        _currentData3Index = indexPath.row;
        _params.simState = [self.simMenuModel stateTypeWithName:_data3[indexPath.row]];
    }
    else
    {
        if (_currentData4Index == indexPath.row)
        {
            return;
        }
        
        if (indexPath.row == 1)
        {
            // expiretime flowleftvalue
            _params.sortField = @"flowleftvalue";
        }
        else if (indexPath.row == 2)
        {
            _params.sortField = @"expiretime";
        }
        else
        {
            _params.sortField = @"";
        }
        _currentData4Index = indexPath.row;
    }

    [self loadListData];
}

- (void)menu:(JSDropDownMenu *)menu didSelectColumn:(NSInteger)column
{
    [self.searchBar resignFirstResponder];
}

- (void)menu:(JSDropDownMenu *)menu didSelectCollectionViewWithArray:(NSArray *)array title:(NSString *)title
{
    _menuTitle2 = title;
    
    _params.packageType = [self.simMenuModel packageTypeWithName:array type:_params.simFromType];

    [self loadListData];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = AdaptH(70);
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, kScreenW, AdaptH(44));
        _searchBar = [[UISearchBar alloc] initWithFrame:headerView.frame];
        _searchBar.tintColor = [UIColor orangeColor];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"ICCID号/SIM卡号";
        [_searchBar setImage:[UIImage imageNamed:@"fc_icon_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setBackgroundImage:[UIImage imageNamed:@"search_background"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_text_background"] forState:UIControlStateNormal];
        _searchBar.hidden = YES;
        
        [headerView addSubview:_searchBar];
        
        _tableView.tableHeaderView = headerView;
        
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[MGFlowCardTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
        }
        
        weakSelf(self);
        // 下拉刷新
        _tableView.mj_header = [MGRefreshHeader headerWithRefreshingBlock:^{
            
            weakSelf.dropDownMenu.userInteractionEnabled = NO;
            _searchBar.userInteractionEnabled = NO;
            
            // 重置筛选菜单 默认第一页
            _page = 1;
            // 初始化请求参数
            // 第一次加载默认只传运营商类型 其他参数为空
            MGFlowCardParams *params = [MGFlowCardParams param];
            // 筛选菜单请求
            MGSimMenuRequest *simRequest = [[MGSimMenuRequest alloc] initWithHoldId:HoldId];
            
            YTKChainRequest *chainRequest = [[YTKChainRequest alloc] init];
            // 设置依赖关系 加载主列表数据
            [chainRequest addRequest:simRequest callback:^(YTKChainRequest *chainRequest, YTKBaseRequest *baseRequest) {
                MGSimMenuRequest *simResult = (MGSimMenuRequest *)baseRequest;
                if (_cardType == SimCardForNULL)
                {
                    _cardType = [simResult simFromType];
                }
                // 默认请求参数
                params.simFromType = _cardType;
                // 主列表请求
                MGFlowCardRequest *flowCardRequest = [[MGFlowCardRequest alloc] initWithParam:params];
                [chainRequest addRequest:flowCardRequest callback:nil];
//                // 返回当前存储的第一页缓存数据
//                if ([flowCardRequest cacheJson]) {
//                    
//                    [self.tableView.mj_header endRefreshing];
//                    [self.tableView.mj_footer resetNoMoreData];
//                    self.searchBar.userInteractionEnabled = YES
//                    self.searchBar.hidden = NO;
//                    self.dropDownMenu.userInteractionEnabled = YES;
//                    
//                    MGFlowCardModel *model = [MGFlowCardModel mj_objectWithKeyValues:NetParse.result(flowCardRequest.cacheJson)];
//                    self.flowCardModel = model;
//                    _dataArray = [NSMutableArray arrayWithArray:self.flowCardModel.list];
//                    [self.tableView reloadData];
//                }
            }];
            
            chainRequest.delegate = weakSelf;
            [chainRequest start];
        }];
        
        _tableView.mj_footer.automaticallyHidden = YES;
        _tableView.mj_footer = [MGRefreshFooter footerWithRefreshingBlock:^{

            [weakSelf loadMoreData];
        }];
//        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    return _tableView;
}

- (JSDropDownMenu *)dropDownMenu
{
    if (!_dropDownMenu) {
        _dropDownMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, kTopSubHeight) andHeight:AdaptH(40)];
        _dropDownMenu.indicatorColor = [UIColor darkTextColor];
        _dropDownMenu.separatorColor = RGB(210, 210, 210, 1);
        _dropDownMenu.textColor = [UIColor darkTextColor];
        _dropDownMenu.isCollectionMultiselect = YES;
        _dropDownMenu.dataSource = self;
        _dropDownMenu.delegate = self;
    }
    return _dropDownMenu;
}
@end
