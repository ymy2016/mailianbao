//
//  MGUserStatisticRequest.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/3.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGUserStatisticRequest : MGRequest

- (instancetype)initWithHoldId:(NSInteger)holdId
                     starMonth:(NSString *)starMonth
                      delegate:(id<YTKRequestDelegate>)delegate;

@end
