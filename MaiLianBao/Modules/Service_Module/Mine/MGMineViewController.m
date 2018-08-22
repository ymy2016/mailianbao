//
//  MGMineViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGMineViewController.h"
#import "MGMineTableHeadView.h"
#import "UIView+BSLine.h"
#import "MGMineAccountViewController.h"
#import "MGAboutViewController.h"
#import "MGMineRequest.h"
#import "MGMineModel.h"
#import "MGWebViewController.h"
#import "MGCorrectPWViewController.h"

// 更新我的模块Item信息通知
#define UpdateMineItemInfoNotice @"UpdateMineItemInfoNotice"

@interface MGMineViewController ()<UITableViewDelegate,UITableViewDataSource>

// 主体表视图
@property(nonatomic,strong)UITableView *mainTableView;

// 表的头视图
@property(nonatomic,strong)MGMineTableHeadView *headView;

// 表视图cell数据源
@property(nonatomic,strong)NSMutableArray *dataList;

// “我的”模块model
@property(nonatomic,strong)MGMineModel *mineModel;

// 表的头视图数据源
@property(nonatomic,strong)NSMutableArray *itemArray;

@end

static NSString *identy = @"cell";

@implementation MGMineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    
    [self.view addSubview:self.mainTableView];
    
    // 解决表视图分割线偏移问题
    [self solveTableViewSeparate];
 
    // 监听更新我的模块Item信息通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMineItemInfo) name:UpdateMineItemInfoNotice object:nil];
}

- (void)updateMineItemInfo
{
    // 获取“我的”模块本地数据
//    _mineModel = [MGUserDefaultUtil getMineInfo];

    self.headView.midTitle.text = [MGUserDefaultUtil getUserInfo].holdName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    // 更新表的头视图item的信息
//    [self updateMineItemInfo];
}

// 懒加载，dataList
- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [NSMutableArray arrayWithObjects:@"流量卡常见问题",@"修改账号密码",@"关于",nil];
    }
    return _dataList;
}

// 懒加载，创建表
- (UITableView *)mainTableView
{
    if (_mainTableView == nil)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.separatorColor = UIColorFromRGB(0xdddddd);
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        NSMutableArray *itemArray = [NSMutableArray arrayWithObjects:@"未激活",@"正常",@"停机",nil];

        NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",nil];

        // 添加头视图
        MGMineTableHeadView *headView = [[MGMineTableHeadView alloc] initWithFrame:CGRectMake(0,0,kScreenW,AdaptH(269)) bgImg:@"bg" logoImg:@"mlb_logo" middleTitle:@"广东省渠道商A" itemArray:itemArray contentArray:contentArray];
        self.headView = headView;
        headView.midTitle.text = [MGUserDefaultUtil getUserInfo].holdName;
        // 设置头视图
        _mainTableView.tableHeaderView = self.headView;

        weakSelf(self);
        // 头视图点击手势
        self.headView.tapBlock = ^(){

            MGMineAccountViewController *mineAcountVC = [[MGMineAccountViewController alloc] init];
            mineAcountVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:mineAcountVC animated:YES];

        };
        
        // 注册单元格
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identy];
    }
    
    return _mainTableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
// 返回row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // cell.textLabel赋值
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:AdaptFont(14)];
    
    return cell;
}

// 返回组的头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return AdaptH(20);
}

// 返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptH(44);
}

// 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        MGWebViewController *flowCardQuestionVC = [[MGWebViewController alloc] initWihtURL:URL_FlowCardQuestion title:@"流量卡常见问题"];
        [self.navigationController pushViewController:flowCardQuestionVC animated:YES];
        self.navigationController.navigationBarHidden = NO;
    }
    else if (indexPath.row == 1)
    {
        MGCorrectPWViewController *mgCorrectPWVC = [[MGCorrectPWViewController alloc] init];
        mgCorrectPWVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mgCorrectPWVC animated:YES];
        self.navigationController.navigationBarHidden = NO;
    }
    else if (indexPath.row == 2){
       
        MGAboutViewController *aboutVC = [[MGAboutViewController alloc] init];
        aboutVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutVC animated:YES];
        self.navigationController.navigationBarHidden = NO;
    }
    
}

// 解决表视图分割线偏移问题
- (void)solveTableViewSeparate
{
    if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

// 单元格将要显示调用的方法
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 配合solveTableViewSeparate，解决表视图分割线偏移问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

@end


