//
//  MGPerCardTableViewCell.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerCardTableViewCell.h"
#import "MGCardListModel.h"

@interface MGPerCardTableViewCell ()
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UIView *cardBackgroundView;
@end

@implementation MGPerCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.cardBackgroundView = [UIView new];
//    self.cardBackgroundView.layer.contents = (id)[UIImage imageNamed:@"cell_bg_unicom"].CGImage;
    [self.contentView addSubview:self.cardBackgroundView ];
    [self.cardBackgroundView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, AdaptW(10), 0, AdaptW(10)));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"per_icon_sim"]];
    imageView.alpha = 0.2;
    [self.cardBackgroundView  addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardBackgroundView );
        make.left.equalTo(self.cardBackgroundView ).mas_offset(AdaptW(25));
        make.width.mas_equalTo(imageView.image.size.width);
        make.height.mas_equalTo(imageView.image.size.height);
    }];
    
    self.codeLabel = [UILabel new];
    self.codeLabel.textColor = [UIColor whiteColor];
    self.codeLabel.font = [UIFont systemFontOfSize:AdaptFont(16.f)];
    [self.cardBackgroundView  addSubview:self.codeLabel];
    
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cardBackgroundView );
        make.left.equalTo(imageView.mas_right).mas_offset(AdaptW(20));
        make.right.equalTo(self.cardBackgroundView ).mas_offset(AdaptW(-25));
        make.height.mas_equalTo(self.cardBackgroundView);
    }];
}

- (void)setCardModel:(MGCardListModel *)cardModel
{
    _cardModel = cardModel;
    
    self.codeLabel.text = _cardModel.ICCID;
    
    UIImage *backgroundImage = nil;
    if (_cardModel.SimFromType == 0) {
        backgroundImage = [UIImage imageNamed:@"cell_bg_chinamobile"];
    }
    else if (_cardModel.SimFromType == 1) {
        backgroundImage = [UIImage imageNamed:@"cell_bg_unicom"];
    }
    else if (_cardModel.SimFromType == 2) {
        backgroundImage = [UIImage imageNamed:@"cell_bg_telecom"];
    }
    
    self.cardBackgroundView.layer.contents = (id)backgroundImage.CGImage;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
