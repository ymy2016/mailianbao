//
//  RefreshDiyHeader.m
//  CarTools
//
//  Created by 苏晗 on 2016/12/26.
//  Copyright © 2016年 MapGoo. All rights reserved.
//

#import "RefreshDiyHeader.h"

@interface RefreshDiyHeader ()
@property (nonatomic, strong) CAShapeLayer *activityShapLayer;
@property (nonatomic, strong) UIView *loadingView;
@end

@implementation RefreshDiyHeader

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)stopAnimations
{
    [self.activityShapLayer removeAllAnimations];
}

- (void)startAnimations
{
    [self addAnimation];
}

- (void)addAnimation
{
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    [animation setKeyPath:@"transform.rotation.z"];
    [animation setDuration:1];
    [animation setFromValue:0];
    [animation setToValue:@(2*M_PI)];
    [animation setRepeatCount:10000];
    [animation setRemovedOnCompletion:NO];
    
    [self.activityShapLayer addAnimation:animation forKey:@"rotation"];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (state == MJRefreshStateIdle)
    {
        NSLog(@"闲置状态");
        [self stopAnimations];
    }
    else if (state == MJRefreshStatePulling)
    {
        NSLog(@"松开就可以进行刷新");
    }
    else if (state == MJRefreshStateRefreshing)
    {
        NSLog(@"正在刷新");
        [self startAnimations];
    }
    else if (state == MJRefreshStateNoMoreData)
    {
        
    }
}

- (void)prepare
{
    [super prepare];
}

- (void)placeSubviews
{
    [super placeSubviews];

    [self addSubview:self.loadingView];
}

#pragma mark - 懒加载
- (CAShapeLayer *)activityShapLayer
{
    if (!_activityShapLayer)
    {
        _activityShapLayer = [[CAShapeLayer alloc] init];
        _activityShapLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:10 startAngle:0 endAngle:M_PI * 2 - 0.6 clockwise:YES].CGPath;
        _activityShapLayer.strokeColor = [UIColor orangeColor].CGColor;
        _activityShapLayer.fillColor = [UIColor clearColor].CGColor;
        _activityShapLayer.lineWidth = 2;
        _activityShapLayer.position = CGPointMake(15, 15);
    }
    return _activityShapLayer;
}

- (UIView *)loadingView
{
    if (!_loadingView)
    {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 - 15, self.frame.size.height/2 - 15, 30, 30)];
        [_loadingView.layer addSublayer:self.activityShapLayer];
    }
    return _loadingView;
}
@end
