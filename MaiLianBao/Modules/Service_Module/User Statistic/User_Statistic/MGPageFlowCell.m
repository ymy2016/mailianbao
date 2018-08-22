//
//  MyCell.m
//  SCAdViewDemo
//
//  Created by 谭伟华 on 2018/4/11.
//  Copyright © 2018年 Coder Chan. All rights reserved.
//

#import "MGPageFlowCell.h"
#import "MGPageFlowModel.h"

@interface MGPageFlowCell()

@property(nonatomic,strong)UILabel *titleLab;

@property(nonatomic,strong)UILabel *numLab;

@end


@implementation MGPageFlowCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = RGB(255, 131, 18, 1);
        
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 10;
        bgView.layer.shadowColor = [UIColor blackColor].CGColor;
        bgView.layer.shadowOpacity = 0.3;
        bgView.layer.shadowRadius = 3.0f;
        bgView.layer.shadowOffset = CGSizeMake(3, 3);
        bgView.clipsToBounds =NO;
        [self addSubview:bgView];
        
        UILabel *titleLab = [[UILabel alloc] init];
        self.titleLab = titleLab;
        titleLab.textColor = [UIColor whiteColor];
        titleLab.text = @" ";
        titleLab.font = [UIFont systemFontOfSize:12];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).mas_offset(-10);
            make.size.mas_equalTo(CGSizeMake(120, 20));
        }];
        
        UILabel *numLab = [[UILabel alloc] init];
        self.numLab = numLab;
        numLab.textColor = [UIColor whiteColor];
        numLab.text = @" ";
        numLab.font = [UIFont systemFontOfSize:12];
        numLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numLab];
        [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(120, 20));
        }];
        
    }
    
    return self;
}

- (void)setModel:(MGPageFlowModel *)model{
    
    self.titleLab.text = model.title;
    
    self.numLab.text = [NSString stringWithFormat:@"%@",model.num];
}

@end
