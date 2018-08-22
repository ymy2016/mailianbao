//
//  MGMineAccountTableViewCell.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/20.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGMineAccountTableViewCell.h"

@implementation MGMineAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _inputTf = [[UITextField alloc] init];
        _inputTf.backgroundColor = [UIColor clearColor];
        _inputTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTf.secureTextEntry = YES;
        _inputTf.font = [UIFont systemFontOfSize:AdaptFont(16)];
        [_inputTf addTarget:self action:@selector(inputStrAction:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_inputTf];
        [_inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).mas_offset(AdaptW(30));
            make.size.mas_equalTo(CGSizeMake(AdaptW(320),AdaptH(30)));
        }];
        
    }
    
    return self;
}

- (void)inputStrAction:(UITextField *)tf
{
    if (self.inputBlock)
    {
        self.inputBlock(tf.text);
    }
}

@end
