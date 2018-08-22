//
//  MGFlowCardTableViewCell.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/21.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGFlowCardTableViewCell.h"
#import "UIView+BSLine.h"
#import "MGFlowCardModel.h"
#import "UILabel+Category.h"

#define StateRedColor UIColorFromRGB(0xff727f)
#define StateGreenColor UIColorFromRGB(0x19C06b)
#define StateOrangeColor UIColorFromRGB(0xfe8d2e)

@interface MGFlowCardTableViewCell ()
{
    UILabel *_codeLabel;
    UILabel *_stateLabel;
    UILabel *_nameLabel;
    UILabel *_dayLabel;
    UILabel *_surplusLabel;
}
@end

@implementation MGFlowCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _codeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_codeLabel];
        
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.layer.cornerRadius = 4;
        _stateLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_stateLabel];
        
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        
        _dayLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_dayLabel];
        
        _surplusLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_surplusLabel];
        
        _codeLabel.font = [UIFont boldSystemFontOfSize:AdaptFont(18.f)];
        _stateLabel.font = [UIFont systemFontOfSize:AdaptFont(12.f)];
        _nameLabel.font = [UIFont systemFontOfSize:AdaptFont(13.f)];
        _dayLabel.font = [UIFont systemFontOfSize:AdaptFont(13.f)];
        _surplusLabel.font = [UIFont systemFontOfSize:AdaptFont(13.f)];
        
        _stateLabel.textColor = [UIColor whiteColor];
        _nameLabel.textColor = UIColorFromRGB(0x666666);
        _dayLabel.textColor = UIColorFromRGB(0x666666);
        _surplusLabel.textColor = UIColorFromRGB(0x666666);
        
        [_codeLabel sizeToFit];
        [_nameLabel sizeToFit];
        [_dayLabel sizeToFit];
        [_surplusLabel sizeToFit];
        
//        _codeLabel.backgroundColor = [UIColor grayColor];
//        _stateLabel.backgroundColor = [UIColor blueColor];
//        _nameLabel.backgroundColor = [UIColor orangeColor];
//        _dayLabel.backgroundColor = [UIColor redColor];
//        _surplusLabel.backgroundColor = [UIColor greenColor];
        
        [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(AdaptW(15));
            make.top.mas_equalTo(AdaptH(12));
            make.height.mas_equalTo(AdaptW(20));
        }];
        
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_codeLabel.mas_right).with.offset(AdaptW(10));
            make.top.equalTo(_codeLabel.mas_top);
            make.height.mas_equalTo(_codeLabel.mas_height);
            make.width.mas_equalTo(AdaptW(45));
            make.right.lessThanOrEqualTo(self.contentView).offset(AdaptW(-15));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_codeLabel.mas_left);
            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(AdaptH(-12));
        }];
        
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).with.offset(AdaptW(10));
            make.top.equalTo(_nameLabel.mas_top);
            make.right.equalTo(_surplusLabel.mas_left).with.offset(-10);
        }];

        [_surplusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.contentView).offset(AdaptW(-15));
            make.top.equalTo(_nameLabel.mas_top);
        }];
        
    }
    return self;
}

- (void)setModel:(MGListInfo *)model
{
    _model = model;
    
    _nameLabel.text = _model.packageName;
    
    if (_model.simFromType == SimCardForCMCC)
    {
        // 移动
        _codeLabel.text = _model.sim;
        if (model.apiCode == 1 || model.apiCode == 3)
        {
            // 逻辑1 逻辑3
            _dayLabel.text = [NSString stringWithFormat:@"余额:%@",Formart.money(_model.balance)];
        }
        else if (model.apiCode == 2)
        {
            _dayLabel.text = [NSString stringWithFormat:@"距到期%@",_model.oddTime];
        }
        else
        {
            
        }
    }
    else if (_model.simFromType == SimCardForCUCC)
    {
        // 联通
        _codeLabel.text = _model.iccid;
        
        _dayLabel.text = [NSString stringWithFormat:@"距到期%@",_model.oddTime];
        
    }
    else
    {
    
    }
    
    _surplusLabel.text = [NSString stringWithFormat:@"剩余:%0.2fM",_model.flowLeftValue];
    [_surplusLabel setFontColor:UIColorFromRGB(0xfe8d2e) string:[NSString stringWithFormat:@"%0.2f",_model.flowLeftValue]];
    
    
    if (_model.simState == SimCardStateUnActivation)
    {
        _stateLabel.text = @"未激活";
        _stateLabel.backgroundColor = StateOrangeColor;
    }
    else if (_model.simState == SimCardStateNormal)
    {
        _stateLabel.text = @"正常";
        _stateLabel.backgroundColor = StateGreenColor;
    }
    else if (_model.simState == SimCardStateStop)
    {
        _stateLabel.text = @"停机";
        _stateLabel.backgroundColor = StateRedColor;
    }
    else
    {
    
    }
    
    
}

@end
