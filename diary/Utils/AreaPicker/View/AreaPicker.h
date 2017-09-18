//
//  LocationPickerVC.h
//  YouZhi
//
//  Created by roroge on 15/4/9.
//  Copyright (c) 2015年 com.roroge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AreaPickerComplete)(NSString *,NSString *);

@interface AreaPicker : UIView
- (void)show:(NSString *)code complete:(AreaPickerComplete) callBack;
+ (AreaPicker *)instance:(UIView *)rootView fixHeight:(CGFloat)height;
@end
