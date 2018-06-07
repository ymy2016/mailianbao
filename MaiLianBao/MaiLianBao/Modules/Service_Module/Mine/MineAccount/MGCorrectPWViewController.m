//
//  MGCorrectPWViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/20.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGCorrectPWViewController.h"
#import "MGMineAccountTableViewCell.h"
#import "MGCorrectPWRequest.h"
#import "MGUserDefaultUtil.h"
#import "AppDelegate.h"
#import "MGSimMenuDB.h"

@interface MGCorrectPWViewController ()<UITableViewDelegate,UITableViewDataSource>

// 主体表视图
@property(nonatomic,strong)UITableView *mainTableView;
// 旧密码
@property(nonatomic,strong)NSString *oldPWStr;
// 新密码
@property(nonatomic,strong)NSString *mNewPWStr;
// 确认新密码
@property(nonatomic,strong)NSString *againNewPWStr;

@end

static NSString *identy = @"cell";

@implementation MGCorrectPWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的账户";
    
    [self configUI];
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
        [_mainTableView registerClass:[MGMineAccountTableViewCell class] forCellReuseIdentifier:identy];
    }
    
    return _mainTableView;
}

// 布局UI
- (void)configUI
{
    [self.view addSubview:self.mainTableView];
    
    // 解决表视图分割线偏移问题
    [self solveTableViewSeparate];
    
    UIButton *commitBtn = [[UIButton alloc] init];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"button-press"] forState:UIControlStateHighlighted];
    [commitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [commitBtn setTitle:@"确认提交" forState:UIControlStateHighlighted];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(19)];
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.mainTableView.mas_bottom).mas_offset(AdaptH(30));
        make.height.mas_equalTo(AdaptH(47));
        make.left.equalTo(self.view).mas_offset(AdaptW(20));
        make.right.equalTo(self.view).mas_offset(-AdaptW(20));
    }];

    // 添加取消键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeKeyboard)];
    [self.view addGestureRecognizer:tap];
}

// 取消键盘手势响应事件
- (void)hiddeKeyboard
{
    [self.view endEditing:YES];
}

// 确认提交响应事件
- (void)commitAction
{
    if (self.oldPWStr.length == 0)
    {
        [SVProgressHUD showWithToast:@"请输入旧密码" superView:self.view];
    }
    else if (self.mNewPWStr.length == 0)
    {
        [SVProgressHUD showWithToast:@"请输入新密码" superView:self.view];
    }
    else if (self.againNewPWStr.length == 0)
    {
        [SVProgressHUD showWithToast:@"请再次输入新密码" superView:self.view];
    }
    else if (![self.mNewPWStr isEqualToString:self.againNewPWStr])
    {
        [SVProgressHUD showWithToast:@"两次新密码不一致" superView:self.view];
    }
    else if ([self.oldPWStr isEqualToString:self.mNewPWStr])
    {
        [SVProgressHUD showWithToast:@"新旧密码不能相同" superView:self.view];
    }
    else if (self.oldPWStr.length < 6 || self.mNewPWStr.length < 6 || self.againNewPWStr.length < 6)
    {
        [SVProgressHUD showWithToast:@"密码位数不能少于6位" superView:self.view];
    }
    else
    {
        MGUserModel *model = [MGUserDefaultUtil getUserInfo];
        NSInteger userId = model.userId;
        
        NSString *oldPWStrMD = [self.oldPWStr MD5String];
        NSString *newPWStrMD = [self.mNewPWStr MD5String];
        
        // TODO: 发送“修改密码”请求
        [[[MGCorrectPWRequest alloc] initWithUserId:userId OldPassword:oldPWStrMD newPassword:newPWStrMD showTips:@"提交中..." delegate:self] start];
    }

}

#pragma mark - 网络请求协议
- (void)requestFinished:(YTKBaseRequest *)request
{
    [super requestFinished:request];
    
    NSDictionary *dic = request.responseJSONObject;
    
    if (NetParse.error(dic) == 0)
    {
        [SVProgressHUD showWithToast:@"密码修改成功" superView:self.view];
       
        // 清空本地用户信息
        [MGUserDefaultUtil removeUserDefaultInfo];
        
        // 清空本地数据库
        [MGSimMenuDBManager dropTableFromDB];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ToastDisTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate handleRootVC];
        });
        
    }
    else
    {
        [SVProgressHUD showWithToast:NetParse.reason(dic) superView:self.view];
    }
}

- (void)requestFailed:(YTKBaseRequest *)request
{
    [super requestFailed:request];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
// 返回row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGMineAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
    
    NSArray *tfPlaceholder = @[@"输入当前密码",@"新密码",@"确认新密码"];
    
    cell.inputTf.placeholder = tfPlaceholder[indexPath.row];
    
    weakSelf(self);
    cell.inputBlock = ^(NSString *inputStr){
    
        if (indexPath.row == 0)
        {
            weakSelf.oldPWStr = inputStr;
        }
        else if (indexPath.row == 1)
        {
            weakSelf.mNewPWStr = inputStr;
        }
        else if (indexPath.row == 2)
        {
            weakSelf.againNewPWStr = inputStr;
        }
    
    };
    
    return cell;
}

// 返回组的头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return AdaptH(8);
}

// 返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptH(51);
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



