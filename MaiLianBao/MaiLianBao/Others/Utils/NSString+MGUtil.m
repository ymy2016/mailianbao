//
//  NSString+MGUtil.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/28.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "NSString+MGUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MGUtil)

- (NSString *)mdf_stringByTrimingWhitespaceOrNewlineCharacter
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)mdf_stringByTrimingAllWhitespaces
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)MD5String
{
    //转换成utf-8
    const char *cStr = [self UTF8String];
    
    //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
    CC_MD5( cStr, (int)strlen(cStr), result );
    
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        //x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
        [hash appendFormat:@"%02x",result[i]];
    }
    return hash;
}



+ (NSAttributedString *)underLineWithStr:(NSString *)str
                               textColor:(UIColor *)textColor
                                textFont:(UIFont *)textFont
{
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange mRange = {0,[mStr length]};
    [mStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:mRange];
    [mStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textColor,
                         NSForegroundColorAttributeName,
                         textFont,
                         NSFontAttributeName,nil] range:mRange];
    
    return mStr;
}

+ (NSString *)timestamp
{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

@end
