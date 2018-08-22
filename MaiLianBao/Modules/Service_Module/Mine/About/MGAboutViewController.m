//
//  MGAboutViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/21.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGAboutViewController.h"
#import "MGAboutModel.h"
#import "MGWebViewController.h"
#import "MGMineTableHeadView.h"

@interface MGAboutViewController ()

// 关于界面，的数据model
@property(nonatomic,strong)MGAboutModel *aboutModel;

@end

@implementation MGAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.navigationItem.title = @"关于";
    
    [self configUI];
}

- (void)configUI{

    // 中间视图
    MGMineTableHeadView *headView = [[MGMineTableHeadView alloc] initWithFrame:CGRectMake(0,kScreenH/2.0-AdaptH(180),kScreenW,AdaptH(180)) bgImg:nil logoImg:self.aboutModel.topImg middleTitle:self.aboutModel.versionStr itemArray:nil contentArray:nil];
    
    headView.backgroundColor = [UIColor clearColor];
    headView.midTitle.textColor = UIColorFromRGB(0x666666);
    headView.midTitle.font = [UIFont boldSystemFontOfSize:AdaptFont(16)];
    [self.view addSubview:headView];
    
    // 用户协议btn
    UIButton *agreeMentBtn = [[UIButton alloc] init];
    agreeMentBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(15)];
    [agreeMentBtn setAttributedTitle:self.aboutModel.agreementStr forState:UIControlStateNormal];
    [agreeMentBtn addTarget:self action:@selector(agreementAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeMentBtn];
    [agreeMentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).mas_offset(AdaptH(200));
        make.size.mas_equalTo(CGSizeMake(AdaptW(200),AdaptH(30)));
    }];
 

    // 著作权lab
    UILabel *copyRightLab = [[UILabel alloc] init];
    copyRightLab.text = self.aboutModel.workRightStr;
    copyRightLab.textColor = UIColorFromRGB(0x666666);
    copyRightLab.numberOfLines = 0;
    copyRightLab.textAlignment = NSTextAlignmentCenter;
    copyRightLab.font = [UIFont systemFontOfSize:AdaptFont(16)];
    [self.view addSubview:copyRightLab];
    [copyRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(agreeMentBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(AdaptW(200),AdaptH(70)));
    }];
}

- (void)agreementAction{

    MGWebViewController *userAgreeMentVC = [[MGWebViewController alloc] initWihtURL:URL_UserAgreeMent];
    userAgreeMentVC.title = @"用户使用许可协议";
    [self.navigationController pushViewController:userAgreeMentVC animated:YES];
}

// 将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (MGAboutModel *)aboutModel
{
    if (_aboutModel == nil)
    {

       NSAttributedString *mStr = [NSString underLineWithStr:@"<用户使用许可>" textColor:UIColorFromRGB(0x333333) textFont:[UIFont systemFontOfSize:16]];
        
        _aboutModel = [[MGAboutModel alloc] init];
        _aboutModel.topImg = @"logo";
        _aboutModel.versionStr = [NSString stringWithFormat:@"%@%@",@"v",AppVersion];
        _aboutModel.dataList = [NSMutableArray arrayWithObjects:@"新版特性",@"功能介绍",nil];
        _aboutModel.agreementStr = mStr;
        _aboutModel.workRightStr = @"Copyright2010-2016.\nAll Rights Reserved.";
        
    }

    return _aboutModel;
}

// 导航栏左侧返回按钮响应
- (void)back
{
    [super back];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
