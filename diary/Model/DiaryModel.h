//
//  Diary.h
//  diary
//
//  Created by 谢春平 on 2017/7/7.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#ifndef Diary_h
#define Diary_h
#import <Foundation/Foundation.h>

@interface DiaryModel : NSObject

@property(nonatomic,assign) NSUInteger id;
@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSString* subtitle;
@property(nonatomic,strong) NSString* content;
@property(nonatomic,strong) NSString* weather;
@property(nonatomic,assign) NSInteger emote;
@property(nonatomic,assign) NSUInteger addtime;
@property(nonatomic,assign) NSUInteger edittime;
@property(nonatomic,assign) NSInteger sync_id;

@end

#endif /* Diary_h */
