//
//  MGHPInfoImgv.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGHPInfoImgv.h"

@interface MGHPInfoImgv ()

@end

@implementation MGHPInfoImgv

- (instancetype)initWithFrame:(CGRect)frame
                    topDesStr:(NSString *)topDesStr
                    botDesStr:(NSString *)botDesStr
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
//        self.image = [UIImage imageNamed:@"cornerRect-1"];
        
        UILabel *topDesLab = [[UILabel alloc] init];
        topDesLab.text = topDesStr;
        topDesLab.textColor = UIColorFromRGB(0x333333);
        topDesLab.font = [UIFont systemFontOfSize:AdaptFont(12)];
        [self addSubview:topDesLab];
        [topDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(AdaptW(8));
            make.top.equalTo(self).offset(AdaptH(15));
            make.height.equalTo(@(AdaptH(15)));
        }];
        
        _topLab = [[UILabel alloc] init];
        _topLab.textAlignment = NSTextAlignmentRight;
        _topLab.textColor = [UIColor orangeColor];
        _topLab.font = [UIFont boldSystemFontOfSize:AdaptFont(13)];
        [self addSubview:_topLab];
        [_topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topDesLab.mas_top);
            make.left.equalTo(topDesLab.mas_right).offset(AdaptW(5));
            make.right.equalTo(self).offset(AdaptW(-8));
            make.height.equalTo(topDesLab.mas_height);
        }];
        
        UILabel *botDesLab = [[UILabel alloc] init];
        botDesLab.text = botDesStr;
        botDesLab.textColor = UIColorFromRGB(0x333333);
        botDesLab.font = [UIFont systemFontOfSize:AdaptFont(12)];
        [self addSubview:botDesLab];
        [botDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topDesLab.mas_left);
            make.top.equalTo(topDesLab.mas_bottom).mas_offset(AdaptH(15));
            make.height.mas_equalTo(AdaptH(15));
        }];

        _botLab = [[UILabel alloc] init];
        _botLab.textAlignment = NSTextAlignmentRight;
        _botLab.textColor = [UIColor orangeColor];
        _botLab.font = [UIFont boldSystemFontOfSize:AdaptFont(13)];
        [self addSubview:_botLab];
        [_botLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(botDesLab.mas_right).offset(AdaptW(5));
            make.right.equalTo(_topLab.mas_right);
            make.top.equalTo(botDesLab.mas_top);
            make.height.equalTo(botDesLab.mas_height);
        }];
    }
  
    return self;
}

@end
