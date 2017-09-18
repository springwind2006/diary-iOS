//
//  DiarySettingView.m
//  diary
//
//  Created by 谢春平 on 2017/9/4.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiarySettingView.h"
#import "BaseUtils.h"
#import "FileUtils.h"
#import "AreaPicker.h"
#import "PopAlterView.h"
#import "AreaPickerService.h"

@interface DiarySettingView(){
}

@end

@implementation DiarySettingView

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.account addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(accountLogin:)]]; 
	[self.areaSelector addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(areaSelect:)]]; 
	self.areaName.text=[FileUtils getProfile:@"AreaName"];
}

-(void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	if (![self isViewLoaded])return;
	if (self.view.window)return;
}


-(IBAction)accountLogin:(id)sender{
	[BaseUtils showMessage:@"功能完善中..."];
}

-(IBAction)areaSelect:(id)sender{
	CGFloat height=STATUSBAR_HEIGHT+NAVBAR_HEIGHT+TABBAR_HEIGHT;
	AreaPicker *areaPicker=[AreaPicker instance:self.view fixHeight:height];
	NSString *areaCode=[FileUtils getProfile:@"weatherCode"];
	[areaPicker show:areaCode complete:^(NSString *name, NSString *code) {
		//NSLog(@"areaPicker name:%@,code:%@",name,code);
		self.areaName.text=name;
		[FileUtils setProfile:code forKey:@"weatherCode"];
		[FileUtils setProfile:name forKey:@"AreaName"];
	}];
}



- (IBAction)showHelp:(id)sender {
	NSString *errorMsg=@"如果您在使用过程中有什么意见和建议，欢迎来邮件：spring.wind2006@163.com";
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"感谢您的使用" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}
@end
