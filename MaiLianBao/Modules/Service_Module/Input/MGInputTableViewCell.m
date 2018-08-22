//
//  MGInputTableViewCell.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGInputTableViewCell.h"
#import "MGRecordModel.h"
#import "UILabel+Category.h"

@interface MGInputTableViewCell ()
@property (nonatomic, strong) UILabel *imeiLabel;
@property (nonatomic, strong) UILabel *iccidLabel;
@property (nonatomic, strong) UIImageView *stateImageView;
@property (nonatomic, strong) UILabel *errorLabel;
@end

@implementation MGInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _numberLabel = [UILabel new];
        _numberLabel.textColor = [UIColor blackColor];
        _numberLabel.font = [UIFont systemFontOfSize:AdaptFont(12.f)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_numberLabel];
        
        _imeiLabel = [UILabel new];
        _imeiLabel.textColor = [UIColor blackColor];
        _imeiLabel.font = [UIFont systemFontOfSize:AdaptFont(10.f)];
        _imeiLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_imeiLabel];
        
        _iccidLabel = [UILabel new];
        _iccidLabel.textColor = [UIColor blackColor];
        _iccidLabel.font = [UIFont systemFontOfSize:AdaptFont(10.f)];
        _iccidLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_iccidLabel];
        
        _stateImageView = [UIImageView new];
        _stateImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_stateImageView];
        
        _errorLabel = [UILabel new];
        _errorLabel.backgroundColor = UIColorFromRGB(0xFC484C);
        _errorLabel.textColor = [UIColor whiteColor];
        _errorLabel.font = [UIFont boldSystemFontOfSize:AdaptFont(12.f)];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.hidden = YES;
        [self.contentView addSubview:_errorLabel];
        
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.11);
            make.height.equalTo(@(AdaptH(30)));
        }];
        
        [_imeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_numberLabel.mas_right);
            make.top.equalTo(self.contentView);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.32);
            make.height.equalTo(_numberLabel.mas_height);
        }];
        
        [_iccidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imeiLabel.mas_right).offset(AdaptW(0.5));
            make.top.equalTo(self.contentView);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.45);
            make.height.equalTo(_numberLabel.mas_height);
        }];
        
        [_stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iccidLabel.mas_right).offset(AdaptW(0.5));
            make.top.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(_numberLabel.mas_height);
        }];
        
        [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_stateImageView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@(AdaptH(20)));
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_numberLabel.mas_right);
            make.top.equalTo(self.contentView);
            make.width.equalTo(@(AdaptW(0.5)));
            make.height.equalTo(self.numberLabel.mas_height);
        }];
        
        UIView *line1 = [UIView new];
        line1.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [self.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imeiLabel.mas_right);
            make.top.equalTo(self.contentView);
            make.width.equalTo(@(AdaptW(0.5)));
            make.height.equalTo(self.numberLabel.mas_height);
        }];
        
        UIView *line2 = [UIView new];
        line2.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [self.contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iccidLabel.mas_right);
            make.top.equalTo(self.contentView);
            make.width.equalTo(@(AdaptW(0.5)));
            make.height.equalTo(self.numberLabel.mas_height);
        }];
    }
    return self;
}

- (void)setScanRecordModel:(MGScanRecordModel *)scanRecordModel
{
    _scanRecordModel = scanRecordModel;
    
    self.imeiLabel.text = [MGFormartUtil dealWithString:_scanRecordModel.imei length:5];
    self.iccidLabel.text = [MGFormartUtil dealWithString:_scanRecordModel.iccid length:5];
    
    [self.imeiLabel setFontColor:[UIColor orangeColor] range:[self rangeWithString:self.imeiLabel.text]];
    [self.imeiLabel setFont:[UIFont boldSystemFontOfSize:AdaptH(13.f)] range:[self rangeWithString:self.imeiLabel.text]];
    
    [self.iccidLabel setFontColor:[UIColor orangeColor] range:[self rangeWithString:self.iccidLabel.text]];
    [self.iccidLabel setFont:[UIFont boldSystemFontOfSize:AdaptH(13.f)] range:[self rangeWithString:self.iccidLabel.text]];
    
    if (_scanRecordModel.distributeState == 1)
    {
        [self.stateImageView setImage:[UIImage imageNamed:@"scan_icon_success"]];
        [self.errorLabel setHidden:YES];
    }
    else if (_scanRecordModel.distributeState == 2)
    {
        [self.stateImageView setImage:[UIImage imageNamed:@"scan_icon_fail"]];
        [self.errorLabel setHidden:NO];
        [self.errorLabel setText:_scanRecordModel.reason];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSRange)rangeWithString:(NSString *)string
{
    // 以空格拆分为数组
    NSArray *array = [string componentsSeparatedByString:@" "];
    // 取数组中最后个字符串
    NSString *lastString = [array lastObject];
    // 返回最后字符串的位置
    return NSMakeRange(string.length - lastString.length, lastString.length);
}

@end
