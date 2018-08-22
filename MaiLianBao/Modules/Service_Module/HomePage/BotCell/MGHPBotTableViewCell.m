//
//  MGHPBotTableViewCell.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGHPBotTableViewCell.h"
#import "MGMineItemView.h"
#import "UIView+BSLine.h"

#define ITEMTAG 1000

@implementation MGHPBotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 6;
        bgView.layer.borderWidth = AdaptW(1.5);
        bgView.layer.borderColor = [UIColor orangeColor].CGColor;
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, AdaptW(5), AdaptH(5), AdaptW(5)));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [bgView addGestureRecognizer:tap];
        
        NSMutableArray *desArr = [NSMutableArray arrayWithObjects:@"续费",@"上月返利",@"金额", nil];

        // 循环遍历，创建item
        for (NSInteger i = 0;i < 3;i++)
        {
            CGFloat itemWidth = (kScreenW - AdaptW(30))/3.0;
            MGMineItemView *itemView = [[MGMineItemView alloc] initWithFrame:CGRectMake(AdaptW(5)+itemWidth*i + AdaptW(5) * i, (AdaptH(75) - AdaptH(55))/2,itemWidth,AdaptH(55)) topLabStr:desArr[i] bottomLabStr:@""];
            itemView.tag = ITEMTAG + i;
            itemView.topLab.textColor = UIColorFromRGB(0x666666);
            itemView.topLab.font = [UIFont systemFontOfSize:AdaptFont(15)];
            itemView.bottomLab.textColor = UIColorFromRGB(0xff8212);
            itemView.bottomLab.font = [UIFont systemFontOfSize:AdaptFont(15)];

            if (i != 2)
            {
                UIView *line = [UIView new];
                line.backgroundColor = [UIColor orangeColor];
                line.frame = CGRectMake(itemView.width + AdaptW(2.5), (itemView.height - AdaptH(50))/2, AdaptW(0.5), AdaptH(50));
                [itemView addSubview:line];
            }

            [bgView addSubview:itemView];
        }
    }
    
    return self;
}

- (void)setModel:(MGHPRebateModel *)model
{
    _model = model;
    
    // self.subviews 第一个视图是UITableViewCellContentView，因此排除它
    // 上月续费笔数
    MGMineItemView *leftItem = [self viewWithTag:ITEMTAG];
    // 上月返利
    MGMineItemView *midItem = [self viewWithTag:ITEMTAG + 1];
    // 上月成交金额
    MGMineItemView *rightItem = [self viewWithTag:ITEMTAG + 2];

    leftItem.bottomLab.text = [NSString stringWithFormat:@"%@笔",[MGFormartUtil countNumAndChangeformat:(NSInteger)_model.lastMonthRenewalsCount]];
    midItem.bottomLab.text = [NSString stringWithFormat:@"¥%@",[MGFormartUtil countNumAndChangeformat:(NSInteger)_model.lastMonthBackAmount]];
    rightItem.bottomLab.text = [NSString stringWithFormat:@"¥%@",[MGFormartUtil countNumAndChangeformat:(NSInteger)_model.lastMonthRenewalsAmount]];
}

// 视图点击手势响应
- (void)tapAction
{
    if ([_delegate respondsToSelector:@selector(handleBotCellTap)])
    {
        [_delegate handleBotCellTap];
    }

}

@end
