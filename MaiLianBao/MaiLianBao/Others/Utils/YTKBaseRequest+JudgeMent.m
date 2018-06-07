//
//  YTKBaseRequest+JudgeMent.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "YTKBaseRequest+JudgeMent.h"
#import "MGSerLoginViewController.h"

#define NetWork_DisConnect @"网络连接异常"
#define NetWork_TokenExpire @"Token已过期"
#define NetWork_RequestFailed @"请求失败"

@implementation YTKBaseRequest (JudgeMent)

+ (void)requestArray:(__kindof NSArray *)requestArray
        successBlock:(void(^)(__kindof NSDictionary *dic))successBlock
{
    [self requestArray:requestArray successBlock:^(__kindof NSDictionary *dic) {
        
        successBlock?successBlock(dic):nil;
        
    } failBlock:nil];
}

+ (void)requestArray:(__kindof NSArray *)requestArray
           failBlock:(void(^)(__kindof NSString *reason))failBlock
{
    [self requestArray:requestArray successBlock:nil failBlock:^(__kindof NSString *reason) {
        
        failBlock?failBlock(reason):nil;
        
    }];
}

+ (void)requestArray:(__kindof NSArray *)requestArray
        successBlock:(void(^)(__kindof NSDictionary *dic))successBlock
           failBlock:(void(^)(__kindof NSString *reason))failBlock
{
    
    for (YTKBaseRequest *request in requestArray)
    {
        if ([request isKindOfClass:self])
        {
            // Token过期的情况
            if (request.responseStatusCode == 401)
            {
            
//                failBlock?failBlock(NetWork_TokenExpire):nil;
//                
//                UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//                
//                [MGAlertUtil mg_alertWithTitle:NetWork_TokenExpire superController:currentVC sureBtnActionBlock:^{
//                    MGLoginViewController *mgRootVC = [[MGLoginViewController alloc] init];
//                    [UIApplication sharedApplication].keyWindow.rootViewController = mgRootVC;
//                }];
//                
//                break;
            }
            // 请求成功，数据返回成功的情况
            else if (request.responseJSONObject != nil)
            {
                NSDictionary *dic = request.responseJSONObject;
                NSString *reason = NetParse.reason(dic);
                if (NetParse.error(dic) == 0)
                {
                    successBlock?successBlock(dic):nil;
                }
                else if (NetParse.error(dic) != 0)
                {
                    failBlock?failBlock(reason):nil;
                }
            }
            // 其余情况，全部归为“网络请求失败”
            else
            {
                failBlock?failBlock(NetWork_RequestFailed):nil;
            }
        }
    }
}


- (void)requestSuccessBlock:(void (^)(__kindof NSDictionary *dic))successBlock
{
    
    [self requestSuccessBlock:^(__kindof NSDictionary *dic) {
        
        successBlock?successBlock(dic):nil;
        
    } failBlock:nil];
    
}

- (void)requestFailBlock:(void (^)(__kindof NSString *reason))failBlock
{
    
    [self requestSuccessBlock:nil failBlock:^(__kindof NSString *reason) {
        
        failBlock?failBlock(reason):nil;
    }];
    
}

- (void)requestSuccessBlock:(void (^)(__kindof NSDictionary *dic))successBlock
                  failBlock:(void (^)(__kindof NSString *reason))failBlock
{
    // Token过期的情况
    if (self.responseStatusCode == 401)
    {
        
//        failBlock?failBlock(NetWork_TokenExpire):nil;
//        
//        UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//        
//        [MGAlertUtil mg_alertWithTitle:NetWork_TokenExpire superController:currentVC sureBtnActionBlock:^{
//            
//            MGLoginViewController *mgRootVC = [[MGLoginViewController alloc] init];
//            [UIApplication sharedApplication].keyWindow.rootViewController = mgRootVC;
//        }];
        
    }
    // 请求成功，数据返回成功的情况
    else if (self.responseJSONObject != nil)
    {
        NSDictionary *dic = self.responseJSONObject;
        NSString *reason = NetParse.reason(dic);
        
        if (NetParse.error(dic) == 0)
        {
            successBlock?successBlock(dic):nil;
        }
        else if (NetParse.error(dic) != 0)
        {
            failBlock?failBlock(reason):nil;
        }
    }
    // 其余情况，全部归为“网络请求失败”
    else
    {
        failBlock?failBlock(NetWork_RequestFailed):nil;
    }
    
}

@end
