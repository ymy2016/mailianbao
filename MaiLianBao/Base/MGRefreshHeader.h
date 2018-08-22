//
//  MGRefreshHeader.h
//  OBDApp
//
//  Created by 苏晗 on 15/12/3.
//  Copyright © 2015年 MapGoo. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface MGRefreshHeader : MJRefreshHeader

/** 利用这个block来决定显示的更新时间文字 */
@property (copy, nonatomic) NSString *(^lastUpdatedTimeText)(NSDate *lastUpdatedTime);

/** 文字颜色 */
@property (nonatomic, strong) UIColor *fontColor;
/** 菊花样式 */
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, strong) UIImage *arrowImage;

@end
