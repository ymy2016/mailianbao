//
//  MGFlowUseTableViewCell.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/24.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGFlowUseTableViewCell.h"
#import "UIView+BSLine.h"
#import "MGFlowInfoModel.h"

@interface MGFlowUseTableViewCell ()
{
    UILabel *_linkStartLabel;
    UILabel *_useLabel;
    UILabel *_timeLabel;
}
@end
@implementation MGFlowUseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _linkStartLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_linkStartLabel];
        
        _useLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_useLabel];
        
        _timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        
        _linkStartLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
        _useLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
        _timeLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
        
        _linkStartLabel.textAlignment = NSTextAlignmentCenter;
        _useLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        _linkStartLabel.textColor = UIColorFromRGB(0x333333);
        _useLabel.textColor = UIColorFromRGB(0x333333);
        _timeLabel.textColor = UIColorFromRGB(0x333333);
        
        [_linkStartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(AdaptW(15));
            make.width.mas_equalTo((kScreenW - AdaptW(40)) * 0.5);
            make.centerY.equalTo(self.contentView);
        }];
        
        [_useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_linkStartLabel.mas_right).offset(AdaptW(5));
            make.centerY.equalTo(self.contentView);
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_useLabel.mas_right).offset(AdaptW(5));
            make.right.equalTo(self.contentView).offset(AdaptW(-15));
            make.width.mas_equalTo((kScreenW - AdaptW(40)) * 0.3);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addBottomLineWithLeftPading:0 andRightPading:0];
        
//        _linkStartLabel.backgroundColor = [UIColor orangeColor];
//        _useLabel.backgroundColor = [UIColor redColor];
//        _timeLabel.backgroundColor = [UIColor greenColor];
        
        _linkStartLabel.text = @"连接开始";
        _useLabel.text = @"用量(KB)";
        _timeLabel.text = @"持续时间(分钟)";
    }
    return self;
}

- (void)setUnicomUsageModel:(MGUnicomUsage *)unicomUsageModel
{
    _unicomUsageModel = unicomUsageModel;
    
    _linkStartLabel.text = _unicomUsageModel.sessionTime;
    _useLabel.text = _unicomUsageModel.usage;
    _timeLabel.text = _unicomUsageModel.duration;
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
