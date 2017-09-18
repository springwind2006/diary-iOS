//
//  DiarySettingView.h
//  diary
//
//  Created by 谢春平 on 2017/9/4.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#ifndef DiarySettingView_h
#define DiarySettingView_h

#import <UIKit/UIKit.h>

@interface DiarySettingView : UITableViewController{
	
}

- (IBAction)showHelp:(id)sender;
@property (weak, nonatomic) IBOutlet UITableViewCell *areaSelector;
@property (weak, nonatomic) IBOutlet UILabel *areaName;
@property (weak, nonatomic) IBOutlet UIImageView *account;

@end

#endif /* DiarySettingView_h */
