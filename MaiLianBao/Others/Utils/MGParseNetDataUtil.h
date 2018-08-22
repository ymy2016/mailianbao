//
//  MGParseNetDataUtil.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/27.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NetParse [MGParseNetDataUtil sharedInstance]

@interface MGParseNetDataUtil : NSObject

+ (MGParseNetDataUtil *)sharedInstance;

/// 解析error
- (NSInteger (^)(NSDictionary *dic))error;

/// 解析reason
- (NSString *(^)(NSDictionary *dic))reason;

/// 解析result
- (NSDictionary *(^)(NSDictionary *dic))result;

@end
