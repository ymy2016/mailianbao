//
//  NSString+SCategory.m
//  
//
//  Created by TFT_SuHan on 15/4/21.
//  Copyright (c) 2015年 MapGoo. All rights reserved.
//

#import "NSString+SCategory.h"
#import "NSData+SCategory.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation NSString (SCategory)

// 计算字符串宽度
- (CGSize)boundingRectWithSize:(CGSize)contentSize andFont:(UIFont *)font
{
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [self boundingRectWithSize:contentSize
                                      options: NSStringDrawingTruncatesLastVisibleLine |
                                               NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingUsesFontLeading
                                   attributes:attribute
                                      context:nil].size;
    return size;
}

- (NSString*)md5Hash
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

- (NSString*)sha1Hash
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}

// 检测字符串中是否有空白符和换行符
- (BOOL)isWhitespaceAndNewlines
{
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

// URL 编码
- (id)urlEncoded
{
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)self,NULL,
                                                                             (CFStringRef)@"!#$%&'()*+,/:;=?@[]",kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString *)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

// 移除string中所有的HTML标签
- (NSString*)stringByRemovingHTMLTags
{
    NSString *regexStr =@"<[^>]+>";
    
    NSError* error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSString *result = [regex stringByReplacingMatchesInString:self
                                                       options:0
                                                         range:NSMakeRange(0, self.length)
                                                  withTemplate:@""];
    
    return result;
}

// 验证字符串是否为空
- (BOOL)isNotNil
{
    if (self == nil || (id)self == [NSNull null] || [self isEqualToString:@""] || [self isEqualToString:@" "])
        return NO;
    
    return YES;
}

//去掉两边空格
-(NSString *)TrimString
{
    if (self == nil || [self isEqual:[NSNull null]])
    {
        return  @"";
    }
    
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

//把带有中文字符的转换格式
+(NSString *)StringFormatURLEncode:(NSString *)pStr, ...
{
    va_list ap;
    va_start(ap, pStr);
    NSString *title = [[NSString alloc]initWithFormat:pStr arguments:ap];
    va_end(ap);
    
    return [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/** 直接传入精度丢失有问题的Double类型*/
+ (NSString *)decimalNumberWithDouble:(double)conversionValue
{
    NSString *doubleString        = [NSString stringWithFormat:@"%0.1f", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

// 获取当前连接的WiFi
+ (NSString *)GetCurrentWifiHotSpotName
{
    NSString *wifiName = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs)
    {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"])
        {
            wifiName = info[@"SSID"];
        }
    } return wifiName;
}

// Base64编码
+ (NSString *)base64StringFromText:(NSString *)text
{
    NSAssert(text.length != 0, @"进行Base64编码的字符串不能为空");
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    
    return base64String;
}

// Base64解码
+ (NSString *)textFromBase64String:(NSString *)text
{
    /*
      NSAssert(<#condition#>, <#desc, ...#>),当不满足condition条件的时候，且在有全局断点的情况下，全局断点会跟踪到此，控制台抛出程序奔溃的描述为desc...
    */
    NSAssert(text.length != 0, @"进行Base64解码的字符串不能为空");
    
    NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:text options:0];
    
    NSString *base64Decoded = [[NSString alloc] initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    
    return base64Decoded;
}

//获取路由器的Mac地址
+ (NSString *)GetCurrentWifiMacAddress {
    
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    
    NSDictionary *info = nil;
    
    for (NSString *ifnam in ifs) {
        
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            
            break;
        }
    }
    return info[@"BSSID"];
}

+ (NSString *)timestamp
{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

//获取ip地址
+ (NSString *)getIpAddresses
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end


