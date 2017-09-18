//
//  SvcUtils.m
//  diary
//
//  Created by 谢春平 on 2017/9/4.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebService.h"
#import "BaseUtils.h"

@implementation WebService

//获取本地天气代码
- (void)getWeatherCode :(void (^)(NSString *))callback{
	NSString *url=[NSString stringWithFormat:@"http://wgeo.weather.com.cn/ip/?_=%ld",(long)[BaseUtils getTime]];
	[self.request.requestSerializer setValue:@"http://www.weather.com.cn/" forHTTPHeaderField:@"Referer"];
	[self.request.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
	self.request.responseSerializer = [AFHTTPResponseSerializer serializer];//返回二进制格式
	
	[self.request GET:url parameters:nil
		success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSString *res = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			if([res hasPrefix:@"var ip="]){
				NSArray *reses=[res componentsSeparatedByString:@"\";var "];
				callback([reses[1] substringFromIndex:4]);
			}
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"Error: %@", error);
		}
	];
}

//根据天气代码获取天气信息
- (void)getWeatherByCode:(NSString *)code :(void (^)(NSString *))callback{
	NSString *areaCode;
	NSString *provinceCode=[code substringWithRange:NSMakeRange((code.length<9?0:3), 2)];
	BOOL isCity=[provinceCode isEqualToString:@"01"] || [provinceCode isEqualToString:@"02"]||[provinceCode isEqualToString:@"03"]||[provinceCode isEqualToString:@"04"];
	if(code.length<9){
		if(isCity){
			areaCode=[NSString stringWithFormat:@"101%@00",[code substringWithRange:NSMakeRange(0, 4)]];
		}else{
			areaCode=[NSString stringWithFormat:@"101%@",code];
		}
	}else{
		areaCode=code;
	}
	
	//NSLog(@"areaCode:%@",areaCode);
	
	NSString *url=[NSString stringWithFormat:@"http://www.weather.com.cn/data/cityinfo/%@.html",areaCode];
	self.request.responseSerializer = [AFJSONResponseSerializer serializer];//返回json格式
	[self.request GET:url parameters:nil
		success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSDictionary *respObj = responseObject;
			NSDictionary *result = [respObj objectForKey:@"weatherinfo"];
			callback([result objectForKey:@"weather"]);
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"Error: %@", error);
		}
	];
}


- (AFHTTPRequestOperationManager *) request{
	if(_request==nil){
		_request=[AFHTTPRequestOperationManager manager];
	}
	return _request;
}

- (void)setRequest:(AFHTTPRequestOperationManager *)request{
	_request=request;
}

@end
