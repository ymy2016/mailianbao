//
//  MGFlowPayTableViewCell.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/24.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGFlowPayTableViewCell.h"
#import "UIView+BSLine.h"
#import "MGFlowInfoModel.h"

@interface MGFlowPayTableViewCell ()
{
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_codeLabel;
    UILabel *_priceLabel;
}
@end
@implementation MGFlowPayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addBottomLineWithLeftPading:0 andRightPading:0];
        
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        
        _codeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_codeLabel];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLabel];
        
        _nameLabel.font = [UIFont boldSystemFontOfSize:AdaptFont(15.f)];
        _timeLabel.font = [UIFont systemFontOfSize:AdaptFont(13.f)];
        _codeLabel.font = [UIFont systemFontOfSize:AdaptFont(13.f)];
        _priceLabel.font = [UIFont boldSystemFontOfSize:AdaptFont(20.f)];
        
        _nameLabel.textColor = UIColorFromRGB(0x666666);
        _timeLabel.textColor = UIColorFromRGB(0x666666);
        _codeLabel.textColor = UIColorFromRGB(0x999999);
        _priceLabel.textColor = UIColorFromRGB(0xfd8023);
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(AdaptW(15));
            make.top.lessThanOrEqualTo(self.contentView).offset(AdaptH(15));
            make.right.equalTo(_priceLabel.mas_left).offset(AdaptW(-10));
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.lessThanOrEqualTo(_nameLabel.mas_bottom).offset(AdaptH(5));
            make.right.mas_equalTo(_nameLabel);
        }];
        
        [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_timeLabel.mas_left);
            make.top.lessThanOrEqualTo(_timeLabel.mas_bottom).offset(AdaptH(5));
            make.right.mas_equalTo(_timeLabel);
            make.bottom.lessThanOrEqualTo(self.contentView).offset(AdaptH(-5));
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(AdaptW(-15));
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setRenewalsOrderModel:(MGRenewalsOrder *)renewalsOrderModel
{
    _renewalsOrderModel = renewalsOrderModel;
    
    _nameLabel.text = _renewalsOrderModel.PackageName;
    
    _timeLabel.text = _renewalsOrderModel.CreateTime;
    
    _codeLabel.text = _renewalsOrderModel.wxOrderNo;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@",Formart.money(_renewalsOrderModel.Amount)];
    
}

- (void)setYdSimBillModel:(MGYDSimBill *)ydSimBillModel
{
    _ydSimBillModel = ydSimBillModel;
    
    _nameLabel.text = [NSString stringWithFormat:@"%@%@",_ydSimBillModel.billTime,_ydSimBillModel.operation];
    _codeLabel.text = [NSString stringWithFormat:@"时间:%@",_ydSimBillModel.createTime];
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",_ydSimBillModel.cost];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
