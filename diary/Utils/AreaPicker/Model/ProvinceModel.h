//
//  ProvinceModel.h
//  diary
//
//  Created by 谢春平 on 2017/9/6.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#ifndef ProvinceModel_h
#define ProvinceModel_h

#import "CityModel.h"

@interface ProvinceModel : NSObject{
}

@property(retain,nonatomic) NSString *name;
@property(retain,nonatomic) NSString *code;
@property(readonly,retain) NSMutableArray *citys;

-(void)addCity:(CityModel *)city;
+(ProvinceModel *)create:(NSString *)name :(NSString *)code;

@end

#endif /* ProvinceModel_h */
