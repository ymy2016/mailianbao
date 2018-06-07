//
//  MGLeftMenuRequest.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGLeftMenuRequest.h"

@interface  MGLeftMenuRequest()

@property(nonatomic,assign)NSInteger holdId;

@end

@implementation MGLeftMenuRequest

- (instancetype)initWithHoldId:(NSInteger)holdId
                      delegate:(id<YTKRequestDelegate>)delegate
{
    if (self = [super init])
    {
        self.delegate = delegate;
        _holdId = holdId;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return URL_LeftMenu;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

- (id)requestArgument
{
    return @{
             @"holdId":@(_holdId)
             };
}

@end
