//
//  MGHeaderView.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGHeaderView.h"
#import "UIView+BSLine.h"
#import "MGHPRebateModel.h"

#define CONTENTLABELTAG 1000

@interface MGHeaderView ()
{
    BOOL _isShow;
}
@property (nonatomic, weak) UIView *botView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *moreButton;
@property(nonatomic,strong) MGUserModel *userModel;

@end

@implementation MGHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.userModel = [MGUserDefaultUtil getUserInfo];
        
        // _isShow = ![MGUserDefaultUtil getCurrentUser].isLogicalUser;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerHandle:)];
        [self addGestureRecognizer:tap];
        
        [self addSubviews];
        
    }
    return self;
}

- (void)headerHandle:(id)sender
{
    if (self.userModel.isStateReport == 1) {
        if (self.HeaderBlock)
        {
            self.HeaderBlock();
        }
    }
}

- (void)setRebateModel:(MGHPRebateModel *)rebateModel
{
    _rebateModel = rebateModel;
    
    if ([MGUserDefaultUtil isLogicalUser])
    {
        // 逻辑用户隐藏更多按钮
        [self.moreButton setHidden:YES];
        [self setUserInteractionEnabled:NO];
    }
    else
    {
        [self.moreButton setHidden:NO];
        [self setUserInteractionEnabled:YES];
    }
    
    // 查看激活统计权限
    if (self.userModel.isStateReport == 0) {
        // 逻辑用户隐藏更多按钮
        [self.moreButton setHidden:YES];
        [self setUserInteractionEnabled:NO];
        
    }
    else{
        [self.moreButton setHidden:NO];
        [self setUserInteractionEnabled:YES];
    }
    
    self.titleLabel.text = _rebateModel.holdName;
    
    UILabel *flowLabel = [self viewWithTag:CONTENTLABELTAG];
    flowLabel.text = [MGFormartUtil countNumAndChangeformat:_rebateModel.simCount];
    
    UILabel *userLabel = [self viewWithTag:CONTENTLABELTAG + 1];
    userLabel.text = [MGFormartUtil countNumAndChangeformat:_rebateModel.activatedCount + _rebateModel.stopCount];
    
    UILabel *renewLabel = [self viewWithTag:CONTENTLABELTAG + 2];
    renewLabel.text = [MGFormartUtil countNumAndChangeformat:_rebateModel.renewalsActiveCount];
    
//    // 续费率
//    CGFloat n = (_rebateModel.renewalsActiveCount / (_rebateModel.activatedCount + _rebateModel.stopCount)) * 100;
//    NSLog(@"%f", n);
//
//    UILabel *renewRateLabel = [self viewWithTag:RATELABELTAG];
//    renewRateLabel.attributedText = [self richTextWithImageStr:@"data_icon_blue" title:@" 续费率" value:[NSString stringWithFormat:@" %.2f%%", n] valueColor:UIColorFromRGB(0x00A9E8)];
//
//    n = (_rebateModel.renewalsActiveCount / (_rebateModel.ltOutCount + _rebateModel.renewalsActiveCount)) * 100;
//    UILabel *effectiveLabel = [self viewWithTag:RATELABELTAG +1];
//    effectiveLabel.attributedText = [self richTextWithImageStr:@"data_icon_yellow" title:@" 有效续费率" value:[NSString stringWithFormat:@" %.2f%%", n] valueColor:UIColorFromRGB(0xFF970F)];
}

