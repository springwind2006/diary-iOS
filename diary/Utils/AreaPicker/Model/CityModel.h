//
//  CityModel.h
//  diary
//
//  Created by 谢春平 on 2017/9/6.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#ifndef CityModel_h
#define CityModel_h

#import "TownModel.h"

@interface CityModel : NSObject{
}

@property(retain,nonatomic) NSString *name;
@property(retain,nonatomic) NSString *code;
@property(readonly,retain) NSMutableArray *towns;

-(void)addTown:(TownModel *)town;
+(CityModel *)create:(NSString *)name :(NSString *)code;

@end

#endif /* CityModel_h */
