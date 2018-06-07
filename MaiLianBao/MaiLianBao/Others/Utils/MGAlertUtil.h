//
//  MGAlertUtil.h
//  MaiLianBao
//
//  Created by MapGoo on 16/8/5.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MGAlertUtil : NSObject

/// 用于一个选项的AlertView的显示(最简模式)
+ (void)mg_alertWithTitle:(NSString *)title
          superController:(UIViewController *)superController
       sureBtnActionBlock:(void(^)())sureBtnActionBlock;

/// 用于两个选项的AlertView的显示
+ (void)mg_alertTwoWithTitle:(NSString *)title
                  leftBtnStr:(NSString *)leftBtnStr
                 rightBtnStr:(NSString *)rightBtnStr
             superController:(UIViewController *)superController
          leftBtnActionBlock:(void(^)())leftBtnActionBlock
         rightBtnActionBlock:(void(^)())rightBtnActionBlock;

/// 用于一个选项的ActionSheet的显示(最简模式)
+ (void)mg_actionsOneWithTitle:(NSString *)title
                        btnStr:(NSString *)btnStr
               superController:(UIViewController *)superController
                btnActionBlock:(void(^)())btnActionBlock;

/// 用于两个选项的ActionSheet的显示
+ (void)mg_actionsTwoWithTitle:(NSString *)title
                     topBtnStr:(NSString *)topBtnStr
                  bottomBtnStr:(NSString *)bottomBtnStr
               superController:(UIViewController *)superController
             topBtnActionBlock:(void(^)())topBtnActionBlock
          bottomBtnActionBlock:(void(^)())bottomBtnActionBlock;

/// 用于三个选项的ActionSheet的显示
+ (void)mg_actionsThreeActionsWithTitle:(NSString *)title
                       topBtnStr:(NSString *)topBtnStr
                    middelBtnStr:(NSString *)middleBtnStr
                    bottomBtnStr:(NSString *)bottomBtnStr
                 superController:(UIViewController *)superController
               topBtnActionBlock:(void(^)())topBtnActionBlock
               midBtnActionBlock:(void(^)())midBtnActionBlock
            bottomBtnActionBlock:(void(^)())bottomBtnActionBlock;

@end
