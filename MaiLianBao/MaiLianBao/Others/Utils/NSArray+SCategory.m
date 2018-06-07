//
//  NSArray+SCategory.m
//  CarTools
//
//  Created by 苏晗 on 16/4/19.
//  Copyright © 2016年 MapGoo. All rights reserved.
//

#import "NSArray+SCategory.h"
#import "NSObject+SCategory.h"

@implementation NSArray (SCategory)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj2 = NSClassFromString(@"__NSArrayI");
        [obj2 swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex:)];
    });
}

- (id)safeObjectAtIndex:(NSInteger)index
{
    if(index<[self count]){

        return [self safeObjectAtIndex:index];
    }else{
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~数组读取越界!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    }
    return nil;
}

@end
