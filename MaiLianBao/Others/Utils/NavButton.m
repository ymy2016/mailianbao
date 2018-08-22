//
//  NavButton.m
//  Marvoto
//
//  Created by 谭伟华 on 16/5/18.
//  Copyright © 2016年 LBS. All rights reserved.
//

#import "NavButton.h"

@implementation NavButton

- (instancetype)initWithBtnStr:(NSString *)btnStr
                btnActionBlock:(void(^)())btnActionBlock
{
    if (self = [super init])
    {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, AdaptW(80), AdaptH(20))];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        leftBtn.backgroundColor = [UIColor clearColor];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [leftBtn setTitle:btnStr forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        self.customView = leftBtn;
        _btnBlock = btnActionBlock;
    }

    return self;
}

- (instancetype)initWithBtnImg:(NSString *)btnImg
                btnActionBlock:(void(^)())btnActionBlock
{
    if (self = [super init])
    {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, AdaptW(34),AdaptW(34))];
        leftBtn.contentMode = UIViewContentModeScaleAspectFit;
        leftBtn.backgroundColor = [UIColor clearColor];
        [leftBtn setImage:[UIImage imageNamed:btnImg] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        self.customView = leftBtn;
        _btnBlock = btnActionBlock;
        
    }
    
    return self;
}

- (void)btnAction
{
    _btnBlock();
}

- (instancetype)initWithBtnImg:(NSString *)btnImg delegate:(id<NavLeftBtnDelegate>)delegate
{
    if (self = [super init])
    {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, AdaptW(40),AdaptW(40))];
        leftBtn.contentMode = UIViewContentModeScaleAspectFit;
        leftBtn.backgroundColor = [UIColor clearColor];
        [leftBtn setImage:[UIImage imageNamed:btnImg] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(btnDelegateAction) forControlEvents:UIControlEventTouchUpInside];
        self.customView = leftBtn;
        // 设置代理，外部实现代理方法
        self.delegate = delegate;
    }
    
    return self;
}

- (void)btnDelegateAction
{
    if ([_delegate respondsToSelector:@selector(back)])
    {
        [_delegate back];
    }   
}

@end
