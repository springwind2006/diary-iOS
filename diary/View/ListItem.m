//
//  NewChatCell.m
//  tabBarDemo
//
//  Created by jinzelu on 15/1/28.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
    }
    return self;
}
- (void)awakeFromNib {
	[super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
