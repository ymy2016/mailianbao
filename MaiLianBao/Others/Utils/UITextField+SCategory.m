//
//  UITextField+SCategory.m
//  ownerBusiness
//
//  Created by 苏晗 on 15/6/27.
//  Copyright (c) 2015年 MapGoo. All rights reserved.
//

#import "UITextField+SCategory.h"
#import <objc/runtime.h>

@implementation UITextField (SCategory)

static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";

// 限制TextField输入字符长度
- (void)limitTextLength:(int)length
{
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(id)sender
{
    NSNumber *lengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey));
    int length = [lengthNumber intValue];
    if(self.text.length > length){
        self.text = [self.text substringToIndex:length];
    }
}

@end
