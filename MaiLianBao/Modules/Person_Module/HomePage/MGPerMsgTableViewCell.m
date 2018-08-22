//
//  MGPerMsgTableViewCell.m
//  MaiLianBao
//
//  Created by 伟华 on 17/1/7.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerMsgTableViewCell.h"

#define Padding AdaptW(10)
#define TextWidth (kScreenW-3*Padding)

@interface MGPerMsgTableViewCell ()

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UILabel *timeLab;

@property(nonatomic,strong)UILabel *contentLab;

@end

@implementation MGPerMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
      
        _timeLab = [[UILabel alloc] init];
        _timeLab.numberOfLines = 0;
        _timeLab.textColor = [UIColor lightGrayColor];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.font = [UIFont boldSystemFontOfSize:AdaptFont(15.0)];
        [self.contentView addSubview:_timeLab];
     
        _contentLab = [[UILabel alloc] init];
        _contentLab.numberOfLines = 0;
        _contentLab.textColor = [UIColor blackColor];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.font = [UIFont boldSystemFontOfSize:AdaptFont(15.0)];
        [self.contentView addSubview:_contentLab];
    
    }

    return self;
}

- (void)setModel:(MGPerMsgModel *)model{

    _model = model;
    
    _timeLab.text = _model.postTime;
    _contentLab.attributedText = [self setSpaceWithText:_model.postContent lineSpacing:3];
}

// 设置内容的行间距
- (NSMutableAttributedString *)setSpaceWithText:(NSString *)text
                                    lineSpacing:(CGFloat)lineSpacing{
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
  
    return attributeStr;
}

// 计算高度
- (CGFloat)prepareLayoutHeight{

    /*
     *  使用Masonry后，要后续获取UI控件frame，先得调用[self layoutIfNeeded]方法，意思是通知系统，去调
     *  layoutSubviews方法，重新布局子控件
     */
    [self layoutIfNeeded];
    
     /*
      * CGRectGetMaxY(self.frame) = self.frame.origin.y + self.frame.size.height
      * CGRectGetHeight(self.frame) = self.frame.size.height
      */
    CGFloat cellHeight = CGRectGetMaxY(_contentLab.frame) + 2 * Padding;
    
    return cellHeight;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(Padding, Padding, Padding, Padding));
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(2 * Padding);
        make.top.equalTo(self.contentView).mas_offset(2 * Padding);
        make.width.mas_lessThanOrEqualTo(TextWidth);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLab.mas_bottom).mas_offset(Padding);
        make.left.equalTo(_timeLab);
        make.width.mas_lessThanOrEqualTo(TextWidth);
    }];
    
}

@end
