//
//  ProvinceModel.m
//  diary
//
//  Created by 谢春平 on 2017/9/6.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProvinceModel.h"

@implementation ProvinceModel

-(id)init{
	_citys=[NSMutableArray new];
	return self;
}

//添加城市
-(void)addCity:(CityModel *)city{
	[_citys addObject:city];
}

//构建省份
+(ProvinceModel *)create:(NSString *)name :(NSString *)code{
	ProvinceModel *province=[ProvinceModel new];
	province.name=name;
	province.code=code;
	return province;
}

@end

