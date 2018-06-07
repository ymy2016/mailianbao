//
//  MGLeftMenuViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/25.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGLeftMenuViewController.h"
#import "MGLeftMenuRequest.h"
#import "MGLeftMenuModel.h"
#import "MGTreeTableView.h"
#import "RESideMenu.h"
#import "UTPinYinHelper.h"
#import "MG_NetworkCache.h"

#define CACHE_LISTDATA @"CACHE_LISTDATA"

@interface MGLeftMenuViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SelectedCellDelegate>

/// 搜索栏
@property(nonatomic,strong)UISearchBar *searchBar;

/// 搜索结果table
@property (nonatomic, strong)UITableView *resultTableView;

/// 树形图table
@property(nonatomic,strong)MGTreeTableView *tableTree;

/// 网络请求获得的树形图的数据源
@property(nonatomic,strong)NSMutableArray *dataArray;

/// 搜索结果数组
@property (nonatomic, strong)NSMutableArray *resultArray;

@end

static NSString *searchIdenty  = @"searchIdenty";

@implementation MGLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
   
    [SVProgressHUD showWithTips:@"加载中..."];
    
    [self configUIWithDataList:nil];
    
    [self loadCacheData];
    
    // 发送获取左侧菜单数据请求
    [[[MGLeftMenuRequest alloc] initWithHoldId:LoginHoldId
                                      delegate:self] start];
}

- (void)loadCacheData
{
    id cache_listData = [MG_NetworkCache cacheJsonWithURL:CACHE_LISTDATA];
    
    if (!cache_listData) return;
    
    NSMutableArray *dataArray = [MGLeftMenuModel mj_objectArrayWithKeyValuesArray:NetParse.result(cache_listData)];
//    [self configUIWithDataList:dataArray];
    
    self.tableTree.dataList = dataArray;
}

// 懒加载，树形图数据源数组
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }

    return _dataArray;
}

/// 懒加载，搜索结果数据源
- (NSMutableArray *)resultArray
{
    if (_resultArray == nil)
    {
        _resultArray = [NSMutableArray array];
    }

    return _resultArray;
}

#pragma mark - 网络请求协议
// 请求成功
- (void)requestFinished:(YTKBaseRequest *)request
{
    [super requestFinished:request];
    
    [request requestSuccessBlock:^(__kindof NSDictionary *dic) {
        
       NSMutableArray *dataArray = [MGLeftMenuModel mj_objectArrayWithKeyValuesArray:NetParse.result(dic)];
       
       self.dataArray = dataArray;
       
       // 布局UI并且传递数据
//       [self configUIWithDataList:dataArray];
       
       self.tableTree.dataList = dataArray;
        
       // 缓存首页数据
       [MG_NetworkCache save_asyncJsonResponseToCacheFile:dic
                                                   andURL:CACHE_LISTDATA
                                                   params:nil
                                                completed:^(BOOL result) {
                                                    if (result) {
                                                        NSLog(@"成功");
                                                    }
                                                    else{
                                                        NSLog(@"失败");
                                                    }
                                                }];
   }];
}

// 请求失败
- (void)requestFailed:(YTKBaseRequest *)request
{
    [super requestFailed:request];
}

- (void)configUIWithDataList:(NSMutableArray *)dataList
{
    // 初始化搜索栏
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(0, kStatusHeight, kScreenW,44);
    _searchBar.placeholder = @"搜索用户";
    _searchBar.delegate = self;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.translucent = YES;
    _searchBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_searchBar];
    
    // 初始化树形图结构
    _tableTree = [[MGTreeTableView alloc] initWithFrame:CGRectMake(0,_searchBar.bottom,kScreenW,kScreenH-_searchBar.height-kStatusHeight) style:UITableViewStylePlain data:dataList];
    
    // 设置cell点击代理
    _tableTree.mDelegate = self;
    [self.view addSubview:_tableTree];

    // 初始化搜索结果
    _resultTableView = [[UITableView alloc] initWithFrame:_tableTree.frame style:UITableViewStylePlain];
    _resultTableView.backgroundColor = [UIColor clearColor];
    _resultTableView.dataSource = self;
    _resultTableView.delegate = self;
    _resultTableView.hidden = YES;
    _resultTableView.tableFooterView = [[UIView alloc] init];
    _resultTableView.showsVerticalScrollIndicator = NO;
    [_resultTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:searchIdenty];
    
    // 表滑动，键盘收回
    _resultTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_resultTableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // 收回键盘
    [self.view endEditing:YES];
}

#pragma mark UISearchBarDelegate
// 搜索栏开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton = YES;
    _tableTree.hidden = YES;
}

// 点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
      NSLog(@"开始搜索");
}

// 点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    _tableTree.hidden = NO;
    _resultTableView.hidden = YES;
}

// 搜索框输入内容改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // 移除前一次搜索到的结果
    [self.resultArray removeAllObjects];
    
    if (searchText.length <= 0) {
        [_resultTableView reloadData];
        return;
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(MGLeftMenuModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        UTPinYinHelper *pinYinHelper = [UTPinYinHelper sharedPinYinHelper];
        if ([pinYinHelper isString:model.name MatchsKey:searchText IgnorCase:YES])
        {
            [self.resultArray addObject:model];
        }
    }];
    
    [_resultTableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
// 返回row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.resultArray.count == 0)
    {
        return 0;
    }
    else
    {
        _tableTree.hidden = YES;
        _resultTableView.hidden = NO;
        return self.resultArray.count;
    }
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchIdenty];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:AdaptFont(15)];
    
    MGLeftMenuModel *model = self.resultArray[indexPath.row];
    
    cell.textLabel.text = model.name;
    
    return cell;
}

// 点击搜索到的用户cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGLeftMenuModel *model = self.resultArray[indexPath.row];
    NSInteger holdId = model.mId;

    [MGUserDefaultUtil saveChangedHoldId:holdId];
   
    [MGUserDefaultUtil saveCurrentUser:model];
    
    // 发送修改“首页”、“流量卡”、“用户统计”数据的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:SwithUserNotice object:nil];
    
    RESideMenu *sideMenu = (RESideMenu *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [sideMenu hideMenuViewController];
}

#pragma mark - SelectedCellDelegate
// 点击用户列表cell实现的协议
- (void)selectedCellWithModel:(MGLeftMenuModel *)model
{
#warning 点击后保存切换的holdId
    [MGUserDefaultUtil saveChangedHoldId:model.mId];
    
    [MGUserDefaultUtil saveCurrentUser:model];
    
   // 发送修改“首页”、“流量卡”、“用户统计”数据的通知
   [[NSNotificationCenter defaultCenter] postNotificationName:SwithUserNotice object:nil];
    
   RESideMenu *sideMenu = (RESideMenu *)[UIApplication sharedApplication].keyWindow.rootViewController;
   [sideMenu hideMenuViewController];
}



@end
