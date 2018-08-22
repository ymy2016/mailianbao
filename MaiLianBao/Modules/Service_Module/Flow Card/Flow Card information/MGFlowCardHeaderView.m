//
//  MGFlowCardHeaderView.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGFlowCardHeaderView.h"
#import "UILabel+Category.h"
#import "MGFlowInfoModel.h"

#define StateRedColor UIColorFromRGB(0xff727f)
#define StateGreenColor UIColorFromRGB(0x19C06b)
#define StateOrangeColor UIColorFromRGB(0xfe8d2e)

@implementation MGFlowCardHeaderView
{
    UILabel *_stateLabel;   // 状态
    UILabel *_codeLabel;    // 号码
    UILabel *_packageLabel; // 套餐包
    UILabel *_flowLabel;    // 剩余流量
    UILabel *_serviceLabel; // 服务
    UILabel *_diagnosisLabel; // 诊断结果
    
    SimCardType _type;
}

- (instancetype)initWithCardType:(SimCardType)type
{
    _type = type;
    
    if (_type == SimCardForCMCC)
    {
        self = [self initWithFrame:CGRectMake(0, 0, kScreenW, AdaptH(160))];
    }
    else
    {
        self = [self initWithFrame:CGRectMake(0, 0, kScreenW, AdaptH(240))];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
#pragma mark - 卡片 UI
        // 卡片背景
        UIImage * cardBackgroundImage = [UIImage imageNamed:@"fc_info_background"];
        UIImageView * cardBackgroundView = [[UIImageView alloc] initWithImage:cardBackgroundImage];
        cardBackgroundView.userInteractionEnabled = YES;
        [self addSubview:cardBackgroundView];
        
        // 流量卡状态
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.layer.cornerRadius = 4;
        _stateLabel.layer.masksToBounds = YES;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [cardBackgroundView addSubview:_stateLabel];
        // 号码
        _codeLabel = [[UILabel alloc] init];
        [cardBackgroundView addSubview:_codeLabel];
        // 套餐包
        _packageLabel = [[UILabel alloc] init];
        [cardBackgroundView addSubview:_packageLabel];
        // 剩余流量
        _flowLabel = [[UILabel alloc] init];
        [cardBackgroundView addSubview:_flowLabel];
        // 服务
        _serviceLabel = [[UILabel alloc] init];
        [cardBackgroundView addSubview:_serviceLabel];
        
        _stateLabel.font = [UIFont systemFontOfSize:AdaptFont(12.f)];
        _codeLabel.font = [UIFont boldSystemFontOfSize:AdaptFont(18.f)];
        _packageLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
        _flowLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
        _serviceLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
        
        _stateLabel.textColor = [UIColor whiteColor];
        _codeLabel.textColor = UIColorFromRGB(0x333333);
        _packageLabel.textColor = UIColorFromRGB(0x333333);
        _flowLabel.textColor = UIColorFromRGB(0x666666);
        _serviceLabel.textColor = UIColorFromRGB(0x666666);
        
        [cardBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(AdaptW(10));
            make.width.mas_equalTo(AdaptW(cardBackgroundView.image.size.width));
            make.height.mas_equalTo(AdaptH(cardBackgroundView.image.size.height));
        }];
        
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(AdaptW(45));
            make.height.mas_equalTo(AdaptH(20));
            make.left.equalTo(cardBackgroundView).offset(AdaptW(10));
            make.top.equalTo(cardBackgroundView).offset(AdaptH(10));
        }];
        
        [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_stateLabel.mas_right).offset(AdaptW(8));
            make.right.equalTo(cardBackgroundView).offset(AdaptW(-8));
            make.top.equalTo(cardBackgroundView).offset(AdaptH(1));
            make.height.mas_equalTo(AdaptH(40));
        }];
        
        [_packageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(AdaptW(cardBackgroundView.width - 40));
            make.centerX.equalTo(cardBackgroundView);
            make.top.lessThanOrEqualTo(_codeLabel.mas_bottom).offset(AdaptH(13));
        }];
        
        [_flowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_packageLabel.mas_width);
            make.centerX.equalTo(cardBackgroundView);
            make.top.lessThanOrEqualTo(_packageLabel.mas_bottom).offset(AdaptH(10));
        }];
        
        [_serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_flowLabel.mas_width);
            make.centerX.equalTo(cardBackgroundView);
            make.top.lessThanOrEqualTo(_flowLabel.mas_bottom).offset(AdaptH(10));
            make.bottom.lessThanOrEqualTo(cardBackgroundView).offset(AdaptH(-13));
        }];
                
