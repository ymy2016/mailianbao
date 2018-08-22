//
//  MGAlertUtil.m
//  MaiLianBao
//
//  Created by MapGoo on 16/8/5.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGAlertUtil.h"

@implementation MGAlertUtil

// 用于一个选项的AlertView的显示(最简模式)
+ (void)mg_alertWithTitle:(NSString *)title
          superController:(UIViewController *)superController
       sureBtnActionBlock:(void(^)())sureBtnActionBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (sureBtnActionBlock)
        {
            sureBtnActionBlock();
        }
        
    }];
    [alert addAction:Action];
    
    [superController presentViewController:alert animated:YES completion:nil];
}


// 用于两个选项的AlertView的显示
+ (void)mg_alertTwoWithTitle:(NSString *)title
                  leftBtnStr:(NSString *)leftBtnStr
                 rightBtnStr:(NSString *)rightBtnStr
             superController:(UIViewController *)superController
          leftBtnActionBlock:(void(^)())leftBtnActionBlock
         rightBtnActionBlock:(void(^)())rightBtnActionBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftBtnStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (leftBtnActionBlock)
        {
             leftBtnActionBlock();
        }

    }];
    [alert addAction:leftAction];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightBtnStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (rightBtnActionBlock)
        {
            rightBtnActionBlock();
        }
        
    }];
    [alert addAction:rightAction];
    
    [superController presentViewController:alert animated:YES completion:nil];
    
}

// 用于一个选项的ActionSheet的显示(最简模式)
+ (void)mg_actionsOneWithTitle:(NSString *)title
                        btnStr:(NSString *)btnStr
               superController:(UIViewController *)superController
                btnActionBlock:(void(^)())btnActionBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:btnStr style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (btnActionBlock)
        {
           btnActionBlock();
        }
        
    }];
    [alert addAction:Action];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [superController presentViewController:alert animated:YES completion:nil];
}

// 用于两个选项的ActionSheet的显示
+ (void)mg_actionsTwoWithTitle:(NSString *)title
                     topBtnStr:(NSString *)topBtnStr
                  bottomBtnStr:(NSString *)bottomBtnStr
               superController:(UIViewController *)superController
             topBtnActionBlock:(void(^)())topBtnActionBlock
          bottomBtnActionBlock:(void(^)())bottomBtnActionBlock

{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *topAction = [UIAlertAction actionWithTitle:topBtnStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (topBtnActionBlock)
        {
            topBtnActionBlock();
        }
        
    }];
    [alert addAction:topAction];
    
    UIAlertAction *bottomAction = [UIAlertAction actionWithTitle:bottomBtnStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (bottomBtnActionBlock)
        {
            bottomBtnActionBlock();
        }
        
    }];;
    [alert addAction:bottomAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [superController presentViewController:alert animated:YES completion:nil];
    
}

// 用于三个选项的ActionSheet的显示
+ (void)mg_actionsThreeActionsWithTitle:(NSString *)title
                              topBtnStr:(NSString *)topBtnStr
                           middelBtnStr:(NSString *)middleBtnStr
                           bottomBtnStr:(NSString *)bottomBtnStr
                        superController:(UIViewController *)superController
                      topBtnActionBlock:(void(^)())topBtnActionBlock
                      midBtnActionBlock:(void(^)())midBtnActionBlock
                   bottomBtnActionBlock:(void(^)())bottomBtnActionBlock;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *topAction = [UIAlertAction actionWithTitle:topBtnStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (topBtnActionBlock)
        {
            topBtnActionBlock();
        }
        
    }];
    [alert addAction:topAction];
    
    UIAlertAction *middleAction = [UIAlertAction actionWithTitle:middleBtnStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (midBtnActionBlock)
        {
            midBtnActionBlock();
        }
        
    }];
    [alert addAction:middleAction];
    
    UIAlertAction *bottomAction = [UIAlertAction actionWithTitle:bottomBtnStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (bottomBtnActionBlock)
        {
            bottomBtnActionBlock();
        }
        
    }];
    [alert addAction:bottomAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [superController presentViewController:alert animated:YES completion:nil];
    
}

@end
