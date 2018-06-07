//
//  MGUserStatisticListRequest.m
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/12.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGUserStatisticListRequest.h"

@interface MGUserStatisticListRequest()

// 用户ID
@property(nonatomic,assign)NSInteger HoldID;
// 出库日期起
@property(nonatomic,copy)NSString *OutboundDateStart;
// 出库日期止
@property(nonatomic,copy)NSString *OutboundDateStop;
// 选择日期
@property(nonatomic,copy)NSString *SelectMonth;
// 设备IDs
@property(nonatomic,copy)NSString *DeviceIDs;

@end

@implementation MGUserStatisticListRequest

- (instancetype)initWithHoldID:(NSInteger)HoldID
             OutboundDateStart:(NSString *)OutboundDateStart
              OutboundDateStop:(NSString *)OutboundDateStop
                   SelectMonth:(NSString *)SelectMonth
                     DeviceIDs:(NSString *)DeviceIDs
                      delegate:(id<YTKRequestDelegate>)delegate{
    
    if (self = [super init]) {
        
        self.delegate = delegate;
        
        if (OutboundDateStart == nil) {
            OutboundDateStart = @"";
        }
        else if (OutboundDateStop == nil){
            OutboundDateStop = @"";
        }
        else if (DeviceIDs == nil){
            DeviceIDs = @"";
        }
        
        
        self.HoldID = HoldID;
        self.OutboundDateStart = OutboundDateStart;
        self.OutboundDateStop = OutboundDateStop;
        self.SelectMonth = SelectMonth;
        self.DeviceIDs = DeviceIDs;
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return URL_UserStatisticList;
}

- (id)requestArgument
{
    return @{
             @"HoldID":@(self.HoldID),
             @"OutboundDateStart":self.OutboundDateStart,
             @"OutboundDateStop":self.OutboundDateStop,
             @"SelectMonth":self.SelectMonth,
             @"DeviceIDs":self.DeviceIDs
             };
}

@end
