//
//  MGUserStatisticListRequest.h
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/12.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGUserStatisticListRequest : MGRequest

- (instancetype)initWithHoldID:(NSInteger)HoldID
             OutboundDateStart:(NSString *)OutboundDateStart
              OutboundDateStop:(NSString *)OutboundDateStop
                   SelectMonth:(NSString *)SelectMonth
                     DeviceIDs:(NSString *)DeviceIDs
                      delegate:(id<YTKRequestDelegate>)delegate;

@end
