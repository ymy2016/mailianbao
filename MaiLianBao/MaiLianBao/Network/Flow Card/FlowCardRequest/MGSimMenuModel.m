//
//  MGSimMenuModel.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGSimMenuModel.h"

@implementation MGSimType

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"simFromType" : @"id"
             };
}

@end

@implementation MGSimPackage
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"name" : @"packageName"
             };
}
@end

@implementation MGSimState

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"stateId" : @"id"
             };
}

@end

@implementation MGSimMenuModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"simFromTypelist" : @"MGSimType",
             @"packageList" : @"MGSimPackage",
             @"simStatelist" : @"MGSimState"
             };
}

- (SimCardType)typeWithName:(NSString *)name
{
    for (MGSimType *sim in self.simFromTypelist)
    {
        if ([sim.name isEqualToString:name])
        {
            return sim.simFromType;
        }
    }
    return SimCardForNULL;
}

- (NSNumber *)stateTypeWithName:(NSString *)name
{
    for (MGSimState *state in self.simStatelist)
    {
        if ([state.name isEqualToString:name]) {
            return @(state.stateId);
        }
    }
    return NULL;
}

- (NSArray *)packageTypeWithName:(NSArray *)nameArray type:(SimCardType)type
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *filterArray = [NSMutableArray array];
    
    for (int i = 0; i < [self.packageList count]; i++)
    {
        MGSimPackage *package = self.packageList[i];
        if (package.simFromType == type)
        {
            [filterArray addObject:package];
        }
    }
    
    for (int i = 0; i < filterArray.count; i++)
    {
        MGSimPackage *p = filterArray[i];

        if ([nameArray containsObject:p.name])
        {
            [array addObject:@(p.packageId)];
        }
    }
    
    return array;
}

- (NSMutableArray *)simData
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (0 != self.simFromTypelist.count)
    {
        for (MGSimType *sim in self.simFromTypelist)
        {
            [array addObject:sim.name];
        }
        return array;
    }
    return [NSMutableArray arrayWithObject:@"类型"];
}

- (NSMutableArray *)packageDataWithType:(SimCardType)type
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (0 != self.packageList.count)
    {
        for (MGSimPackage *package in self.packageList)
        {
            if (package.simFromType == type)
            {
                [array addObject:package.name];
            }
        }
        return array;
    }
    return [NSMutableArray arrayWithObject:@"全部"];
}

- (NSMutableArray *)stateDataWithType:(SimCardType)type
{
    NSMutableArray *array = [NSMutableArray arrayWithObject:@"全部"];
    
    for (MGSimState * state in self.simStatelist)
    {
        if (state.simFromType == type)
        {
            [array addObject:state.name];
        }
    }
    return array;
}

- (void)filterWithType:(SimCardType)type result:(void (^)(NSMutableArray *, NSMutableArray *))result
{
    NSMutableArray *packages = [self packageDataWithType:type];
    NSMutableArray *states = [self stateDataWithType:type];
    
    result(packages, states);
    
}
@end