#pragma mark - 文字描述 UI
        
        if (_type == SimCardForCUCC)
        {
            // 文字描述背景
            UIView * textBackgroundView = [[UIView alloc] init];
            textBackgroundView.backgroundColor = UIColorFromRGB(0xfff3e9);
            textBackgroundView.layer.masksToBounds = YES;
            textBackgroundView.layer.cornerRadius = 5;
            textBackgroundView.layer.borderWidth = 1;
            textBackgroundView.layer.borderColor = UIColorFromRGB(0xfe8d2e).CGColor;
            textBackgroundView.userInteractionEnabled = YES;
            [self addSubview:textBackgroundView];
            
            _diagnosisLabel = [[UILabel alloc] init];
            _diagnosisLabel.textColor = UIColorFromRGB(0xfe8d2e);
            _diagnosisLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
            //        _diagnosisLabel.text = @"诊断结果:流量卡还没使用,如果无法连接网络,建议重新设置APN后重新启动,如果仍无法连接请使用公众号联系客服";
            _diagnosisLabel.numberOfLines = 3;
            _diagnosisLabel.textAlignment = NSTextAlignmentLeft;
            [textBackgroundView addSubview:_diagnosisLabel];
            
            [textBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cardBackgroundView).offset(3);
                make.top.equalTo(cardBackgroundView.mas_bottom).offset(AdaptH(8));
                make.width.mas_equalTo(AdaptW(cardBackgroundView.width) - AdaptW(6));
                make.bottom.equalTo(self).offset(AdaptH(-10));
            }];
            
            [_diagnosisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(textBackgroundView);
                make.edges.mas_offset(UIEdgeInsetsMake(5, 8, 5, 8));
            }];
        }
    }
    return self;
}

- (void)setInfoModel:(MGFlowInfoModel *)infoModel
{
    _infoModel = infoModel;

    _stateLabel.text = _infoModel.simStateSrc;
    if (_infoModel.simState == SimCardStateUnActivation)
    {
        _stateLabel.backgroundColor = StateOrangeColor;
        _diagnosisLabel.text = @"诊断结果：流量卡还未激活，请在公众号号进行激活";
    }
    else if (_infoModel.simState == SimCardStateNormal)
    {
        _stateLabel.backgroundColor = StateGreenColor;
        _diagnosisLabel.text = @"诊断结果：流量卡状态正常，如无法连接网络，建议重新设置APN后重新启动，如仍无法连接请公众号联系客服";
    }
    else if (_infoModel.simState == SimCardStateStop)
    {
        _stateLabel.backgroundColor = StateRedColor;
        _diagnosisLabel.text = @"诊断结果：流量卡已停机，建议充值续费";
    }
    else
    {
    
    }

    [_diagnosisLabel setFont:[UIFont boldSystemFontOfSize:AdaptFont(16.f)] string:@"诊断结果:"];

    if (_infoModel.simFromType == SimCardForCMCC)
    {
        // 移动
        _codeLabel.text = _infoModel.sim;
        
        if (_infoModel.apiCode == 1 || _infoModel.apiCode == 3 || _infoModel.apiCode == 0)
        {
            _serviceLabel.text = [NSString stringWithFormat:@"余额:%@",Formart.money(_infoModel.balance)];
        }
        else if (_infoModel.apiCode == 2)
        {
            NSString *startTime = [NSString stringWithFormat:@"(到期时间%@)",_infoModel.expireTime];
            if ([ _infoModel.expireTime isEqualToString:@""]) {
                startTime = _infoModel.expireTime;
            }
            _serviceLabel.text = [NSString stringWithFormat:@"剩余服务%@天%@",_infoModel.surplusPeriod,startTime];
        }
        else
        {
        
        }
        
    }
    else if (_infoModel.simFromType == SimCardForCUCC)
    {
        // 联通
        _codeLabel.text = _infoModel.iccid;
        
        NSString *startTime = [NSString stringWithFormat:@"(到期时间%@)",_infoModel.expireTime];
        if ([ _infoModel.expireTime isEqualToString:@""]) {
            startTime = _infoModel.expireTime;
        }
        _serviceLabel.text = [NSString stringWithFormat:@"剩余服务%@天%@",_infoModel.surplusPeriod,startTime];
    }
    else
    {
        
    }
    
    CGFloat totalFlow = _infoModel.surplusUsage + _infoModel.doneUsage;
    _packageLabel.text = [NSString stringWithFormat:@"%@ 总流量%@MB",_infoModel.packageName,@(totalFlow)];
    
    _flowLabel.text = [NSString stringWithFormat:@"剩余流量%0.2fMB / 已用流量%0.2fMB",_infoModel.surplusUsage,_infoModel.doneUsage];
    [_flowLabel setFontColor:UIColorFromRGB(0xfe8d2e) string:[NSString stringWithFormat:@"%0.2f",_infoModel.surplusUsage]];
}

@end
