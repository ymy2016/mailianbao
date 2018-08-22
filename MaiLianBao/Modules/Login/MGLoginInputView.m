//
//  MGLoginInputView.m
//  MaiLianBao
//
//  Created by 谭伟华 on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGLoginInputView.h"

@implementation MGLoginInputView

- (instancetype)initWithFrame:(CGRect)frame
                      leftImg:(NSString *)leftImg
           rightTfPlaceholder:(NSString *)rightTfPlaceholder
{
    if (self = [super initWithFrame:frame])
    {
        
        UIImageView *leftImgv = [[UIImageView alloc] init];
        leftImgv.backgroundColor = [UIColor clearColor];
        leftImgv.contentMode = UITextFieldViewModeWhileEditing;
        leftImgv.image = [UIImage imageNamed:leftImg];
        [self addSubview:leftImgv];
        [leftImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).mas_offset(AdaptW(8));
            make.size.mas_equalTo(CGSizeMake(AdaptW(30), AdaptW(30)));
        }];
        
        UITextField *inputTf = [[UITextField alloc] init];
        self.inputTf = inputTf;
        inputTf.backgroundColor = [UIColor clearColor];
        inputTf.placeholder = rightTfPlaceholder;
        inputTf.font = [UIFont systemFontOfSize:AdaptFont(16)];
        inputTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:inputTf];
        [inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(leftImgv.mas_right).mas_offset(AdaptW(10));
            make.right.equalTo(self);
            make.height.mas_equalTo(AdaptH(40));
        }];
    }

    return self;
}

@end
