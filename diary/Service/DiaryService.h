//
//  DiaryService.h
//  diary
//
//  Created by 谢春平 on 2017/7/7.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#ifndef DiaryService_h
#define DiaryService_h
#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "MJExtension.h"
#import "DiaryModel.h"

@interface DiaryService : NSObject{
	@protected
		NSString *dbName;
	@private
		BOOL status; //数据库状态
		BOOL isOverwrite; //加载数据库时是否重写
}

//动态属性
@property(nonatomic,readonly) NSInteger count;
@property(nonatomic,readonly) NSInteger lastId;
@property(nonatomic,readonly) NSInteger todayId;

-(NSInteger)insert:(DiaryModel *)diary;
-(BOOL)update:(DiaryModel *)diary;
-(FMResultSet *)selectAll:(NSInteger)offset len:(NSInteger)length;
-(FMResultSet *)selectOne:(NSInteger)sid;
+(BOOL)initDb:(NSString *)dbName overwrite:(BOOL)isOverwrite;
-(BOOL)closeDb;
+(NSString *)getEmoteByIndex:(NSInteger) index;
@end

#endif /* DiaryService_h */
