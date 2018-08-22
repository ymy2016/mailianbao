//
//  NSData+SCategory.h
//  
//
//  Created by 苏晗 on 15/7/3.
//  Copyright (c) 2015年 MapGoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSData (SCategory)


@property (nonatomic, readonly) NSString* md5Hash;

@property (nonatomic, readonly) NSString* sha1Hash;

+ (id)dataWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;

@end
