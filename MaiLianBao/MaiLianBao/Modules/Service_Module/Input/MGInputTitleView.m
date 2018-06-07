//
//  MGInputTitleView.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGInputTitleView.h"

@implementation MGInputTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = UIColorFromRGB(0xF3F3F3);
        
        UILabel *numberLabel = [UILabel new];
        numberLabel.text = @"序号";
        numberLabel.textColor = [UIColor blackColor];
        numberLabel.font = [UIFont systemFontOfSize:AdaptFont(12.f)];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numberLabel];
        
        UILabel *imeiLabel = [UILabel new];
        imeiLabel.text = @"IMEI";
        imeiLabel.textColor = [UIColor blackColor];
        imeiLabel.font = [UIFont systemFontOfSize:AdaptFont(12.f)];
        imeiLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:imeiLabel];
        
        UILabel *iccidLabel = [UILabel new];
        iccidLabel.text = @"ICCID";
        iccidLabel.textColor = [UIColor blackColor];
        iccidLabel.font = [UIFont systemFontOfSize:AdaptFont(12.f)];
        iccidLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:iccidLabel];
        
        UILabel *stateLabel = [UILabel new];
        stateLabel.text = @"入库";
        stateLabel.textColor = [UIColor blackColor];
        stateLabel.font = [UIFont systemFontOfSize:AdaptFont(12.f)];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:stateLabel];
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self);
            make.width.equalTo(self.mas_width).multipliedBy(0.11);
        }];
        
        [imeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(numberLabel.mas_right);
            make.centerY.equalTo(self);
            make.width.equalTo(self.mas_width).multipliedBy(0.32);
        }];
        
        [iccidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imeiLabel.mas_right).offset(AdaptW(0.5));
            make.centerY.equalTo(self);
            make.width.equalTo(self.mas_width).multipliedBy(0.45);
        }];
        
        [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iccidLabel.mas_right).offset(AdaptW(0.5));
            make.centerY.equalTo(self);
            make.right.equalTo(self);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(numberLabel.mas_right);
            make.centerY.equalTo(self);
            make.width.equalTo(@(AdaptW(0.5)));
            make.height.equalTo(self.mas_height);
        }];
        
        UIView *line1 = [UIView new];
        line1.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imeiLabel.mas_right);
            make.centerY.equalTo(self);
            make.width.equalTo(@(AdaptW(0.5)));
            make.height.equalTo(self.mas_height);
        }];
        
        UIView *line2 = [UIView new];
        line2.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iccidLabel.mas_right);
            make.centerY.equalTo(self);
            make.width.equalTo(@(AdaptW(0.5)));
            make.height.equalTo(self.mas_height);
        }];
    }
    return self;
}

@end
