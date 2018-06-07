//
//  MGMineItemView.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/20.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGMineItemView.h"

@implementation MGMineItemView

- (instancetype)initWithFrame:(CGRect)frame
                    topLabStr:(NSString *)topLabStr
                 bottomLabStr:(NSString *)bottomLabStr
{
    if (self = [super initWithFrame:frame])
    {
        
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *topLab = [[UILabel alloc] init];
        self.topLab = topLab;
        topLab.backgroundColor = [UIColor clearColor];
        topLab.textColor = [UIColor whiteColor];
        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.font = [UIFont systemFontOfSize:AdaptFont(15)];
        [self addSubview:topLab];
        [topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.height.mas_equalTo(AdaptH(25));
        }];
        // 初始化赋值
        topLab.text = topLabStr;
        
        UILabel *bottmLab = [[UILabel alloc] init];
        self.bottomLab = bottmLab;
        bottmLab.backgroundColor = [UIColor clearColor];
        bottmLab.textColor = [UIColor whiteColor];
        bottmLab.textAlignment = NSTextAlignmentCenter;
        bottmLab.font = [UIFont boldSystemFontOfSize:AdaptFont(15)];
        [self addSubview:bottmLab];
        [bottmLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topLab);
            make.top.equalTo(topLab.mas_bottom).mas_offset(AdaptH(5));
            make.height.mas_equalTo(AdaptH(25));
        }];
        // 初始化赋值
        bottmLab.text = bottomLabStr;
    }

    return self;
}

@end
