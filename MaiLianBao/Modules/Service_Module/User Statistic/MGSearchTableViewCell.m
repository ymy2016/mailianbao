//
//  MGSearchTableViewCell.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/5.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGSearchTableViewCell.h"
#import "UIView+BSLine.h"
#import "MGLeftMenuModel.h"

@interface MGSearchTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rebateLabel;
@property (nonatomic, strong) UILabel *renewLabel;
@end

@implementation MGSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self allAddSubviews];
    }
    return self;
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
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat xoffSet = 15.f;
    CGFloat width = self.width - xoffSet * 2 - 10 * 2;
    
    self.nameLabel.frame = CGRectMake(xoffSet, 0, width * 0.4, self.height);
    
    self.rebateLabel.frame = CGRectMake(self.nameLabel.right + 10, 0, width * 0.3, self.height);
    
    self.renewLabel.frame = CGRectMake(self.rebateLabel.right + 10, 0, width * 0.3, self.height);
}

- (void)allAddSubviews
{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.rebateLabel];
    [self.contentView addSubview:self.renewLabel];
    
    [self.contentView addBottomLineWithLeftPading:0 andRightPading:0];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
