//
//  MGUserStaticsViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGUserStatisticViewController.h"
#import "MGSearchTreeTableViewController.h"
#import "MGWebViewController.h"
#import "MGNavigationController.h"

#import "MGRefreshHeader.h"
#import "MGCustomSegmentView.h"
#import "MGUserStatisticSectionHeaderView.h"
#import "MGUserStatisticTableViewCell.h"
#import "UIView+BSLine.h"

#import "MGLeftMenuRequest.h"
#import "MGLeftMenuModel.h"

#import "MJRefresh.h"
#import "MGCardEnum.h"
#import "UIViewController+RESideMenu.h"

static NSString * CellForTree = @"CellForTree";

@interface MGUserStatisticViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) MGCustomSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray *dataArray;       // 总表的数据源
@property (nonatomic, strong) NSMutableArray *tempDataArray;   // 刷新表的数据源
@property (nonatomic, strong) MGSearchTreeTableViewController *searchTableViewController;
@property (nonatomic, assign) SimDataType dataType;
@end

@implementation MGUserStatisticViewController

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _dataType = ThisMonthData;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"用户统计";
    
    [self configUI];
    [self configNav];
    
    // [self.mainTableView.mj_header beginRefreshing];

    // 监听左侧菜单栏切换用户的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchUserNotice) name:SwithUserNotice object:nil];
}

- (void)switchUserNotice
{
    [self.mainTableView.mj_header beginRefreshing];
}

- (void)configUI
{
    [self.view addSubview:self.segmentView];
    [self.view insertSubview:self.mainTableView belowSubview:self.segmentView];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kTopSubHeight);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(AdaptH(40)));
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
}

- (void)configNav
{
    weakSelf(self);
    // 导航栏左侧切换树形图按钮
    self.navigationItem.leftBarButtonItem = [[NavButton alloc] initWithBtnImg:@"switch" btnActionBlock:^{
        
        [weakSelf presentLeftMenuViewController:nil];
    }];
}

- (void)changeSwipeViewIndex:(UISegmentedControl *)segment
{
    _dataType = (SimDataType)segment.selectedSegmentIndex;
    
    [self.mainTableView reloadData];
}

#pragma mark - 网络请求协议
- (void)requestFinished:(YTKBaseRequest *)request
{
    __weak MGUserStatisticViewController * weakSelf = self;
    
    [request requestSuccessBlock:^(__kindof NSDictionary *dic) {

        NSLog(@"%@",dic);
        
        NSMutableArray *dataArray = [MGLeftMenuModel mj_objectArrayWithKeyValuesArray:NetParse.result(dic)];
        weakSelf.dataArray = dataArray;
        
        // 取出当前用户下的子用户
        MGLeftMenuModel *nowNodeModel = weakSelf.dataArray[0];
        NSInteger nowNodeLevel = nowNodeModel.nodeLevel;
        NSInteger nowNodeId = nowNodeModel.mId;
        
        NSMutableArray *tempDataArray = [[NSMutableArray alloc] init];
        // 添加第一个用的下级用户
        for (MGLeftMenuModel *model in self.dataArray)
        {
            if ((model.nodeLevel == nowNodeLevel + 1) && (model.parentId == nowNodeId))
            {
                [tempDataArray addObject:model];
            }
        }
        weakSelf.tempDataArray = tempDataArray;
        
        weakSelf.navigationItem.rightBarButtonItem = [[NavButton alloc] initWithBtnImg:@"rightItem_icon_search" btnActionBlock:^{
            
            MGSearchTreeTableViewController *searchTableViewController = [[MGSearchTreeTableViewController alloc] init];
            searchTableViewController.dataArray = weakSelf.dataArray;
            searchTableViewController.dataType = weakSelf.dataType;
            MGNavigationController *navigation = [[MGNavigationController alloc] initWithRootViewController:searchTableViewController];
            [weakSelf presentViewController:navigation animated:NO completion:nil];
            
        }];
        
        [weakSelf.mainTableView reloadData];
        
    } failBlock:^(__kindof NSString *reason) {
       
    }];
    
    [weakSelf.mainTableView.mj_header endRefreshing];
}

