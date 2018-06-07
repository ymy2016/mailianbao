//
//  MGMineGetUrlRequest.h
//  MaiLianBao
//
//  Created by 伟华 on 17/1/11.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGMineGetUrlRequest : MGRequest

- (instancetype)initWithUid:(int)uid
                      image:(NSString *)image
                   delegate:(id<YTKRequestDelegate>)delegate;

@end
