//
//  NewChatCell.h
//  tabBarDemo
//
//  Created by jinzelu on 15/1/28.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListItem : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *emote;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *subTitle;
@property (retain, nonatomic) IBOutlet UILabel *weather;

@end
