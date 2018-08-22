//
//  MGSimMenuDB.m
//  MaiLianBao
//
//  Created by MapGoo on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGSimMenuDB.h"
#import "FMDB.h"


// 表名字
#define DBTableName @"mgSinMenuTable"

// 表里面的字段名
#define SimType     @"simType"
#define SimPackage  @"simPackage"
#define SimState    @"simState"

static MGSimMenuDB *mgSinMenuDB = nil;
static FMDatabase *db = nil;

@implementation MGSimMenuDB

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mgSinMenuDB = [[self alloc] init];
    });
    
    return mgSinMenuDB;
}

- (instancetype)init
{
    if (self = [super init])
    {
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"MGSinMenuTable.db"];
        NSLog(@"数据库MGSimMenuDB地址==>%@",dbPath);
        
        // 创建数据库
        db = [FMDatabase databaseWithPath:dbPath];
        if (![db open])
        {
            NSLog(@"数据库打开失败");
            return self;
        }
        
        // 创建语句
        NSString *creatTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY NOT NULL,%@ TEXT,%@ TEXT,%@ TEXT)",DBTableName,SimType,SimPackage,SimState];
        
        if (![db executeUpdate:creatTable])
        {
            NSLog(@"建表失败");
        }
        
        [db close];
    }

    return self;
}

- (void)insertModel:(MGSimMenuModel *)model
{
    // 每次存储前删除上一次数据，然后再次insert数据，暂无update操作
    [self deleteAllDataFromDB];
    
    [db open];
    
    // 插入语句
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@) VALUES (?,?,?)",DBTableName,SimType,SimPackage,SimState];
    
    // 模型数组----->字典数组
    NSMutableArray *typeListArray = [MGSimType mj_keyValuesArrayWithObjectArray:model.simFromTypelist];
    NSMutableArray *packageListArray = [MGSimPackage mj_keyValuesArrayWithObjectArray:model.packageList];
    NSMutableArray *simStateListArray = [MGSimState mj_keyValuesArrayWithObjectArray:model.simStatelist];
    
    // 字典数组----->json字符串
    NSString *simFromTypelistJsonStr = [MGDBUtil jsonStrFromArray:typeListArray];
    NSString *packageListJsonStr = [MGDBUtil jsonStrFromArray:packageListArray];
    NSString *simStatelistJsonStr = [MGDBUtil jsonStrFromArray:simStateListArray];
    
    // 执行语句
    if (![db executeUpdate:insertSql, simFromTypelistJsonStr, packageListJsonStr, simStatelistJsonStr])
    {
        NSLog(@"插入失败");
    }
    
    [db close];
}

- (MGSimMenuModel *)getAllDataFromDB
{
    [db open];
    
    // 查询语句
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@", DBTableName];
    FMResultSet *rs = [db executeQuery:selectSql];
    
    MGSimMenuModel *mgSimMenuModel = [[MGSimMenuModel alloc] init];
    
    while ([rs next])
    {
        // 从表中字段获取值
        NSString *simFromTypelistJsonStr =  [rs stringForColumn:SimType];
        NSString *packageListJsonStr = [rs stringForColumn:SimPackage];
        NSString *simStatelistJsonStr = [rs stringForColumn:SimState];
        
        // json字符串----->字典数组
        NSMutableArray *simFromTypeArray = [MGDBUtil arrayFromJsonStr:simFromTypelistJsonStr];
        NSMutableArray *packageArray = [MGDBUtil arrayFromJsonStr:packageListJsonStr];
        NSMutableArray *simStateArray = [MGDBUtil arrayFromJsonStr:simStatelistJsonStr];
     
        // 字典数组----->模型数组
        NSMutableArray *simFromTypeList = [MGSimType mj_objectArrayWithKeyValuesArray:simFromTypeArray];
        NSMutableArray *packageList = [MGSimPackage mj_objectArrayWithKeyValuesArray:packageArray];
        NSMutableArray *simStateList = [MGSimState mj_objectArrayWithKeyValuesArray:simStateArray];
     
        // 给model赋值
        mgSimMenuModel.simFromTypelist = simFromTypeList;
        mgSimMenuModel.packageList = packageList;
        mgSimMenuModel.simStatelist = simStateList;
    }
    
    [db close];
    
    return mgSimMenuModel;
}

- (void)deleteAllDataFromDB
{
    [db open];
    
    // 删除语句(删除表里面的内容，结构不改变)
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@",DBTableName];
    
    // 执行语句
    if (![db executeUpdate:deleteSql])
    {
        NSLog(@"删除失败");
    }
    
    [db close];
}

- (void)dropTableFromDB
{
    [db open];
    
    // 删除语句(删除表的结构以及表的内容)
    NSString *deleteSql = [NSString stringWithFormat:@"DROP TABLE %@",DBTableName];
    
    // 执行语句
    if (![db executeUpdate:deleteSql])
    {
        NSLog(@"删除失败");
    }
    
    [db close];
}


@end
