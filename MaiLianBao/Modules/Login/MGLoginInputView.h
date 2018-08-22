//
//  MGLoginInputView.h
//  MaiLianBao
//
//  Created by 谭伟华 on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGLoginInputView : UIView

@property(nonatomic,strong) UITextField *inputTf;

- (instancetype)initWithFrame:(CGRect)frame
                      leftImg:(NSString *)leftImg
           rightTfPlaceholder:(NSString *)rightTfPlaceholder;

@end