- (void)addSubviews
{
    UIView *topView = [UIView new];
    [self addSubview:topView];
    
    // Title
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = [MGUserDefaultUtil isLogicalUser] ? [MGUserDefaultUtil getUserInfo].holdName : [MGUserDefaultUtil getCurrentUser].name;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:AdaptFont(15.f)];
    [topView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // 更多按钮
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(13.f)];
    [moreButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, AdaptW(-25), 0, 0);
    moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, AdaptW(27), 0, 0);
    [moreButton addTarget:self action:@selector(headerHandle:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:moreButton];
    self.moreButton = moreButton;
    
    // 查看激活统计权限
    if (self.userModel.isStateReport == 0) {
        // 逻辑用户隐藏更多按钮
        [self.moreButton setHidden:YES];
        [self setUserInteractionEnabled:NO];
    }
    else{
        [self.moreButton setHidden:NO];
        [self setUserInteractionEnabled:YES];
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorFromRGB(0xcccccc);
    [topView addSubview:line];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(AdaptH(40)));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(AdaptW(20.f));
    }];
    
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(topView).offset(AdaptW(-20.f));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.bottom.equalTo(topView).offset(AdaptH(-0.5));
        make.height.equalTo(@(AdaptH(0.5)));
        make.width.equalTo(@(kScreenW - AdaptW(30)));
    }];
    
    UIView *midView = [UIView new];
    [self addSubview:midView];
    [midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(AdaptH(5.f));
        make.size.mas_equalTo(CGSizeMake(kScreenW, AdaptH(45)));
    }];
    
    CGFloat midWidth = (kScreenW - AdaptW(50))/3; // 左右间距20 label之间间距10
    for (NSInteger i = 0; i < 3; i++)
    {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @[@"流量卡", @"已使用", @"已续费"][i];
        titleLabel.font = [UIFont systemFontOfSize:AdaptFont(15.f)];
        titleLabel.textColor = UIColorFromRGB(0x6B6B6B);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [midView addSubview:titleLabel];
        
        UILabel *contentLabel = [UILabel new];
        contentLabel.tag = CONTENTLABELTAG +i;
        contentLabel.text = @[@"0", @"0", @"0"][i];
        contentLabel.font = [UIFont systemFontOfSize:AdaptFont(13.f)];
        // UIColorFromRGB(0x6B6B6B)
        contentLabel.textColor = UIColorFromRGB(0xffb30f);
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [midView addSubview:contentLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(midView);
            make.left.equalTo(midView).offset(AdaptW(20) + i *midWidth + i *AdaptW(5));
            make.width.equalTo(@(midWidth));
            make.height.equalTo(@(AdaptH(20)));
        }];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(AdaptH(5));
            make.left.equalTo(titleLabel.mas_left);
            make.width.equalTo(titleLabel.mas_width);
            make.height.equalTo(titleLabel.mas_height);
        }];
        
//        titleLabel.backgroundColor = [UIColor redColor];
//        contentLabel.backgroundColor = [UIColor greenColor];
    }
    
//    UIView *botView = [UIView new];
//    [self addSubview:botView];
//    self.botView = botView;
//
//    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(midView.mas_bottom).offset(AdaptH(5.f));
//        make.left.right.equalTo(midView);
//        make.height.equalTo(@(AdaptH(40)));
//    }];
//
//    CGFloat botWidth = (kScreenW - AdaptW(50))/2;
//    for (NSInteger i = 0; i < 2; i++)
//    {
//        UILabel *label = [UILabel new];
//        label.tag = RATELABELTAG +i;
//        label.textAlignment = NSTextAlignmentCenter;
////        label.backgroundColor = [UIColor redColor];
//        label.attributedText = @[[self richTextWithImageStr:@"data_icon_blue" title:@" 续费率" value:@" --%" valueColor:UIColorFromRGB(0x00A9E8)], [self richTextWithImageStr:@"data_icon_yellow" title:@" 有效续费率" value:@" --%" valueColor:UIColorFromRGB(0xFF970F)]][i];
//        [botView addSubview:label];
//
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(botView);
//            make.left.equalTo(botView).offset(AdaptW(20) + i *botWidth + i *AdaptW(10));
//            make.bottom.equalTo(botView);
//            make.width.equalTo(@(botWidth));
//        }];
//    }
}

//// 当前天气的富文本
//- (NSMutableAttributedString *)richTextWithImageStr:(NSString *)imageStr
//                                              title:(NSString *)title
//                                              value:(NSString *)value
//                                         valueColor:(UIColor *)valueColor
//{
//    // 创建一个富文本
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
//    
//    // 添加图片
//    if (imageStr)
//    {
//        // 可以将要插入的图片作为特殊字符处理
//        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//        // 定义图片内容及大小
//        attachment.image = [UIImage imageNamed:imageStr];
//        attachment.bounds = CGRectMake(0, -AdaptH(3), attachment.image.size.width, attachment.image.size.height);
//        // 创建带有图片的富文本
//        NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attachment];
//        // 将图片放在第一位
//        [attributeString insertAttributedString:str atIndex:0];
//    }
//    
//    NSAttributedString *attriTitle = [[NSAttributedString alloc] initWithString:title attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:AdaptFont(13.f)],
//                                                                                                      NSForegroundColorAttributeName : UIColorFromRGB(0x333333)}];
//    NSAttributedString *attriValue = [[NSAttributedString alloc] initWithString:value attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:AdaptFont(16.f)],
//                                                                                                    NSForegroundColorAttributeName : valueColor}];
//    [attributeString appendAttributedString:attriTitle];
//    [attributeString appendAttributedString:attriValue];
//    
//    return attributeString;
//}

@end
