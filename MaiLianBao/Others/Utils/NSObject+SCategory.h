//
//  NSObject+SCategory.h
//  CarTools
//
//  Created by 苏晗 on 16/4/19.
//  Copyright © 2016年 MapGoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SCategory)

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector;

@end
