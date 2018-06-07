//
//  MGUserStatisticTableCell.m
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/11.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGUserStatisticTableCell.h"

@implementation MGUserStatisticChartModel

- (instancetype)initWithProvinceName:(NSString *)provinceName
                            maxValue:(NSInteger)maxValue
                        currentValue:(NSInteger)currentValue{
    
    if (self = [super init]) {
        
        self.provinceName = provinceName;
        self.maxValue = maxValue;
        self.currentValue = currentValue;
    }
    
    return self;
}

- (instancetype)initWithProvinceName:(NSString *)provinceName
                              rebate:(NSString *)rebate
                               renew:(NSString *)renew{

    if (self = [super init]) {
        
        self.provinceName = provinceName;
        self.renew = renew;
        self.rebate = rebate;
    }
    
    return self;
}

@end

@interface MGUserStatisticTableCell()

@property(nonatomic,strong)UILabel *leftLab;

@property(nonatomic,strong)UILabel *rightLab;

@property(nonatomic,strong)UILabel *midLab;

@property(nonatomic,strong)MGUserStatisticChartBar *chartBar;

@end

// 柱状图宽度
#define ChartBarWidth AdaptW(180)

@implementation MGUserStatisticTableCell

// 初始化续费tableView的cell
- (instancetype)initRenewCellWithStyle:(UITableViewCellStyle)style
                       reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.leftLab.textAlignment = NSTextAlignmentLeft;
        self.rightLab.textAlignment = NSTextAlignmentRight;
        self.midLab.textColor = [UIColor orangeColor];
        self.rightLab.textColor = [UIColor orangeColor];
        [self addSubview:self.leftLab];
        [self addSubview:self.rightLab];
        [self addSubview:self.midLab];
        
        [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).mas_offset(AdaptW(20));
            make.size.mas_equalTo(CGSizeMake(AdaptW(120), AdaptH(20)));
        }];
        
        [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).mas_offset(-AdaptW(20));
            make.size.mas_equalTo(CGSizeMake(AdaptW(100), AdaptH(20)));
        }];
        
        [_midLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).mas_offset(-AdaptW(12));
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(AdaptW(100), AdaptH(20)));
        }];
    }
    
    return self;
}

// 初始化，除续费之外的cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.leftLab];
        [self addSubview:self.rightLab];

        [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).mas_offset(AdaptW(20));
            make.size.mas_equalTo(CGSizeMake(AdaptW(100), AdaptH(20)));
        }];

        [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).mas_offset(-AdaptW(10));
            make.size.mas_equalTo(CGSizeMake(AdaptW(70), AdaptH(20)));
        }];

        _chartBar = [[MGUserStatisticChartBar alloc] init];
        _chartBar.backgroundColor = [UIColor clearColor];
        [self addSubview:_chartBar];
        [_chartBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_leftLab.mas_right);
            make.size.mas_equalTo(CGSizeMake(ChartBarWidth, AdaptH(5)));
        }];
    }
    
    return self;
}

// 包含柱状图cell的model赋值 / 续费cell的model赋值
- (void)setModel:(MGUserSynthesisUseOutModel *)model{
    
    _model = model;
    /* 柱状图cell、续费cell*/
        // 比例系数 * 总宽度
        CGFloat rWidth = 0.0;

        _leftLab.text = _model.HoldName;
         // 注册用户
         if (model.modelType == RegisterUserType){
             
             _rightLab.text = Formart.num(model.RegisterUser);
             // [NSString stringWithFormat:@"%.0f",model.RegisterUser];
             if (model.maxValue == 0) {
                 rWidth = 0;
             }
             else{
                 rWidth =  (model.RegisterUser / model.maxValue) * ChartBarWidth;
             }
         }
         // 活跃用户
         else if (model.modelType == ActivieUserType){
            _rightLab.text = Formart.num(model.ActiveUser);
            if (model.maxValue == 0) {
                 rWidth = 0;
             }
             else{
                rWidth =  (model.ActiveUser / model.maxValue) * ChartBarWidth;
             }
         }
         // 首次入网
         else if (model.modelType == FirstActivationType){
            _rightLab.text = Formart.num(model.FirstActivation);
             if (model.maxValue == 0) {
                 rWidth = 0;
             }
             else{
                rWidth =  (model.FirstActivation / model.maxValue) * ChartBarWidth;
             }
         }
         // 续费
         else if (model.modelType == RenewType){
            // 返利金额
             _midLab.text = [NSString stringWithFormat:@"¥%@",Formart.num(model.RebateAmount)];
           // 续费金额
            _rightLab.text = [NSString stringWithFormat:@"¥%@",Formart.num(model.RenewAmount)];
           return;
         }
         // 停机
         else if (model.modelType == StopType){
             _rightLab.text = Formart.num(model.Stopped);
             if (model.maxValue == 0) {
                 rWidth = 0;
             }
             else{
                rWidth =  (model.Stopped / model.maxValue) * ChartBarWidth;
             }
            
         }
    
        if (rWidth < 1 && rWidth != 0) {
            rWidth = 1;
        }
        [_chartBar mas_updateConstraints:^(MASConstraintMaker *make) {
             make.width.mas_equalTo(rWidth);
        }];
        
        // 触发drawRect绘图
        [_chartBar setNeedsDisplay];
}

#pragma mark - 懒加载
// 左侧lab
- (UILabel *)leftLab{
    
    if (_leftLab == nil) {
        
        _leftLab = [[UILabel alloc] init];
        _leftLab.font = [UIFont systemFontOfSize:14];
        _leftLab.textColor = [UIColor blackColor];
        _leftLab.textAlignment = NSTextAlignmentLeft;
    }
    
    return _leftLab;
}
// 右侧lab
- (UILabel *)rightLab{
    
    if (_rightLab == nil) {
        
        _rightLab = [[UILabel alloc] init];
        _rightLab.font = [UIFont systemFontOfSize:14];
        _rightLab.textColor = [UIColor blackColor];
        _rightLab.textAlignment = NSTextAlignmentRight;
    }
    
    return _rightLab;
}
// 中间lab
- (UILabel *)midLab{
    
    if (_midLab == nil) {
        
        _midLab = [[UILabel alloc] init];
        _midLab.font = [UIFont systemFontOfSize:14];
        _midLab.textColor = [UIColor blackColor];
        _midLab.textAlignment = NSTextAlignmentRight;
    }
    
    return _midLab;
}

@end


@implementation MGUserStatisticChartBar

- (void)drawRect:(CGRect)rect{

    CGFloat radius = 10;

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    [[UIColor orangeColor] set];
    [path fill];
    
}

@end
