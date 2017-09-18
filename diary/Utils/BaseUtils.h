//
//  BaseUtils.h
//  diary
//
//  Created by 谢春平 on 2017/7/8.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#ifndef BaseUtils_h
#define BaseUtils_h
#import <Foundation/Foundation.h>

#define SCREEN_HEIGHT      ([UIScreen mainScreen].bounds.size.height)
#define STATUSBAR_HEIGHT      ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NAVBAR_HEIGHT      (self.navigationController.navigationBar.frame.size.height)
#define TABBAR_HEIGHT      (self.tabBarController.tabBar.frame.size.height)

@interface BaseUtils : NSObject

+ (BOOL)isBlankString:(NSString *)string;
+ (NSInteger)getTime;
+ (NSString *)formatTime :(NSString*)format :(NSInteger)time;
+ (void)showMessage :(NSString*)message;

@end

#endif /* BaseUtils_h */
