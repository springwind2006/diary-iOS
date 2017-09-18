//
//  BaseUtils.m
//  diary
//
//  Created by 谢春平 on 2017/7/8.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BaseUtils.h"

@implementation BaseUtils

+(BOOL)isBlankString :(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+(NSInteger)getTime{
	return (NSInteger)[[NSDate date] timeIntervalSince1970];
}

+(NSString *)formatTime :(NSString*)format :(NSInteger)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:format]; //@"yyyy年MM月dd日 HH:mm:ss EEE"
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:time];
    return [dateFormatter stringFromDate:theday];
}

+(void)showMessage :(NSString *)message{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
     
    UILabel *label = [[UILabel alloc]init];
	
	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
	NSAttributedString *string = [[NSAttributedString alloc]initWithString:message attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:style}];
	CGSize LabelSize = [string boundingRectWithSize:CGSizeMake(200.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGSize screenSize = screenRect.size;
    showview.frame = CGRectMake((screenSize.width - LabelSize.width - 20)/2, screenSize.height - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:1.5 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end
