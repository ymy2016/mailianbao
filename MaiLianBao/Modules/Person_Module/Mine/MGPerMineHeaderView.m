//
//  MGPerMineHeaderView.m
//  MaiLianBao
//
//  Created by 伟华 on 17/1/4.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerMineHeaderView.h"

@implementation MGPerMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
                    centerImg:(NSString *)centerImg
                     nickName:(NSString *)nickName{

    if (self = [super initWithFrame:frame]) {
        
        // 给View添加背景图片
        UIImage *bgvImg = [UIImage imageNamed:@"bg"];
        self.layer.contents = (id)bgvImg.CGImage;
        
        _centerImgv = [[UIImageView alloc] init];
//        _centerImgv.contentMode = UIViewContentModeScaleAspectFit;
        // @"mlb_logo"
        _centerImgv.image = [UIImage imageNamed:centerImg];
        _centerImgv.layer.masksToBounds = YES;
        _centerImgv.layer.cornerRadius = AdaptW(41.5);
        [self addSubview:_centerImgv];
        [_centerImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).mas_offset(AdaptH(80));
            make.size.mas_equalTo(CGSizeMake(AdaptW(83),AdaptW(83)));
        }];
        
        _nickLab = [[UILabel alloc] init];
        // @"一只兔子banana";
        _nickLab.text = nickName;
        _nickLab.textColor = [UIColor whiteColor];
        _nickLab.textAlignment = NSTextAlignmentCenter;
        _nickLab.font = [UIFont boldSystemFontOfSize:AdaptFont(17)];
        [self addSubview:_nickLab];
        [_nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_centerImgv);
            make.top.equalTo(_centerImgv.mas_bottom).mas_offset(AdaptH(20));
            make.height.mas_equalTo(AdaptH(25));
        }];
        
        // 整个View添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)tapAction{

    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
