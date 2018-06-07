//
//  MGFormartUtil.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/28.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGFormartUtil.h"

static MGFormartUtil *sharedInstance = nil;
// 记录位置,对3取余为0，则添加一个逗号
static NSInteger recordPosition = 0;

@implementation MGFormartUtil

+ (MGFormartUtil *)sharedInstance
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[MGFormartUtil alloc] init];
    });
    
    return sharedInstance;
}

- (NSString *(^)(CGFloat num))floatToStr
{
    return ^NSString *(CGFloat num){
       
        NSString *str = [NSString stringWithFormat:@"%f",num];
        return str;
    };
}


- (NSString *(^)(CGFloat num))money
{
    return ^NSString *(CGFloat num){
       
        // 默认情况，保留小数后面两位
        NSMutableString *moneyStr = [NSMutableString stringWithFormat:@"%.1f",num];
        // 大于6位，格式化才有意义
        if (moneyStr.length >= 6)
        {
            // 反向遍历字符串
            for (NSInteger i = moneyStr.length - 3;i > 0 ;i--)
            {
                // 单个字符串截取
                // NSString *singleChar = [moneyStr substringWithRange:NSMakeRange(i-1, 1)];

                recordPosition++;
                
                if (recordPosition % 3 == 0 && (i-1) != 0)
                {
                    [moneyStr insertString:@"," atIndex:i-1];
                }

            }
            recordPosition = 0;
            moneyStr = [NSMutableString stringWithFormat:@"¥ %@",moneyStr];
            return moneyStr;
        }
        else
        {
            moneyStr = [NSMutableString stringWithFormat:@"¥ %.f",num];
            return moneyStr;
        }
    };
}

- (NSString *(^)(CGFloat num))num
{
    return ^NSString *(CGFloat num){
        
        // 默认情况，是整数形式
        NSMutableString *moneyStr = [NSMutableString stringWithFormat:@"%.f",num];
        // 大于0位，格式化才有意义
        if (moneyStr.length > 0)
        {
            // 反向遍历字符串
            for (NSInteger i = moneyStr.length;i > 0 ;i--)
            {
                // 单个字符串截取
                // NSString *singleChar = [moneyStr substringWithRange:NSMakeRange(i-1, 1)];
                
                recordPosition++;
                
                if (recordPosition % 3 == 0 && (i-1) != 0)
                {
                    [moneyStr insertString:@"," atIndex:i-1];
                }
                
            }
            recordPosition = 0;
            moneyStr = [NSMutableString stringWithFormat:@"%@",moneyStr];
            return moneyStr;
        }
        else
        {
            moneyStr = [NSMutableString stringWithFormat:@"%f",num];
            return moneyStr;
        }
    };

}

- (NSMutableAttributedString *(^)(CGFloat num))orangeNum
{
    
    return ^NSMutableAttributedString *(CGFloat num){
    
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.num(num)];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                       value:[UIColor orangeColor]
                                      range:NSMakeRange(0,attributedStr.length)];
        
        return attributedStr;
    };
  
}


+ (NSString *)countNumAndChangeformat:(NSInteger)num
{
    int count = 0;
    long long int a = num;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",@(num)]];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    return newstring;
}

//每隔n个字符添加一个空格的字符串算法
+ (NSString *)dealWithString:(NSString *)number length:(NSInteger)length
{
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < number.length; i++) {
        
        count++;
        doneTitle = [doneTitle stringByAppendingString:[number substringWithRange:NSMakeRange(i, 1)]];
        if (count == length) {
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
            
        }
    }
    return [doneTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
