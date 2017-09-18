//
//  UITableViewController_DiaryListView.h
//  diary
//
//  Created by 谢春平 on 2017/7/5.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryService.h"

@protocol PassTrendValueDelegate <NSObject>
- (void)passTrendValues:(NSString *)values;//定义协议与方法
@end

@interface DiaryListView:UITableViewController{
	@private
		DiaryService *diary;
		NSInteger dbOffset;
		NSInteger dbSize;
		NSInteger dbCount;
}
@property (retain, nonatomic) id<PassTrendValueDelegate> trendDelegate;
@end
