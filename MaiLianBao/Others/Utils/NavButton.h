//
//  NavButton.h
//  Marvoto
//
//  Created by 谭伟华 on 16/5/18.
//  Copyright © 2016年 LBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavLeftBtnDelegate <NSObject>

@optional

- (void)back;

@end

@interface NavButton : UIBarButtonItem

@property (nonatomic, copy)void((^btnBlock)());

@property (nonatomic,weak) id<NavLeftBtnDelegate>delegate;

/// 文字模式导航左侧按钮，block形式
- (instancetype)initWithBtnStr:(NSString *)btnStr btnActionBlock:(void(^)())btnActionBlock;

/// 图片模式导航左侧按钮，block形式
- (instancetype)initWithBtnImg:(NSString *)btnImg btnActionBlock:(void(^)())btnActionBlock;

/// 图片模式导航左侧按钮，delegate形式
- (instancetype)initWithBtnImg:(NSString *)btnImg delegate:(id<NavLeftBtnDelegate>)delegate;

@end
