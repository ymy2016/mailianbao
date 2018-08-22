//
//  MGUserStatisticRequest.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/3.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGUserStatisticRequest.h"

@interface MGUserStatisticRequest()

@property(nonatomic,assign)NSInteger holdId;

@property(nonatomic,copy)NSString *starMonth;

@end

@implementation MGUserStatisticRequest

- (instancetype)initWithHoldId:(NSInteger)holdId
                     starMonth:(NSString *)starMonth
                      delegate:(id<YTKRequestDelegate>)delegate{
    
    if (self = [super init])
    {
        self.delegate = delegate;

        self.holdId = holdId;
        self.starMonth = starMonth;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

- (NSString *)requestUrl
{
    return URL_UserStatisticInit;
}

- (id)requestArgument
{
    return @{
             @"holdId":@(self.holdId),
             @"starMonth":self.starMonth
             };
}

@end
