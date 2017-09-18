//
//  CityModel.m
//  diary
//
//  Created by 谢春平 on 2017/9/6.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@implementation CityModel

-(id)init{
	_towns=[NSMutableArray new];
	return self;
}

//添加城市
-(void)addTown:(TownModel *)town{
	[_towns addObject:town];
}

//构建省份
+(CityModel *)create:(NSString *)name :(NSString *)code{
	CityModel *town=[CityModel new];
	town.name=name;
	town.code=code;
	return town;
}

@end
