//
//  DiaryService.m
//  diary
//
//  Created by 谢春平 on 2017/7/7.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiaryService.h"
#import "FileUtils.h"
#import "BaseUtils.h"

@implementation DiaryService

static FMDatabase *db;
@dynamic count;
@dynamic lastId;
//构造方法
-(id) init{
	self=[super init];
	if(self){
		isOverwrite=NO;
		dbName=@"diary.db";
		status=[DiaryService initDb:dbName overwrite:isOverwrite];
	}
	return self;
}

//初始化数据库
+(BOOL)initDb:(NSString *)dbName overwrite:(BOOL)isOverwrite{
	static BOOL cStatus;
	static dispatch_once_t onceInitDb;
    dispatch_once(&onceInitDb, ^{
        if (db == nil) {
			NSArray *dbNames=[dbName componentsSeparatedByString:@"."];
			NSString *srcPath = [[NSBundle bundleForClass:[self class]] pathForResource:[dbNames objectAtIndex:0] ofType:[dbNames objectAtIndex:1]];
			NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
			NSString *targetPath = [documentDirectory stringByAppendingPathComponent:dbName];
			NSLog(@"%@\n",targetPath);
			[FileUtils copyFile:srcPath target:targetPath overwrite:isOverwrite];
            db = [FMDatabase databaseWithPath:targetPath];
			cStatus=[db open];
        }
    });
	return cStatus;
}

//插入数据
-(NSInteger)insert:(DiaryModel *)diary{
	NSString *insertSQL=@"insert into diary (title,subtitle,content,weather,emote,addtime,edittime,sync_id) "
						 "values(:title,:subtitle,:content,:weather,:emote,:addtime,:edittime,:sync_id)";
	[db executeUpdate:insertSQL withParameterDictionary:diary.keyValues];
	return self.lastId;
}

//更新数据
-(BOOL)update:(DiaryModel *)diary{
	NSString *updateSQL=@"update diary set title=:title,subtitle=:subtitle,content=:content,weather=:weather,emote=:emote,edittime=:edittime "
						 "where id=:id";
	return [db executeUpdate:updateSQL withParameterDictionary:diary.keyValues];
}

//获取所有数据
-(FMResultSet *)selectAll:(NSInteger)offset len:(NSInteger)length{
	NSString *sql=[NSString stringWithFormat:@"SELECT * FROM diary order by id desc limit %ld,%ld",(long)offset,(long)length];
	return [db executeQuery:sql];
}

//获取指定id的数据
-(FMResultSet *)selectOne:(NSInteger)sid{
	NSString *sql=[NSString stringWithFormat:@"SELECT * FROM diary where id=%ld limit 0,1",(long)sid];
	return [db executeQuery:sql];
}

//获取最后一个ID值
-(NSInteger)lastId{
	NSInteger resId=-1;
	NSString *sql=@"SELECT id FROM diary order by id desc limit 0,1";
	FMResultSet *res = [db executeQuery:sql];
	while ([res next]) {
		resId=[res intForColumn:@"id"];
	}
	return resId;
}

//获取今日ID
-(NSInteger)todayId{
	NSInteger resId=0;
	NSString *sync_id=[BaseUtils formatTime:@"yyyyMMdd" :[BaseUtils getTime]];
	NSString *sql=[NSString stringWithFormat:@"SELECT id,sync_id FROM diary where sync_id=%@ limit 0,1",sync_id];
	FMResultSet *res=[db executeQuery:sql];
	if([res next]){
		resId=[res intForColumn:@"id"];
	}
	return resId;
}

//获取表的大小
-(NSInteger)count{
	NSInteger resCount=0;
	FMResultSet *s = [db executeQuery:@"select count(*) from diary"];
	if ([s next]) {
		resCount=[s intForColumnIndex:0];
	}
	return resCount;
}

//关闭数据库
-(BOOL)closeDb{
	return YES;
}

//根据索引获取表情
+(NSString *)getEmoteByIndex:(NSInteger)index{
	NSArray *items=@[
		@"face01_plain",
		@"face02_smile",
		@"face03_laughing",
		@"face04_gloat",
		@"face05_sad",
		@"face06_crying",
		@"face07_surprise",
		@"face08_embarrassed",
		@"face09_asleep",
		@"face10_angry"
	];
	return [items objectAtIndex:index];
}

@end
