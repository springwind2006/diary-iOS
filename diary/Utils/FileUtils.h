//
//  FileUtils.h
//  diary
//
//  Created by 谢春平 on 2017/7/7.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#ifndef FileUtils_h
#define FileUtils_h
#import <Foundation/Foundation.h>

@interface FileUtils : NSObject
+(void)setProfile :(NSString *)value forKey:(NSString*)key;
+(NSString *)getProfile :(NSString *)key;
+(NSInteger)copyFile:(NSString *)srcPath target:(NSString *)targetPath overwrite:(BOOL)isOverwrite;
@end

#endif /* FileUtils_h */
