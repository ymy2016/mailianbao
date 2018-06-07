//
//  MGHPRoteTableViewCell.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/7.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGHPRoteTableViewCell.h"
#import "MGHPRebateModel.h"

#define RATELABELTAG 2000

@implementation MGHPRoteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat botWidth = (kScreenW - AdaptW(50))/2;
        for (NSInteger i = 0; i < 2; i++)
        {
            UILabel *label = [UILabel new];
            label.tag = RATELABELTAG +i;
            label.textAlignment = NSTextAlignmentCenter;
            // label.backgroundColor = [UIColor redColor];
            label.attributedText = @[[self richTextWithImageStr:@"data_icon_blue" title:@" 续费率" value:@" 0.00%" valueColor:UIColorFromRGB(0x00A9E8)], [self richTextWithImageStr:@"data_icon_yellow" title:@" 有效续费率" value:@" 0.00%" valueColor:UIColorFromRGB(0xFF970F)]][i];
            [self.contentView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(AdaptW(20) + i *botWidth + i *AdaptW(10));
                make.bottom.equalTo(self.contentView);
                make.width.equalTo(@(botWidth));
            }];
        }
    }
    return self;
}

- (void)setModel:(MGHPRebateModel *)model
{
    _model = model;
    
    // 续费率
    CGFloat n = (_model.renewalsActiveCount / (_model.activatedCount + _model.stopCount)) * 100;
    if (isnan(n)) n = 0.00;
    UILabel *renewRateLabel = [self viewWithTag:RATELABELTAG];
    renewRateLabel.attributedText = [self richTextWithImageStr:@"data_icon_blue" title:@" 续费率" value:[NSString stringWithFormat:@" %.2f%%", n] valueColor:UIColorFromRGB(0x00A9E8)];
    
    n = (_model.renewalsActiveCount / (_model.ltOutCount + _model.renewalsActiveCount)) * 100;
    if (isnan(n)) n = 0.00;
    UILabel *effectiveLabel = [self viewWithTag:RATELABELTAG +1];
    effectiveLabel.attributedText = [self richTextWithImageStr:@"data_icon_yellow" title:@" 有效续费率" value:[NSString stringWithFormat:@" %.2f%%", n] valueColor:UIColorFromRGB(0xFF970F)];
}

// 当前天气的富文本
- (NSMutableAttributedString *)richTextWithImageStr:(NSString *)imageStr
                                              title:(NSString *)title
                                              value:(NSString *)value
                                         valueColor:(UIColor *)valueColor
{
    // 创建一个富文本
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] init];
    
    // 添加图片
    if (imageStr)
    {
        // 可以将要插入的图片作为特殊字符处理
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        // 定义图片内容及大小
        attachment.image = [UIImage imageNamed:imageStr];
        attachment.bounds = CGRectMake(0, -AdaptH(3), attachment.image.size.width, attachment.image.size.height);
        // 创建带有图片的富文本
        NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attachment];
        // 将图片放在第一位
        [attributeString insertAttributedString:str atIndex:0];
    }
    
    NSAttributedString *attriTitle = [[NSAttributedString alloc] initWithString:title attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:AdaptFont(13.f)],
                                                                                                    NSForegroundColorAttributeName : UIColorFromRGB(0x333333)}];
    NSAttributedString *attriValue = [[NSAttributedString alloc] initWithString:value attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:AdaptFont(16.f)],
                                                                                                    NSForegroundColorAttributeName : valueColor}];
    [attributeString appendAttributedString:attriTitle];
    [attributeString appendAttributedString:attriValue];
    
    return attributeString;
}

@end
