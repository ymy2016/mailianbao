//
//  YTKBaseRequest+JudgeMent.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "YTKBaseRequest.h"

@interface YTKBaseRequest (JudgeMent)

/// 批量请求，具体某个请求成功的情况
+ (void)requestArray:(__kindof NSArray *)requestArray
        successBlock:(void(^)(__kindof NSDictionary *dic))successBlock;

/// 批量请求，具体某个请求失败的情况
+ (void)requestArray:(__kindof NSArray *)requestArray
           failBlock:(void(^)(__kindof NSString *reason))failBlock;

/// 批量请求，请求成功与失败的情况
+ (void)requestArray:(__kindof NSArray *)requestArray
        successBlock:(void(^)(__kindof NSDictionary *dic))successBlock
           failBlock:(void(^)(__kindof NSString *reason))failBlock;


/// 单个请求，成功情况
- (void)requestSuccessBlock:(void(^)(__kindof NSDictionary *dic))successBlock;

/// 单个请求，失败情况
- (void)requestFailBlock:(void(^)(__kindof NSString *reason))failBlock;

/// 单个请求，成功与失败情况
- (void)requestSuccessBlock:(void(^)(__kindof NSDictionary *dic))successBlock
                  failBlock:(void(^)(__kindof NSString *reason))failBlock;

@end
