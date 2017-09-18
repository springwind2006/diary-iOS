//
//  LocationPickerVC.m
//  YouZhi
//
//  Created by roroge on 15/4/9.
//  Copyright (c) 2015年 com.roroge. All rights reserved.
//

#import "AreaPicker.h"
#import "UIView+RGSize.h"
#import "AreaPickerService.h"

@interface AreaPicker () <UIPickerViewDataSource, UIPickerViewDelegate>{
	@private
		AreaPickerComplete completeHandle;
		NSInteger cProvinceIndex;
		NSInteger cCityIndex;
		NSInteger cTownIndex;
}

//view
@property (strong, nonatomic) UIPickerView *myPicker;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *okBtn;

@property (strong, nonatomic) UIView *rootView;
@property (assign) CGFloat fixHeight;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *alterView;
@property (strong,nonatomic) NSString *curCode;

@end


@implementation AreaPicker

static AreaPickerService *pickerService;

+(void)setPickerService{
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (pickerService == nil) {
            pickerService = [AreaPickerService new];
        }
    });
}

+ (AreaPicker *)instance:(UIView *)rootView fixHeight:(CGFloat)height{
	AreaPicker *areaPicker=[[AreaPicker alloc] initWithFrame:rootView.frame];
	areaPicker.rootView=rootView;
	areaPicker.fixHeight=height;
	return areaPicker;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
	if(self){
		//添加背景层
		self.maskView = [[UIView alloc] initWithFrame:kScreen_Frame];
		self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
		[self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doCancel:)]];
		[self addSubview:self.maskView];

		//添加日期选择器
		self.alterView=[[[NSBundle mainBundle] loadNibNamed:@"AreaPicker" owner:nil options:nil] lastObject];
		[self.maskView addSubview:self.alterView];
		
		//日期选择器设置
		self.myPicker=(UIPickerView *)[self viewWithTag:1];
		self.myPicker.delegate=self;
		self.myPicker.dataSource=self;
		self.cancelBtn=(UIButton *)[self viewWithTag:2];
		self.okBtn=(UIButton *)[self viewWithTag:3];
		[self.cancelBtn addTarget:nil action:@selector(doCancel:) forControlEvents:UIControlEventTouchUpInside];
		[self.okBtn addTarget:nil action:@selector(doOk:) forControlEvents:UIControlEventTouchUpInside];
		[AreaPicker setPickerService];
		cProvinceIndex=cCityIndex=cTownIndex=0;
	}
	return self;
}


- (void)show:(NSString *)code complete:(AreaPickerComplete) callBack{
    [self.rootView addSubview:self];
	self.alterView.top=self.maskView.height;
	self.alterView.width=self.maskView.width;
	self.maskView.alpha=0;
	completeHandle=callBack;
	[self setPickerValue:code];
	[UIView animateWithDuration:0.3 animations:^{
		self.maskView.alpha=1;
		self.alterView.bottom=self.maskView.height-self.fixHeight;
    }];
}


#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return pickerService.allAreas.count;
    } else if (component == 1) {
        return [pickerService getPronviceByIndex:cProvinceIndex].citys.count;
    } else {
        return [pickerService getCityByIndex:cCityIndex atProvince:cProvinceIndex].towns.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [pickerService getPronviceByIndex:row].name;
    } else if (component == 1) {
        return [pickerService getCityByIndex:row atProvince:cProvinceIndex].name;
    } else {
        return [pickerService getTownByIndex:row atCity:cCityIndex atProvince:cProvinceIndex].name;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 120;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
		cProvinceIndex=row;
		cCityIndex=0;
		cTownIndex=0;
		[pickerView reloadComponent:1];
		[pickerView selectRow:0 inComponent:1 animated:YES];
		[pickerView reloadComponent:2];
		[pickerView selectRow:0 inComponent:2 animated:YES];
    }else if (component == 1) {
		cCityIndex=row;
		cTownIndex=0;
		[pickerView reloadComponent:2];
		[pickerView selectRow:0 inComponent:2 animated:YES];
    }else{
		cTownIndex=row;
	}
	
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)setPickerValue:(NSString*)code{
	if(code.length>=6){
		cProvinceIndex=[[code substringWithRange:NSMakeRange((code.length > 6 ? 3 : 0), 2)] integerValue]-1;
		cCityIndex=[[code substringWithRange:NSMakeRange((code.length > 6 ? 5 : 2), 2)] integerValue]-1;
		cTownIndex=[[code substringWithRange:NSMakeRange((code.length > 6 ? 7 : 4), 2)] integerValue]-1;
	}else if(code.length==4){
		cProvinceIndex=[[code substringWithRange:NSMakeRange(0, 2)] integerValue]-1;
		cCityIndex=[[code substringWithRange:NSMakeRange(2, 2)] integerValue]-1;
		cTownIndex=0;
	}else if(code.length==2){
		cProvinceIndex=[code integerValue]-1;
		cCityIndex=cTownIndex=0;
	}
	//NSLog(@"set code:%@\n provinceIndex:%ld,cityIndex:%ld,townIndex:%ld",code,cProvinceIndex,cCityIndex,cTownIndex);
	[self.myPicker reloadAllComponents];
	[self.myPicker selectRow:cProvinceIndex inComponent:0 animated:NO];
	[self.myPicker selectRow:cCityIndex inComponent:1 animated:NO];
	[self.myPicker selectRow:cTownIndex inComponent:2 animated:NO];
}

//关闭
- (void)doCancel:(id)sender {
	[self removeFromSuperview];
}

//确定
- (void)doOk:(id)sender {
	NSInteger provinceIndex=[self.myPicker selectedRowInComponent:0];
	NSInteger cityIndex=[self.myPicker selectedRowInComponent:1];
	NSInteger townIndex=[self.myPicker selectedRowInComponent:2];
	
	TownModel *town=[pickerService getTownByIndex:townIndex atCity:cityIndex atProvince:provinceIndex];
//	
//	NSLog(@"get code:%@\n provinceIndex:%ld,cityIndex:%ld,townIndex:%ld",town.code,provinceIndex,cityIndex,townIndex);
	completeHandle(town.name,town.code);
	[self removeFromSuperview];
}


@end
