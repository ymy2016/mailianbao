//
//  MGUserStatisticTableViewCell.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/25.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGUserStatisticTableViewCell.h"
#import "UIView+BSLine.h"
#import "MGLeftMenuModel.h"

#define TextGap AdaptW(10)

@interface MGUserStatisticTableViewCell ()
@property (nonatomic, strong) UIButton *nodeButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rebateLabel;
@property (nonatomic, strong) UILabel *renewLabel;
@end
@implementation MGUserStatisticTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addAllSubviews];
        [self.contentView addBottomLineWithLeftPading:0 andRightPading:0];
    }
    return self;
}

- (void)addAllSubviews
{
    [self.contentView addSubview:self.nodeButton];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.rebateLabel];
    [self.contentView addSubview:self.renewLabel];
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
}

- (void)setModel:(MGLeftMenuModel *)model
{
    _model = model;
    
    self.nameLabel.text = _model.name;
    
    if (_dataType == ThisMonthData)
    {
        self.rebateLabel.text = [NSString stringWithFormat:@"￥%0.f",_model.monthBackAmount];
        self.renewLabel.text = [NSString stringWithFormat:@"￥%0.f",_model.monthRenewalsAmount];
    }
    else if (_dataType == LastMonthData)
    {
        self.rebateLabel.text = [NSString stringWithFormat:@"￥%0.f",_model.lastMonthBackAmount];
        self.renewLabel.text = [NSString stringWithFormat:@"￥%0.f",_model.lastMonthRenewalsAmount];
    }
    else if (_dataType == AllMonthData)
    {
        self.rebateLabel.text = [NSString stringWithFormat:@"￥%0.f",_model.totalBackAmount];
        self.renewLabel.text = [NSString stringWithFormat:@"￥%0.f",_model.totalRenewalsAmount];
    }
    
    
    MGLeftMenuModel *firstModel = [_dataArray firstObject];
    
    _nodeButton.selected = _model.isExpansion;
    
    for (int i = 0; i < _dataArray.count; i++)
    {
        MGLeftMenuModel *aModel = _dataArray[i];
        
        if (aModel.parentId != _model.mId)
        {
            if (i == _dataArray.count - 1)
            {
                [_nodeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"us_node_button_nothing_%@",@(_model.nodeLevel - firstModel.nodeLevel)]] forState:UIControlStateNormal];
                _nodeButton.userInteractionEnabled = NO;
                break;
            }
            continue;
        }
        else
        {
            [_nodeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"us_node_button_normal_%@",@(_model.nodeLevel - firstModel.nodeLevel)]] forState:UIControlStateNormal];
            [_nodeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"us_node_button_open_%@",@(_model.nodeLevel - firstModel.nodeLevel)]] forState:UIControlStateSelected];
            
            _nodeButton.userInteractionEnabled = YES;
            break;
        }
    }
}

- (void)nodeButtonAction:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (self.nodeButtonBlock)
    {
        self.nodeButtonBlock();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat xoffSet = AdaptW(15.f);
    CGFloat textWidth = self.contentView.width - xoffSet *2 - self.height - TextGap * 2;
    
    self.nodeButton.frame = CGRectMake(xoffSet, 0, self.height, self.height);
    
    self.nameLabel.frame = CGRectMake(self.nodeButton.right, 0, textWidth * 0.4, self.height);
    
    self.rebateLabel.frame = CGRectMake(self.nameLabel.right + TextGap, 0, textWidth * 0.3, self.height);
    
    self.renewLabel.frame = CGRectMake(self.rebateLabel.right + TextGap, 0, textWidth * 0.3, self.height);
}

- (UIButton *)nodeButton
{
    if (!_nodeButton)
    {
        _nodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_nodeButton setImage:[UIImage imageNamed:@"us_node_button_normal_0"] forState:UIControlStateNormal];
//        [_nodeButton setImage:[UIImage imageNamed:@"us_node_button_open_0"] forState:UIControlStateSelected];
        [_nodeButton addTarget:self action:@selector(nodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nodeButton;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
        _nameLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _nameLabel;
}

- (UILabel *)rebateLabel
{
    if (!_rebateLabel)
    {
        _rebateLabel = [[UILabel alloc] init];
        _rebateLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
        _rebateLabel.textColor = UIColorFromRGB(0xfb7c37);
        _rebateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rebateLabel;
}

- (UILabel *)renewLabel
{
    if (!_renewLabel)
    {
        _renewLabel = [[UILabel alloc] init];
        _renewLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
        _renewLabel.textColor = UIColorFromRGB(0xfb7c37);
        _renewLabel.textAlignment = NSTextAlignmentRight;
//        _renewLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _renewLabel;
}
@end
