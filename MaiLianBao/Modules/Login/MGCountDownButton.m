//
//  MGCountDownButton.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/4.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGCountDownButton.h"

@interface MGCountDownButton ()
{
    NSInteger _countdown;
    NSTimer * _countdownTimer;
}
@end

@implementation MGCountDownButton

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupBackgroundNotification];
        [self pretreat];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupBackgroundNotification];
        [self pretreat];
    }
    return self;
}

- (void)pretreat
{
    self.countdownBeginNumber = 60;
    self.normalBgImageName = @"";
    self.selectedBgImageName = @"";
    self.normalTitle = @"获取验证码";
    self.titleColor = [UIColor orangeColor];
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.cornerRadius = 4;
}

- (void)setupBackgroundNotification
{
    // 进入前台,开启定时器
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(distantPastTimer)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    // 进入后台,关闭定时器
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(distantFutureTimer)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)drawRect:(CGRect)rect
{
    _countdown = self.countdownBeginNumber;
    [self setupCountdownButton];
}

- (void)setupCountdownButton
{
    [self setBackgroundImage:[UIImage imageNamed:self.normalBgImageName] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:self.selectedBgImageName] forState:UIControlStateSelected];
    
    self.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [self setTitle:self.normalTitle forState:UIControlStateNormal];
    [self setTitleColor:self.titleColor forState:UIControlStateNormal];
    [self addTarget:self action:@selector(receiveCode) forControlEvents:UIControlEventTouchUpInside];
}

- (void)receiveCode
{
    if ([_delegate respondsToSelector:@selector(countdownBtnClicked:)])
    {
        [_delegate countdownBtnClicked:self];
    }
}
- (void)countdownBegin
{
    self.userInteractionEnabled = NO;
    self.selected = YES;
    [self setTitle:[NSString stringWithFormat:@"%@秒后获取",@(self.countdownBeginNumber)] forState:UIControlStateNormal];
    
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(closeGetVerifyButtonUser) userInfo:nil repeats:YES];
}

- (void)closeGetVerifyButtonUser
{
    _countdown--;
    NSLog(@"%@",@(_countdown));
    self.userInteractionEnabled = NO;
    
    self.layer.borderColor = [UIColor grayColor].CGColor;
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //     self.titleLabel.text = [NSString stringWithFormat:@"%@秒后获取",@(_countdown)];
    [self setTitle:[NSString stringWithFormat:@"%@秒后获取",@(_countdown)] forState:UIControlStateNormal];
    if (_countdown == 0)
    {
        [self countdownStop];
    }
}

- (void)countdownStop
{
    self.selected = NO;
    self.userInteractionEnabled = YES;
    
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    [self setTitleColor:self.titleColor forState:UIControlStateNormal];
    
    [self setTitle:self.normalTitle forState:UIControlStateNormal];
    //    _normalLabel.text = self.normalTitle;
    _countdown = self.countdownBeginNumber;
    //注意此处不是暂停计时器,而是彻底注销,使_countdownTimer.valid == NO;
    [_countdownTimer invalidate];
    _countdownTimer = nil;
}

//页面将要进入前台，开启定时器
-(void)distantPastTimer
{
    //    if([_countdownTimer isValid]&&(_countdown >0))
    //    //开启定时器
    //    [_countdownTimer setFireDate:[NSDate distantPast]];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)distantFutureTimer
{
    //    if([_countdownTimer isValid]&&(_countdown >0))
    //    //关闭定时器
    //    [_countdownTimer setFireDate:[NSDate distantFuture]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:Nil];
}


@end
