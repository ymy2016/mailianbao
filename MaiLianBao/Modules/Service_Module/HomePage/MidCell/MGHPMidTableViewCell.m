//
//  MGHPMidTableViewCell.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGHPMidTableViewCell.h"
#import "MGWebView.h"

#define RefreshMidCellNotice @"RefreshMidCellNotice"

@interface MGHPMidTableViewCell ()

// 网页控件
@property(nonatomic,strong)MGWebView *mgWebView;

@end

@implementation MGHPMidTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 创建上方View
        [self createTopView];
        
        [self addSubview:self.mgWebView];
        [self.mgWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(AdaptH(45));
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(AdaptH(5));
        }];
        
        // 接受刷新h5页面通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWeb) name:RefreshMidCellNotice object:nil];
    }

    return self;
}

- (MGWebView *)mgWebView
{
    if (_mgWebView == nil)
    {
        NSString *url = URL_HPMidWeb(HoldId,Token);
        _mgWebView = [[MGWebView alloc] initWithFrame:CGRectZero urlStr:url];
        _mgWebView.scrollView.scrollEnabled = NO;
    }

    return _mgWebView;
}

- (void)refreshWeb
{
     NSString *url = URL_HPMidWeb(HoldId,Token);
    [_mgWebView loadUrlStr:url];
}

- (void )createTopView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenW,AdaptH(40)));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = @"最近续费趋势";
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.font = [UIFont systemFontOfSize:AdaptFont(14)];
    [bgView addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView).mas_offset(AdaptW(20));
        make.height.mas_equalTo(AdaptH(30));
    }];

    UIButton *checkBtn = [[UIButton alloc] init];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(13)];
    [checkBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    checkBtn.titleEdgeInsets = UIEdgeInsetsMake(0, AdaptW(-25), 0, 0);
    checkBtn.imageEdgeInsets = UIEdgeInsetsMake(0, AdaptW(27), 0, 0);
    [checkBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn setTitle:@"更多" forState:UIControlStateNormal];
    
//  [checkBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//  checkBtn.layer.cornerRadius = AdaptW(5);
//  checkBtn.layer.masksToBounds = YES;
//  checkBtn.layer.borderColor = [UIColor orangeColor].CGColor;
//  checkBtn.layer.borderWidth = 0.7;
    
    [bgView addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).mas_offset(-AdaptW(20));
        make.centerY.equalTo(bgView);
//        make.size.mas_equalTo(CGSizeMake(AdaptW(50),AdaptH(25)));
    }];
    
}

- (void)checkAction
{
    if ([_delegate respondsToSelector:@selector(handleCheckRecentRebate)])
    {
        [_delegate handleCheckRecentRebate];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

@end
