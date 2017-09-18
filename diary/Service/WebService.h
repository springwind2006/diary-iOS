//
//  CommonUtils.h
//  diary
//
//  Created by 谢春平 on 2017/9/4.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WebService:NSObject{
	@private
	AFHTTPRequestOperationManager *_request;	
}

@property(retain,nonatomic) AFHTTPRequestOperationManager *request;

- (void)getWeatherCode :(void (^)(NSString *))callback;
- (void)getWeatherByCode:(NSString *)code :(void (^)(NSString *))callback;

@end
