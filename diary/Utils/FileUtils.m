//
//  FileUtils.m
//  diary
//
//  Created by 谢春平 on 2017/7/7.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "FileUtils.h"

@implementation FileUtils

+(void)setProfile :(NSString *)value forKey:(NSString*)key{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *profile = [[path objectAtIndex:0] stringByAppendingPathComponent:@"profile.plist"];
	NSMutableDictionary *contentDic;
	// 判断本地是否存在 plist 文件
	if ([[NSFileManager defaultManager] fileExistsAtPath:profile] == NO) {
		NSFileManager* fm = [NSFileManager defaultManager];
		// 创建一个文件
		[fm createFileAtPath:profile contents:nil attributes:nil];
		contentDic = [[NSMutableDictionary alloc] init];
	} else {
		contentDic = [[NSMutableDictionary alloc] initWithContentsOfFile:profile];
	}
	
	if(value==nil){
		// 数据的删除操作
		[contentDic removeObjectForKey:key];
	}else{
		// 数据的写入操作
		[contentDic setObject:value forKey:key];
	}
	// 将修改都的数据保存到 plist 文件中
	[contentDic writeToFile:profile atomically:YES];
}

+(NSString *)getProfile :(NSString *)key{
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *profile = [[path objectAtIndex:0] stringByAppendingPathComponent:@"profile.plist"];
	
	// 判断本地是否存在 plist 文件
	if ([[NSFileManager defaultManager] fileExistsAtPath:profile] == NO) {
		return nil;
	} else {
		NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithContentsOfFile:profile];
		return [contentDic objectForKey:key];
	}
}

/**
 * 文件拷贝
 */
+(NSInteger)copyFile:(NSString *)srcPath target:(NSString *)targetPath overwrite:(BOOL)isOverwrite{
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSInteger fileSize=0;
	BOOL isExist=[fileManager fileExistsAtPath:targetPath];
	if (!isExist || isOverwrite) {
		if(!isExist){
			isExist=[fileManager createFileAtPath:targetPath contents:nil attributes:nil];
		}
		if(isExist){
			NSLog(@"数据库文件创建成功");
			NSFileHandle *inFile=[NSFileHandle fileHandleForReadingAtPath:srcPath];
			NSFileHandle *outFile=[NSFileHandle fileHandleForWritingAtPath:targetPath];
			  
			NSDictionary   *fileAttr=[fileManager attributesOfItemAtPath:srcPath error:nil];
			NSNumber *fileSizeNum=[fileAttr objectForKey:NSFileSize];

			BOOL isEnd=YES;
			NSInteger readSize=0;//已经读取的数量
			NSInteger bufferSize=1024;
			fileSize=[fileSizeNum longValue];//文件的总长度
			[outFile truncateFileAtOffset:0];//清空文件
			while (isEnd) {
				NSInteger subLength=fileSize-readSize;
				NSData *data=nil;
				if (subLength<bufferSize) {
					isEnd=NO;
					data=[inFile readDataToEndOfFile];
				}else{
					data=[inFile readDataOfLength:bufferSize];
					readSize+=bufferSize;
					[inFile seekToFileOffset:readSize];
				}
				[outFile writeData:data];
			}
			
			[inFile closeFile];  
			[outFile closeFile];  
		}
	}
	return fileSize;
}
@end

