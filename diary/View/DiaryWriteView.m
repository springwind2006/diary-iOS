//
//  DiaryWriteView.m
//  diary
//
//  Created by 谢春平 on 2017/9/1.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiaryWriteView.h"
#import "FileUtils.h"
#import "BaseUtils.h"
#import "FMDB.h"

@interface DiaryWriteView(){

} 

@end


@implementation DiaryWriteView

//[[输入键盘弹出和隐藏
//开始编辑
#pragma mark - UITextField Delegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	CGFloat rects = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 +50);
	if (rects <= 0) { //开始编辑时 视图上移 如果输入框不被键盘遮挡则不上移。
		[UIView animateWithDuration:0.3 animations:^{
			CGRect frame = self.view.frame;
			frame.origin.y = rects;
			self.view.frame = frame;
		}];
	}
	return YES;
}
//结束编辑
#pragma mark - UITextField Delegate Method
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	//结束编辑时键盘下去 视图下移动画
	[UIView animateWithDuration:0.3 animations:^{
		CGRect frame = self.view.frame;
		frame.origin.y = 0.0;
		self.view.frame = frame;
	}];
	return YES;
}
//通过委托来放弃“第一响应者”
#pragma mark - UITextField Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES; 
}
#pragma mark - UITextView Delegate Method 
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	if(![text isEqualToString:@"\n"]) {
		//[textView resignFirstResponder];
	}
	return YES; 
}
//键盘隐藏
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];  
}
//输入键盘]]



- (void)viewDidLoad{
	[super viewDidLoad];
	diary=[DiaryService new];
	webSvc=[WebService new];

	[self initDiary];
	[self setUITextView :_diaryContent :@"日记内容..."];

	//注册输入键盘响应事件
	self.diarySubtitle.delegate=self;
	self.diaryContent.delegate=self;
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)]; 
    tapGestureRecognizer.cancelsTouchesInView = NO;  
    [self.view addGestureRecognizer:tapGestureRecognizer];
	
	//表情及点击事件
	UITapGestureRecognizer *tapGesture;
	for(int i=1;i<=10;i++){
		tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEmote:)];
		[[self.emotes viewWithTag:i] addGestureRecognizer:tapGesture];
	}
	
	//天气点击事件
	[self.diaryWeather addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadWeather:)]]; 
	self.diaryWeather.userInteractionEnabled = YES;
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

-(void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	if (![self isViewLoaded])return;
	if (self.view.window)return;
	[diary closeDb];
}

//日记初始化
-(void)initDiary{
	if(!self.cid){
		self.cid=diary.todayId;
	}
	
	FMResultSet *res=[diary selectOne:self.cid];
	if([res next]){
		self.diaryTitle.text=[res stringForColumn:@"title"];
		self.diarySubtitle.text=[res stringForColumn:@"subtitle"];
		self.diaryContent.text=[res stringForColumn:@"content"];
		self.diaryWeather.text=[res stringForColumn:@"weather"];
		self.diaryEmote=[res intForColumn:@"emote"]+1;
	}else{
		self.diaryTitle.text=[BaseUtils formatTime:@"yyyy年MM月dd日 EEE" :[BaseUtils getTime]];
		self.diarySubtitle.text=@"今天心情不错啊!";
		self.diaryContent.text=@"";
		self.diaryWeather.text=@"天气...";
		self.diaryEmote=2;
		[self getWeather];
	}
}

//多行文本界面设置
-(void)setUITextView :(UITextView *) view :(NSString *) text{
	//手动实现多行文本的边框
	view.layer.backgroundColor = [[UIColor clearColor] CGColor];
	view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.0;
	view.layer.cornerRadius =5.0;
    [view.layer setMasksToBounds:YES];
	
	//设置多行文本的placeholder
	UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = text;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
	placeHolderLabel.hidden=![BaseUtils isBlankString:view.text];
    [placeHolderLabel sizeToFit];
    [view addSubview:placeHolderLabel];
    [view setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

//表情选择事件
-(void)selectEmote :(id)sender{
    UITapGestureRecognizer *tap = sender;
    UIImageView *imgView = (UIImageView*)tap.view;
	self.diaryEmote=imgView.tag;
}

/**
 设置表情
 @param cTag 设置cTag
 */
-(void)setDiaryEmote :(NSInteger)cTag{
	for(int i=1;i<=10;i++){
		if(i!=cTag){
			[self.emotes viewWithTag:i].backgroundColor=nil;
		}else{
			[self.emotes viewWithTag:i].backgroundColor=[UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		}
	}
	_diaryEmote=cTag-1;
}

-(NSInteger) diaryEmote{
	return _diaryEmote;
} 

//保存日记内容
- (IBAction)saveDiary:(id)sender {
	DiaryModel *data=[DiaryModel new];
	data.id=self.cid;
	data.title=self.diaryTitle.text;
	data.subtitle=self.diarySubtitle.text;
	data.content=self.diaryContent.text;
	data.weather=self.diaryWeather.text;
	data.emote=self.diaryEmote;
	
	//获取系统时间戳
	NSInteger ctime= [BaseUtils getTime];
	data.addtime=ctime;
	data.edittime=ctime;
	data.sync_id=[[BaseUtils formatTime:@"yyyyMMdd" :[BaseUtils getTime]] integerValue];
	
	if(self.cid>0){ //更新操作
		[diary update:data];
	}else{ //添加操作
		self.cid=[diary insert:data];
	}
	[BaseUtils showMessage:@"已保存"];
}

//重新获取当日天气
-(void)reloadWeather:(id)sender{
	if(self.cid==diary.todayId){
		[self getWeather];
	}
}

//获取天气
-(void)getWeather{
	weatherCode=[FileUtils getProfile:@"weatherCode"];
	if(weatherCode!=nil){
		[webSvc getWeatherByCode:weatherCode :^(NSString *weather) {
			self.diaryWeather.text=weather;
			[BaseUtils showMessage:@"天气获取成功"];
		}];
	}else{
		[webSvc getWeatherCode:^(NSString *code) {
			weatherCode=code;
			[FileUtils setProfile:weatherCode forKey:@"weatherCode"];
			[webSvc getWeatherByCode:weatherCode :^(NSString *weather) {
				self.diaryWeather.text=weather;
				[BaseUtils showMessage:@"天气获取成功"];
			}];
		}];
	}
}


@end
