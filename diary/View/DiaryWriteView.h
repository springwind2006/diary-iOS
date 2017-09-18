//
//  DiaryWriteView.h
//  diary
//
//  Created by 谢春平 on 2017/9/1.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryService.h"
#import "WebService.h"

@interface DiaryWriteView : UIViewController<UITextFieldDelegate, UITextViewDelegate>{
	@private
		NSString *weatherCode;
		DiaryService *diary;
		WebService *webSvc;
		NSInteger _diaryEmote;
		NSInteger _cid;
}

@property NSInteger cid;
@property (weak, nonatomic) IBOutlet UILabel *diaryWeather;
@property (weak, nonatomic) IBOutlet UITextField *diarySubtitle;
@property (weak, nonatomic) IBOutlet UILabel *diaryTitle;
@property (weak, nonatomic) IBOutlet UITextView *diaryContent;
@property (weak, nonatomic) IBOutlet UIStackView *emotes;
@property NSInteger diaryEmote;

- (IBAction)saveDiary:(id)sender;

-(void)initDiary;

@end
