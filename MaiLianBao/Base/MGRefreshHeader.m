//
//  MGRefreshHeader.m
//  OBDApp
//
//  Created by 苏晗 on 15/12/3.
//  Copyright © 2015年 MapGoo. All rights reserved.
//

#import "MGRefreshHeader.h"

@interface MGRefreshHeader()
@property (nonatomic, weak) UILabel * label;
@property (nonatomic, weak) UILabel * timeLabel;
@property (nonatomic, strong) UIImageView * arrowView;
@property (nonatomic, weak) UIActivityIndicatorView * activityIndicatorView;
@end

@implementation MGRefreshHeader

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImage * image = [UIImage imageNamed:@"refresh_arrow"];
        _arrowView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_arrowView];
    }
    return _arrowView;
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件高度
    self.mj_h = AdaptH(64);
    
    // 添加Label
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13.f];
    label.textColor = UIColorFromRGB(0x666666);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 1;
    
    [self addSubview:label];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:11.f];
    timeLabel.textColor = UIColorFromRGB(0x666666);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.numberOfLines = 1;
    [self addSubview:timeLabel];
    
    UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityIndicatorView];
    
    self.label = label;
    self.timeLabel = timeLabel;
    self.activityIndicatorView = activityIndicatorView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = CGRectMake((self.mj_w - AdaptW(150))/2, AdaptH(10), AdaptW(150), (self.mj_h - AdaptH(20)) * 0.5);
    
    self.timeLabel.frame = CGRectMake(self.label.left, self.label.bottom, self.label.width, self.label.height);
    
    self.activityIndicatorView.center = CGPointMake(self.label.left - self.activityIndicatorView.width, self.mj_h * 0.5);
    
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center =  CGPointMake(self.label.left - self.arrowView.width, self.height * 0.5);
    }
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    // 重新设置key（重新显示时间）
    self.lastUpdatedTimeKey = self.lastUpdatedTimeKey;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            if (oldState == MJRefreshStateRefreshing) {
                self.arrowView.transform = CGAffineTransformIdentity;
                
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    self.activityIndicatorView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                    if (self.state != MJRefreshStateIdle) return;
                    
                    self.activityIndicatorView.alpha = 1.0;
                    [self.activityIndicatorView stopAnimating];
                    self.label.text = @"下拉开始刷新...";
                    self.arrowView.hidden = NO;
                }];
            } else {
                [self.activityIndicatorView stopAnimating];
                self.label.text = @"下拉开始刷新...";
                self.arrowView.hidden = NO;
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    self.arrowView.transform = CGAffineTransformIdentity;
                }];
            }
        }
            break;
        case MJRefreshStatePulling:
        {
            [self.activityIndicatorView stopAnimating];
            self.label.text = @"释放开始刷新...";
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.activityIndicatorView.alpha = 1.0;
            [self.activityIndicatorView startAnimating];
            self.label.text = @"刷新中...";
            self.arrowView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    
    // 如果label隐藏了，就不用再处理
    if (self.timeLabel.hidden) return;
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.timeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [self currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @"今天 HH:mm";
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        // 3.显示日期
        self.timeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
    } else {
        self.timeLabel.text = @"最后更新：无记录";
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}

- (void)setFontColor:(UIColor *)fontColor
{
    _fontColor = fontColor;
    
    self.timeLabel.textColor = _fontColor;
    
    self.label.textColor = _fontColor;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.activityIndicatorView.activityIndicatorViewStyle = _activityIndicatorViewStyle;
}

- (void)setArrowImage:(UIImage *)arrowImage
{
    _arrowImage = arrowImage;
    
    [self.arrowView setImage:_arrowImage];
}
@end
