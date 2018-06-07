//
//  UITextField+SCategory.h
//  ownerBusiness
//
//  Created by 苏晗 on 15/6/27.
//  Copyright (c) 2015年 MapGoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShakeDirection) {
    ShakeDirectionHorizontal = 0,
    ShakeDirectionVertical
};

@interface UITextField (SCategory)

/**
 *  限制TextField输入字符长度
 *
 *  @param length 字符长度
 */
- (void)limitTextLength:(int)length;


@end
