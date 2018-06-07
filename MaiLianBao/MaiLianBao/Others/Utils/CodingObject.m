//
//  CodingObject.m
//  TestKVCObj
//
//  Created by solesson on 17/11/15.
//  Copyright © 2015年 LBS. All rights reserved.
//

#import "CodingObject.h"
#import <objc/runtime.h>

@implementation CodingObject

/**
 runtime:
 
 相关函数:
 1.objc_msgSend:给对象发消息
 2.class_copyMethodList:遍历某个类所有的方法
 3.class_copyIvarList:遍历某个类所有的成员变量
 
 必备常识：
 1.Ivar: 成员变量
 2.Methord:成员方法
 
 */

//解档。 从coder中读取数据，保存到相应的变量中，即反序列化数据
- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        unsigned int count = 0;
        //获取类中所有成员变量名
        Ivar *ivar = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            //进行解档取值
            id value = [decoder decodeObjectForKey:strName];
            //利用KVC,设到成员变量身上
            [self setValue:value forKey:strName];
            
        }
        free(ivar);
    }
    return self;
}

//归档。读取实例变量，并把这些数据写到coder中去。序列化数据
- (void)encodeWithCoder:(NSCoder *)encoder{
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        //利用KVC取值
        id value = [self valueForKey:strName];
        [encoder encodeObject:value forKey:strName];
    }
    free(ivar);
}

@end
