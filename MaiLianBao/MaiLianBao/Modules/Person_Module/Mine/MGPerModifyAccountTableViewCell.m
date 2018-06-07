//
//  MGPerModifyAccountTableViewCell.m
//  MaiLianBao
//
//  Created by 伟华 on 17/1/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerModifyAccountTableViewCell.h"

#define Right_Padding -AdaptW(30)

@implementation MGPerModifyAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _rightImgv = [[UIImageView alloc] init];
//      _rightImgv.contentMode = UIViewContentModeScaleAspectFit;
        _rightImgv.layer.cornerRadius = AdaptW(20);
        _rightImgv.layer.masksToBounds = YES;
        [self addSubview:_rightImgv];
        [_rightImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(Right_Padding);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(AdaptW(40),AdaptW(40)));
        }];
        
        _rightLab = [[UILabel alloc] init];
        _rightLab.backgroundColor = [UIColor clearColor];
        _rightLab.textAlignment = NSTextAlignmentRight;
        _rightLab.textColor = [UIColor lightGrayColor];
        [self addSubview:_rightLab];
        [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(Right_Padding);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(AdaptW(200),AdaptW(30)));
        }];
    }
    
    return self;
}

- (void)setRightStr:(NSString *)rightStr{

    _rightStr = rightStr;
    
    if (_rightStr.length != 0) {
        
        _rightImgv.hidden = YES;
        _rightLab.hidden = NO;
        _rightLab.text = _rightStr;
    }
}

- (void)setRightImg:(NSString *)rightImg{

    _rightImg = rightImg;
    
    if (_rightImg.length != 0) {
        
        _rightImgv.hidden = NO;
        _rightLab.hidden = YES;
        _rightImgv.image = [UIImage imageNamed:_rightImg];
    }
}


@end
