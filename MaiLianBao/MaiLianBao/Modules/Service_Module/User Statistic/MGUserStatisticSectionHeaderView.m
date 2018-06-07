//
//  MGUserStatisticSectionHeaderView.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/3.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGUserStatisticSectionHeaderView.h"
#import "UIView+BSLine.h"

@interface MGUserStatisticSectionHeaderView ()
@property (nonatomic, strong) UILabel * titleLabel1;
@property (nonatomic, strong) UILabel * titleLabel2;
@property (nonatomic, strong) UILabel * titleLabel3;
@end
@implementation MGUserStatisticSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self addTopLineWithLeftPading:0 andRightPading:0];
        [self addBottomLineWithLeftPading:0 andRightPading:0];
    
        [self addAllSubviews];
        
        self.titleLabel1.text = titles[0];
        self.titleLabel2.text = titles[1];
        self.titleLabel3.text = titles[2];

    }
    
    return self;
}

- (void)addAllSubviews
{
    [self addSubview:self.titleLabel1];
    [self addSubview:self.titleLabel2];
    [self addSubview:self.titleLabel3];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat xoffSet = AdaptW(15);
    CGFloat textWidth = self.width - xoffSet * 2 - AdaptW(10) * 2 - self.height;
    
    
    self.titleLabel1.frame = CGRectMake(xoffSet + self.height, 0, textWidth * 0.5, self.height);
    
    self.titleLabel2.frame = CGRectMake(self.titleLabel1.right + AdaptW(10.f), 0, textWidth * 0.25, self.height);
    
    self.titleLabel3.frame = CGRectMake(self.titleLabel2.right + AdaptW(10.f), 0, textWidth * 0.25, self.height);
}

- (UILabel *)titleLabel1
{
    if (!_titleLabel1)
    {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.font = [UIFont boldSystemFontOfSize:AdaptFont(14.f)];
        _titleLabel1.textColor = UIColorFromRGB(0x333333);
        _titleLabel1.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel1;
}

- (UILabel *)titleLabel2
{
    if (!_titleLabel2)
    {
        _titleLabel2 = [[UILabel alloc] init];
        _titleLabel2.font = [UIFont boldSystemFontOfSize:AdaptFont(14.f)];
        _titleLabel2.textColor = UIColorFromRGB(0x333333);
        _titleLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel2;
}

- (UILabel *)titleLabel3
{
    if (!_titleLabel3)
    {
        _titleLabel3 = [[UILabel alloc] init];
        _titleLabel3.font = [UIFont boldSystemFontOfSize:AdaptFont(14.f)];
        _titleLabel3.textColor = UIColorFromRGB(0x333333);
        _titleLabel3.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel3;
}
@end
