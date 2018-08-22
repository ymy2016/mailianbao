//
//  MGPerCardListViewController.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/4.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerCardListViewController.h"
#import "MGPerCardTableViewCell.h"
#import "RefreshDiyHeader.h"
#import "MGPerWebViewController.h"
#import "MGCardListReqeust.h"
#import "MGCardListModel.h"
#import "MGRemoveBindRequest.h"
#import "MGOpenApi.h"

static NSString *CellID = @"CellID";

@interface MGPerCardListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) RefreshDiyHeader *refreshDiyHeader;
@property (nonatomic, strong) UILabel *errorLabel;
@end

@implementation MGPerCardListViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestCardList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"已绑定流量卡";
    
    [self setupUI];
    [self setupNav];
    
    [self refreshData];
}

- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MGPerCardTableViewCell class] forCellReuseIdentifier:CellID];
    self.tableView.contentInset = UIEdgeInsetsMake(AdaptH(5), 0, AdaptH(10), 0);
}

- (void)setupNav
{
    weakSelf(self);
    
    // 添加流量卡按钮
    self.navigationItem.rightBarButtonItem = [[NavButton alloc] initWithBtnImg:@"nav_per_add" btnActionBlock:^{
       
        MGPerWebViewController *webViewController = [[MGPerWebViewController alloc] init];
        [webViewController loadWebURL:[MGOpenApi bindSimWithToken:[MGUserDefaultUtil getUserToken]]];
        [weakSelf.navigationController pushViewController:webViewController animated:YES];
        
    }];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.navigationItem.leftBarButtonItem = [[NavButton alloc] initWithBtnImg:@"nav_per_back" btnActionBlock:^{
       
//        MGCardListModel *model = [weakSelf.listArray lastObject];
//        // 记录当前选择的ICCID
//        [MGUserDefaultUtil setSelectCard:model.ICCID];
        // 选卡后发送通知 通知首页进行刷新处理
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDeleteRefreshNotification" object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma makr - 下拉刷新
- (void)refreshData
{
    _refreshDiyHeader = [RefreshDiyHeader headerWithRefreshingBlock:^{
        
        [self requestCardList];
    
    }];
    _refreshDiyHeader.stateLabel.hidden = YES;
    _refreshDiyHeader.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = _refreshDiyHeader;
}

#pragma mark - 获取卡列表
- (void)requestCardList
{
    MGCardListReqeust *request = [[MGCardListReqeust alloc] initWithToken:[MGUserDefaultUtil getUserToken]];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSInteger errorCode = [request.responseJSONObject[@"error"] integerValue];
        
        if (0 == errorCode) {
            
            id object = request.responseJSONObject;
            NSArray *objects = [MGCardListModel mj_objectArrayWithKeyValuesArray:object[@"result"]] ;
            self.listArray = [NSMutableArray arrayWithArray:objects];
            
            [self.errorLabel setHidden:YES];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        else
        {
            [self.errorLabel setHidden:NO];
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.listArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGPerCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    
    if ([self.listArray count] != 0) {
        MGCardListModel *model = self.listArray[indexPath.section];
        cell.cardModel = model;
    }
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptH(95);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return AdaptH(5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return AdaptH(5);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    MGCardListModel *model = self.listArray[indexPath.section];
    
    // 记录当前选择的ICCID
    [MGUserDefaultUtil setSelectCard:model.ICCID];
    
    // 选卡后发送通知 通知首页进行刷新处理
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshHomeNotification" object:model.ICCID];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 指定编辑类型
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
// 文字描述
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解除绑定";
}
// 删除Cell的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [MGAlertUtil mg_actionsOneWithTitle:@"是否确认解绑该卡号?" btnStr:@"确定" superController:self btnActionBlock:^{
        
        [SVProgressHUD showWithTips:@"正在进行解绑..."];
        
        MGCardListModel *model = self.listArray[indexPath.section];
        // 进行解绑请求
        MGRemoveBindRequest *request = [[MGRemoveBindRequest alloc] initWithToken:[MGUserDefaultUtil getUserToken] simID:model.SimID];
        [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            
            NSInteger errorCode = [request.responseJSONObject[@"error"] integerValue];
            if (0 == errorCode) {
                // 获取当前行
                NSUInteger row = indexPath.section;
                // 在数组中删除当前行数据
                [self.listArray removeObjectAtIndex:row];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
                
                // 当前记录的ICCID是删除的ICCID
                if ([[MGUserDefaultUtil getSelectCard] isEqualToString:model.ICCID])
                {
                    [MGUserDefaultUtil setSelectCard:nil];
                }
                
                // 通知首页进行刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kDeleteRefreshNotification" object:nil];
                
                [SVProgressHUD showSuccessWithStatus:@"该卡解除绑定成功"];
                
                // 数组为空显示提示
                if ([self.listArray count] == 0) {
                    [self.errorLabel setHidden:NO];
                }
            }
            else {
                // 取消编辑状态
                [self.tableView setEditing:NO animated:YES];
                [SVProgressHUD showErrorWithStatus:@"解除绑定失败,请重试"];
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [SVProgressHUD dismiss];
        }];
        
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (NSMutableArray *)listArray
{
    if (!_listArray)
    {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (UILabel *)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - kTopSubHeight)];
        _errorLabel.text = @"当前账号尚未绑定流量卡";
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.font = [UIFont systemFontOfSize:14.f];
        _errorLabel.textColor = [UIColor darkTextColor];
        _errorLabel.hidden = YES;
        [self.tableView addSubview:_errorLabel];
    }
    return _errorLabel;
}

@end
