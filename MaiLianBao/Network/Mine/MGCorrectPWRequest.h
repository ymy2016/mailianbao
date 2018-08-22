//
//  MGCorrectPWRequest.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/27.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGCorrectPWRequest : MGRequest

- (instancetype)initWithUserId:(NSInteger)userId
                   OldPassword:(NSString *)oldPassword
                   newPassword:(NSString *)newPassword
                      showTips:(NSString *)showTips
                      delegate:(id<YTKRequestDelegate>)delegate;

@end
