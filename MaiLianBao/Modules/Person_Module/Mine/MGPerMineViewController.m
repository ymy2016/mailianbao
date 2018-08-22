//
//  MGPerMineViewController.m
//  MaiLianBao
//
//  Created by 伟华 on 17/1/4.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerMineViewController.h"
#import "MGPerMineHeaderView.h"
#import "MGWebViewController.h"
#import "MGAboutViewController.h"
#import "MGPerModifyAccountViewController.h"
#import "MGUserDefaultUtil.h"
#import "UIImageView+WebCache.h"

@interface MGPerMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataList;

@property(nonatomic,strong)MGPerMineHeaderView *headView;

@end

static NSString *identy = @"cell";

@implementation MGPerMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
       iOS7+：
       1、Tabbar、导航、ViewController三级关系的情况下，不忽略下方Tabbar的高度
       2、UIRectEdgeNone,忽略上、下、左、右默认的占位。会导致导航栏变为不透明的
       3、开发中，影响的是三级容器关系下，ViewController的self.view.frame中的(0,y)的y的位置
    */
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self configUI];
}

- (void)configUI{
    
    weakSelf(self);
    
    // 头部视图
    MGPerMineHeaderView *headView = [[MGPerMineHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenW,AdaptH(269)) centerImg:nil nickName:nil];
    self.headView = headView;
    
    // 头部视图昵称、姓名赋值
    MGPerUserModel *model =  [MGUserDefaultUtil getPerUserInfo];
    [headView.centerImgv sd_setImageWithURL:[NSURL URLWithString:model.IconImage] placeholderImage:[UIImage imageNamed:@"mlb_logo"]];
    headView.nickLab.text = model.WxNickName;
    
    // 点击头部视图block
    headView.clickBlock = ^(){
        MGPerModifyAccountViewController *modifyAccountVC = [[MGPerModifyAccountViewController alloc] init];
        modifyAccountVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:modifyAccountVC animated:YES];

    };
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headView;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identy];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataList{
    
    if (_dataList == nil) {
        
        _dataList = [NSMutableArray arrayWithObjects:@"流量卡常见问题",@"关于应用",nil];
    }
    
    return _dataList;
}

// 将要显示
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    // 从本地读取头像、昵称
    MGPerUserModel *model =  [MGUserDefaultUtil getPerUserInfo];
    [self.headView.centerImgv sd_setImageWithURL:[NSURL URLWithString:model.IconImage] placeholderImage:[UIImage imageNamed:@"mlb_logo"]];
    self.headView.nickLab.text = model.WxNickName;
}

// 将要消失
- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
// 返回row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    // cell相关配置
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:AdaptFont(15)];
    return cell;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 获取数据的标题
    NSString *title = self.dataList[indexPath.row];

    if ([title isEqualToString:@"流量卡常见问题"])
    {
        MGWebViewController *flowCardQuestionVC = [[MGWebViewController alloc] initWihtURL:URL_FlowCardQuestion title:@"流量卡常见问题"];
        [self.navigationController pushViewController:flowCardQuestionVC animated:YES];
        self.navigationController.navigationBarHidden = NO;
    }
    else if ([title isEqualToString:@"关于应用"])
    {
        MGAboutViewController *aboutVC = [[MGAboutViewController alloc] init];
        aboutVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutVC animated:YES];
        self.navigationController.navigationBarHidden = NO;
    }
}

// 头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return AdaptH(15);
}

// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptH(51);
}

@end
