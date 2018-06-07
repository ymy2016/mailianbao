//
//  MGLeftMenuRequest.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGLeftMenuRequest : MGRequest

- (instancetype)initWithHoldId:(NSInteger)holdId
                      delegate:(id<YTKRequestDelegate>)delegate;

@end
