//
//  MGMineAcountViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/20.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGMineAccountViewController.h"
#import "NavButton.h"
#import "MGLoginRootViewController.h"
#import "MGCorrectPWViewController.h"
#import "MGUserDefaultUtil.h"
#import "MGSimMenuDB.h"

// 空格占位字符串
#define SpcaceStr @"       "

@interface MGMineAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mainTableView;

@end

static NSString *identy = @"cell";

@implementation MGMineAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"我的账户";
    
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
}


- (NSMutableArray *)dataList
{
    if (_dataList == nil)
    {
        MGUserModel *model = [MGUserDefaultUtil getUserInfo];
        NSString *userName = model.userName;
        NSString *holdName = model.holdName;
        
        NSString *str1 = [NSString stringWithFormat:@"%@%@%@",@"用户名称",SpcaceStr,holdName];
        NSString *str2 = [NSString stringWithFormat:@"%@%@%@",@"登陆账号",SpcaceStr,userName];
        NSString *str3 = @"修改账户密码";
       
        // 构造二维数组，赋值用
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:str1,str2,nil];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:str3,nil];
        _dataList = [NSMutableArray arrayWithObjects:arr1,arr2,nil];
    }

    return _dataList;
}

// 懒加载，创建表
- (UITableView *)mainTableView
{
    if (_mainTableView == nil)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, AdaptH(260)) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.separatorColor = UIColorFromRGB(0xdddddd);
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.scrollEnabled = NO;
        
        // 注册单元格
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identy];
    }

    return _mainTableView;
}

// 导航栏左侧返回
- (void)back
{
    [super back];
}

// 布局视图UI
- (void)configUI
{
    [self.view addSubview:self.mainTableView];
    
    // 解决表视图分割线偏移问题
    [self solveTableViewSeparate];
    
    UIButton *loginOutBtn = [[UIButton alloc] init];
    loginOutBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(19)];
    [loginOutBtn setBackgroundImage:[UIImage imageNamed:@"tuichubtn"] forState:UIControlStateNormal];
    [loginOutBtn setBackgroundImage:[UIImage imageNamed:@"tuichubtn-press"] forState:UIControlStateHighlighted];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateHighlighted];
    [loginOutBtn addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOutBtn];
    [loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).mas_offset(-AdaptH(50));
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).mas_offset(AdaptW(20));
        make.right.equalTo(self.view).mas_offset(-AdaptW(20));
    }];
    
}

// “退出登录”事件响应
- (void)loginOutAction
{
    [MGAlertUtil mg_alertTwoWithTitle:@"您确定要退出？" leftBtnStr:@"取消" rightBtnStr:@"确定" superController:self leftBtnActionBlock:nil rightBtnActionBlock:^{
        
        MGLoginRootViewController *mgLoginVC = [[MGLoginRootViewController alloc] init];
        [mgLoginVC showLoginIndex:0];
        [UIApplication sharedApplication].keyWindow.rootViewController = mgLoginVC;
        
        // 清空NSUserDefault本地数据
        [MGUserDefaultUtil removeUserDefaultInfo];
        
        // 清空MGSimMenuDB信息
        [MGSimMenuDBManager dropTableFromDB];
    
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
// 返回section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// 返回row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 1;
    }
    
    return 0;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:AdaptFont(16)];
    
    // cell.textLabel 赋值
    cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return cell;
}

// 返回组的头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return AdaptH(8);
    }
    else if (section == 1)
    {
        return AdaptH(12);
    }
    
    return 0;
}

// 返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptH(51);
}

// 单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        MGCorrectPWViewController *mgCorrectPWVC = [[MGCorrectPWViewController alloc] init];
        [self.navigationController pushViewController:mgCorrectPWVC animated:YES];
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
    NSLog(@"%s",__func__);
}


@end