- (void)requestFailed:(YTKBaseRequest *)request
{
    if (request.responseStatusCode == 0) {
        [SVProgressHUD showInfoWithStatus:@"获取失败,请检查您的网络后重试!"];
    }
    
    [self.mainTableView.mj_header endRefreshing];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tempDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGUserStatisticTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellForTree forIndexPath:indexPath];

    cell.dataArray = self.dataArray;
    cell.dataType = _dataType;
    
    MGLeftMenuModel *model = _tempDataArray[indexPath.row];
    cell.model = model;
    
    // Cell按钮点击事件
    [cell setNodeButtonBlock:^{
        
        NSUInteger startPosition = indexPath.row + 1;
        NSUInteger endPosition = startPosition;
        
        MGLeftMenuModel *nowNodeModel = _tempDataArray[indexPath.row];
        NSInteger nowNodeLevel = nowNodeModel.nodeLevel;
        NSInteger nowNodeId = nowNodeModel.mId;
        
        if (nowNodeModel.isExpansion == NO)
        {
            for (MGLeftMenuModel *model in _dataArray)
            {
                if ((model.nodeLevel == nowNodeLevel + 1) && (model.parentId == nowNodeId))
                {
                    [_tempDataArray insertObject:model atIndex:endPosition];
                    endPosition++;
                }
            }
        }
        else
        {
            endPosition = [self removeAllNodesAtParentNode:nowNodeModel];
        }
        
        nowNodeModel.isExpansion = !nowNodeModel.isExpansion;
        
        [self.mainTableView reloadData];
    }];
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 != [self.dataArray count])
    {
        return 35;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString * urlString = nil;
//    NSString * title = nil;
//    MGLeftMenuModel *model = _tempDataArray[indexPath.row];
//    
//    if (_dataType == ThisMonthData)
//    {
//        urlString = URL_HPMonthRebate(model.mId,Token);
//        title = @"本月返利";
//    }
//    else if (_dataType == LastMonthData)
//    {
//        urlString = URL_HPBotWeb(model.mId,Token);
//        title = @"上月返利";
//    }
//    else if (_dataType == AllMonthData)
//    {
//        urlString = URL_HPAccumulateRebate(model.mId,Token);
//        title = @"累计返利";
//    }
//    
//    MGWebViewController * viewController = [[MGWebViewController alloc] initWihtURL:urlString];
//    viewController.navigationItem.title = title;
//    viewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:viewController animated:YES];
//    
//    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 != [self.dataArray count])
    {
        MGUserStatisticSectionHeaderView * headerView = [[MGUserStatisticSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, AdaptH(35)) titles:@[@"用户",@"返利",@"续费"]];
        return headerView;
    }
    return nil;
}

//// 展开Cell
//- (void)nodeOpenWithIndexPath:(NSIndexPath *)indexPath
//{
//    MGTreeNodeModel * parentNode = _tempData[indexPath.row];
//    
//    NSUInteger startPosition = indexPath.row + 1;
//    NSUInteger endPosition = startPosition;
//    
//    BOOL expand = NO;
//    for (int i = 0; i < [_nodeData count]; i++)
//    {
//        MGTreeNodeModel * node = _nodeData[i];
//        if (node.parentId == parentNode.nodeId)
//        {
//            NSLog(@"node:%@",@(node.parentId));
//            
//            node.expand = !node.expand;
//            if (node.expand)
//            {
//                [_tempData insertObject:node atIndex:endPosition];
//                expand = YES;
//                endPosition ++;
//            }
//            else
//            {
//                expand = NO;
//                break;
//            }
//        }
//    }
//    
//    // 2.获的需要修正的indexPath
//    NSMutableArray * indexPathArray = [NSMutableArray array];
//    for (NSUInteger i = startPosition; i < endPosition; i++)
//    {
//        NSIndexPath * tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        [indexPathArray addObject:tempIndexPath];
//    }
//    
//    // 3.插入或删除相关节点
//    if (expand)
//    {
//        [self.mainTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
//    }
//    else
//    {
//        [self.mainTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
//    }
//
//}

// 删除该父节点下的所有子节点
- (NSUInteger)removeAllNodesAtParentNode:(MGLeftMenuModel *)parentNode
{
    // indexOfObject:获取model所在数组的index
    NSUInteger startPosition = [_tempDataArray indexOfObject:parentNode];
    NSUInteger endPosition = startPosition+1;
    
    MGLeftMenuModel *nowNodeModel = _tempDataArray[startPosition];
    NSInteger nowNodeLevel = nowNodeModel.nodeLevel;
    
    for (NSUInteger i = startPosition+1; i<_tempDataArray.count; i++)
    {
        MGLeftMenuModel *currentModel = _tempDataArray[i];
        
        currentModel.isExpansion = NO;
        
        if ((currentModel.nodeLevel > nowNodeLevel))
        {
            endPosition++;
        }
        else
        {
            break;
        }
    }
    
    if (endPosition>startPosition) {
        
        [_tempDataArray removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
        
    }
    return endPosition;
}

- (UITableView *)mainTableView
{
    if (!_mainTableView)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _mainTableView.estimatedRowHeight = 0;
//        _mainTableView.estimatedSectionHeaderHeight = 0;
//        _mainTableView.estimatedSectionFooterHeight = 0;
        
        [_mainTableView registerClass:[MGUserStatisticTableViewCell class] forCellReuseIdentifier:CellForTree];
        
        _mainTableView.mj_header = [MGRefreshHeader headerWithRefreshingBlock:^{
            
            [[[MGLeftMenuRequest alloc] initWithHoldId:HoldId
                                              delegate:self] start];
        }];
        
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.contentInset = UIEdgeInsetsMake(self.segmentView.height, 0, 0, 0);
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
        }
    }
    
    return _mainTableView;
}

- (MGCustomSegmentView *)segmentView
{
    if (!_segmentView)
    {
        _segmentView = [[MGCustomSegmentView alloc] initWithItems:@[@"本月",@"上月",@"累计"]];
//        _segmentView.frame = CGRectMake(0, kTopSubHeight, kScreenW, AdaptH(40));
        [_segmentView addTarget:self action:@selector(changeSwipeViewIndex:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentView;
}

@end
