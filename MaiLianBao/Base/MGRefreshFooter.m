//
//  MGRefreshFooter.m
//  OBDApp
//
//  Created by 苏晗 on 15/12/10.
//  Copyright © 2015年 MapGoo. All rights reserved.
//

#import "MGRefreshFooter.h"

@interface MGRefreshFooter()
@property (strong, nonatomic) UIActivityIndicatorView * activityIndicatorView;
@end
@implementation MGRefreshFooter

#pragma mark - 懒加载子控件
- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

#pragma makr - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.stateLabel.font = [UIFont systemFontOfSize:AdaptFont(13.f)];
    self.stateLabel.textColor = UIColorFromRGB(0x666666);
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.activityIndicatorView.constraints.count) return;
    
    // 圈圈
    CGFloat centerX = self.mj_w * 0.55;
    if (!self.isRefreshingTitleHidden) {
        centerX -= AdaptW(100);
    }
    CGFloat centerY = self.mj_h * 0.5;
    self.activityIndicatorView.center = CGPointMake(centerX, centerY);
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.activityIndicatorView stopAnimating];
    } else if (state == MJRefreshStateRefreshing) {
        [self.activityIndicatorView startAnimating];
    }
}
@end
