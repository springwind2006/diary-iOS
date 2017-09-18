//
//  AreaPickerService.m
//  diary
//
//  Created by 谢春平 on 2017/9/5.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaPickerService.h"

@interface AreaPickerService(){
	@private
		ProvinceModel *province;
		CityModel *city;
		TownModel *town;
}

//添加属性
@property (nonatomic, strong) NSXMLParser *par;

@end

@implementation AreaPickerService

- (instancetype)init{
    self = [super init];
    if (self) {
        //获取事先准备好的XML文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AreasData" ofType:@".xml"];
		//NSLog(@"Data path:%@",path);
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.par = [[NSXMLParser alloc]initWithData:data];
        //添加代理
        self.par.delegate = self;
		_allAreas=[NSMutableArray new];
		[self.par parse];
    }
    return self;
}

//根据索引获取省名称
-(ProvinceModel *)getPronviceByIndex:(NSInteger)index{
	if(index>=0 && index< self.allAreas.count){
		return self.allAreas[index];
	}
	return nil;
}

//根据索引获取城市名称
-(CityModel *)getCityByIndex:(NSInteger)index atProvince:(NSInteger)provinceIndex{
	if(provinceIndex>=0 && provinceIndex< self.allAreas.count){
		ProvinceModel *curProvince=self.allAreas[provinceIndex];
		if(index>=0 && index<curProvince.citys.count){
			return curProvince.citys[index];
		}
	}
	return nil;
}

//根据索引获取地区名称
-(TownModel *)getTownByIndex:(NSInteger)index atCity:(NSInteger)cityIndex atProvince:(NSInteger)provinceIndex{
	if(provinceIndex>=0 && provinceIndex< self.allAreas.count){
		ProvinceModel *curProvince=self.allAreas[provinceIndex];
		if(cityIndex>=0 && cityIndex<curProvince.citys.count){
			CityModel *curCity=curProvince.citys[cityIndex];
			if(index>=0 && index<curCity.towns.count){
				return curCity.towns[index];
			}
		}
	}
	return nil;
}

//根据编码获取省份
-(NSString *)getNameByCode:(NSString *)code{
	if(code.length >=6){
		TownModel *curTown=[self getTownByCode:code];
		return curTown.name;
	}if(code.length == 4){
		CityModel *curCity=[self getCityByCode:code];
		return curCity.name;
	}else{
		ProvinceModel *curProvince=[self getProvinceByCode:code];
		return curProvince.name;
	}
	return nil;
}

//根据编码获取省份
-(ProvinceModel *)getProvinceByCode :(NSString *)code{
	ProvinceModel *curProvince;
	NSString *provinceCode=[code substringWithRange:NSMakeRange((code.length > 6 ? 3 : 0), 2)];
	for(curProvince in self.allAreas){
		if([curProvince.code isEqualToString:provinceCode]){
			return curProvince;
		}
	}
	return nil;
}

//根据编码获取城市
-(CityModel *)getCityByCode :(NSString *)code{
	ProvinceModel *curProvince;
	CityModel *curCity;
	curProvince=[self getProvinceByCode:code];
	if(curProvince){
		NSString *cityCode=[code substringWithRange:NSMakeRange((code.length > 6 ? 3 : 0), 4)];
		for(curCity in curProvince.citys){
			if([curCity.code isEqualToString:cityCode]){
				return curCity;
			}
		}
	}
	return nil;
}

//根据编码获取地区
-(TownModel *)getTownByCode :(NSString *)code{
	CityModel *curCity;
	TownModel *curTown;
	curCity=[self getCityByCode:code];
	if(curCity){
		NSString *townCode=[code substringWithRange:NSMakeRange((code.length > 6 ? 3 : 0), 6)];
		for(curTown in curCity.towns){
			if([curTown.code isEqualToString:townCode]){
				return curTown;
			}
		}
	}
	return nil;
}


//几个代理方法的实现，是按逻辑上的顺序排列的，但实际调用过程中中间三个可能因为循环等问题乱掉顺序
//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidStartDocument...");
}

//准备节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
	//NSLog(@"start Element:%@",elementName);
	NSString *name = [attributeDict objectForKey:@"name"];
	NSString *code = [attributeDict objectForKey:@"code"];
	//NSLog(@"name:%@,code:%@",name,code);
	
	if ([elementName isEqualToString:@"province"]){
		province = [ProvinceModel new];
		province.name=name;
		province.code=code;
    }else if ([elementName isEqualToString:@"city"]){
		city = [CityModel new];
		city.name=name;
		city.code=code;
		
	}else if([elementName isEqualToString:@"district"]){
		town = [TownModel new];
		town.name=name;
		town.code=code;
	}
}

//解析完一个节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    //NSLog(@"end Element:%@\r\n\r\n",elementName);
	if ([elementName isEqualToString:@"district"]) {
        [city addTown:town];
    }else if ([elementName isEqualToString:@"city"]){
		[province addCity:city];
	}else if ([elementName isEqualToString:@"province"]){
		[self.allAreas addObject:province];
	}
}

//解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"parserDidEndDocument...");
}

@end
