//
//  AreaPickerService.h
//  diary
//
//  Created by 谢春平 on 2017/9/5.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#ifndef AreaPickerService_h
#define AreaPickerService_h
#import "ProvinceModel.h"
#import "CityModel.h"
#import "TownModel.h"

@interface AreaPickerService : NSObject <NSXMLParserDelegate>{
}

//保存所有地区
@property(readonly,retain) NSMutableArray *allAreas;

-(ProvinceModel *)getPronviceByIndex:(NSInteger)index;
-(CityModel *)getCityByIndex:(NSInteger)index atProvince:(NSInteger)provinceIndex;
-(TownModel *)getTownByIndex:(NSInteger)index atCity:(NSInteger)cityIndex atProvince:(NSInteger)provinceIndex;
-(NSString *)getNameByCode:(NSString *)code;
-(ProvinceModel *)getProvinceByCode :(NSString *)code;
-(CityModel *)getCityByCode :(NSString *)code;
-(TownModel *)getTownByCode :(NSString *)code;

@end

#endif /* AreaPickerService_h */
