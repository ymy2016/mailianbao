//
//  MGHPTopTableViewCell.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGHPTopTableViewCell.h"
#import "MGHPInfoImgv.h"
#import "UIView+BSLine.h"

@interface MGHPTopTableViewCell ()
@property(nonatomic,strong)MGHPInfoImgv *leftImgv;
@property(nonatomic,strong)MGHPInfoImgv *rightImgv;

@end

@implementation MGHPTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        
//        UIView *bgView = [UIView new];
//        bgView.backgroundColor = [UIColor whiteColor];
//        bgView.layer.borderWidth = AdaptW(1.5);
//        bgView.layer.cornerRadius = 6;
//        bgView.layer.borderColor = [UIColor orangeColor].CGColor;
//        [self.contentView addSubview:bgView];
//        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(AdaptH(5), AdaptW(5), 0, AdaptW(5)));
//        }];
//
//        UIView *line = [UIView new];
//        line.backgroundColor = UIColorFromRGB(0xCCCCCC);
//        [bgView addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(bgView);
//            make.size.mas_equalTo(CGSizeMake(AdaptW(0.5), AdaptH(40)));
//        }];
        
        // 中间分割线
        [self addVerLineWithPadingTop:40 bottom:15 left:kScreenW/2.0];
        
        // 续费返利
        UILabel *topLab = [[UILabel alloc] init];
        topLab.text = @"续费返利";
        topLab.textAlignment = NSTextAlignmentRight;
        topLab.font = [UIFont systemFontOfSize:AdaptFont(14)];
        topLab.textColor = UIColorFromRGB(0x333333);
        [self addSubview:topLab];
        [topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(AdaptH(8));
            make.left.equalTo(self).mas_offset(AdaptW(10));
            make.height.mas_equalTo(AdaptH(30));
        }];
        
        // 更多
        UIButton *checkBtn = [[UIButton alloc] init];
        checkBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(13)];
        [checkBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        checkBtn.titleEdgeInsets = UIEdgeInsetsMake(0, AdaptW(-25), 0, 0);
        checkBtn.imageEdgeInsets = UIEdgeInsetsMake(0, AdaptW(27), 0, 0);
        [checkBtn setTitle:@"更多" forState:UIControlStateNormal];
        [checkBtn addTarget:self action:@selector(checkMoreAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkBtn];
        [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-AdaptW(10));
            make.centerY.equalTo(topLab);
        }];
        
        // 左侧Imgv
        _leftImgv = [[MGHPInfoImgv alloc] initWithFrame:CGRectZero topDesStr:@"本月返利" botDesStr:@"本月续费"];
        _leftImgv.botLab.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_leftImgv];
        [_leftImgv mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self).mas_offset(AdaptH(40));
             make.left.equalTo(self).mas_equalTo(AdaptW(5));
             make.size.mas_equalTo(CGSizeMake(AdaptW(175),AdaptH(70)));
         }];
        
        // 左侧Imgv,添加点击手势
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapAction)];
        [_leftImgv addGestureRecognizer:leftTap];
        
        // 右侧Imgv
        _rightImgv = [[MGHPInfoImgv alloc] initWithFrame:CGRectZero topDesStr:@"上月返利" botDesStr:@"上月续费"];
        _rightImgv.botLab.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_rightImgv];
        [_rightImgv mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_leftImgv.mas_top);
             make.right.equalTo(self).mas_equalTo(-AdaptW(5));
             make.size.mas_equalTo(CGSizeMake(AdaptW(175),AdaptH(70)));
         }];

        // 右侧Imgv,添加点击手势
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapAction)];
        [_rightImgv addGestureRecognizer:rightTap];
    }
  
    return self;
}

- (void)setModel:(MGHPRebateModel *)model
{
    _model = model;

//    _leftImgv.topLab.text = Formart.money(_model.monthBackAmount);
//    _leftImgv.botLab.text = Formart.money(_model.monthRenewalsAmount);
//
//    _rightImgv.topLab.text = Formart.money(_model.totalBackAmount);
//    _rightImgv.botLab.text = Formart.money(_model.totalRenewalsAmount);
    
    _leftImgv.topLab.text = [NSString stringWithFormat:@"¥%@",[MGFormartUtil countNumAndChangeformat:(NSInteger)_model.monthBackAmount]];
    _leftImgv.botLab.text = [NSString stringWithFormat:@"¥%@",[MGFormartUtil countNumAndChangeformat:(NSInteger)_model.monthRenewalsAmount]];

    _rightImgv.topLab.text = [NSString stringWithFormat:@"¥%@",[MGFormartUtil countNumAndChangeformat:(NSInteger)_model.lastMonthBackAmount]];
    _rightImgv.botLab.text = [NSString stringWithFormat:@"¥%@",[MGFormartUtil countNumAndChangeformat:(NSInteger)_model.lastMonthRenewalsAmount]];
}

// TODO: 左侧Imgv点击
- (void)leftTapAction
{
    if ([_delegate respondsToSelector:@selector(handleImgvTapWithImgvPosition:)])
    {
        [_delegate handleImgvTapWithImgvPosition:LeftPosition];
    }
}

// TODO: 右侧Imgv点击
- (void)rightTapAction
{
    if ([_delegate respondsToSelector:@selector(handleImgvTapWithImgvPosition:)])
    {
        [_delegate handleImgvTapWithImgvPosition:RightPosition];
    }
}

// TODO: 点击右侧更多按钮
- (void)checkMoreAction{
    
    if ([_delegate respondsToSelector:@selector(handleImgvTapWithImgvPosition:)]) {
        
    }
    
    if ([_delegate respondsToSelector:@selector(handleImgvTapWithImgvPosition:)])
    {
        [_delegate handleImgvTapWithImgvPosition:LeftPosition];
    }
}

@end
