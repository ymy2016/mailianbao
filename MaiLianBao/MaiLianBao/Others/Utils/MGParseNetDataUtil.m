//
//  MGParseNetDataUtil.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/27.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGParseNetDataUtil.h"

static MGParseNetDataUtil *sharedInstance = nil;

@implementation MGParseNetDataUtil

+ (MGParseNetDataUtil *)sharedInstance
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[MGParseNetDataUtil alloc] init];
    });

    return sharedInstance;
}

- (NSInteger (^)(NSDictionary *dic))error
{
    return ^NSInteger (NSDictionary *dic){
    
        NSNumber *eNum = dic[@"error"];
        NSInteger eInt = [eNum integerValue];
        
        return eInt;
    };
}

- (NSString *(^)(NSDictionary *dic))reason
{
    return ^NSString * (NSDictionary *dic){
        
        NSString *rStr = dic[@"reason"];
        
        return rStr;
    };
}

- (NSDictionary *(^)(NSDictionary *dic))result
{
    return ^NSDictionary *(NSDictionary *dic){
        
        NSDictionary *result = dic[@"result"];
        
        return result;
    };
}

@end
