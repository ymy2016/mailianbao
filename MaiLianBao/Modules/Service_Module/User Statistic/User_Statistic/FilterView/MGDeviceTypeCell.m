//
//  MGDeviceTypeCell.m
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/13.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGDeviceTypeCell.h"

@implementation MGDeviceTypeCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = RGB(238, 238, 238, 1).CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 8.0;
        
        _titleBtn = [[UIButton alloc] init];
        _titleBtn.backgroundColor = RGB(235, 235, 235, 1);
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_titleBtn setTitleColor:RGB(51, 51, 51, 1) forState:UIControlStateNormal];
        [_titleBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_titleBtn];
        
        [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.equalTo(self);
        }];
        
    }
    
    return self;
}

- (void)setModel:(MGDeviceTypeOutModel *)model{
    
    _model = model;
    
    // 选中
    if (_model.isSel) {
        _titleBtn.selected = true;
        _titleBtn.backgroundColor = RGB(252, 109, 18, 1);
        [_titleBtn setTitle:_model.DeviceNum forState:UIControlStateSelected];
    }
    // 取消
    else{
        _titleBtn.selected = false;
        _titleBtn.backgroundColor = RGB(238, 238, 238, 1);
        [_titleBtn setTitle:_model.DeviceNum forState:UIControlStateNormal];
    }
}


- (void)btnAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    // 选中
    if (btn.selected) {
        [_titleBtn setTitle:_model.DeviceNum forState:UIControlStateSelected];
        btn.backgroundColor = RGB(252, 109, 18, 1);
    }
    // 取消
    else{
        [_titleBtn setTitle:_model.DeviceNum forState:UIControlStateNormal];
        btn.backgroundColor = RGB(238, 238, 238, 1);
    }
    
    if (self.selBlock) {
        self.selBlock(btn.selected, self.model);
    }
}



@end
