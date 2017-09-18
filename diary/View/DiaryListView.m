//
//  DiaryListView.m
//  diary
//
//  Created by 谢春平 on 2017/7/5.
//  Copyright © 2017年 谢春平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiaryListView.h"
#import "DiaryWriteView.h"
#import "ListItem.h"
#import "MJRefresh.h"
#import "FileUtils.h"
#import "BaseUtils.h"
#import "FMDB.h"


@interface DiaryListView (){
	NSMutableArray *_dataSourceArr;
	NSIndexPath *_selectedIndexPath;//选中的行
	DiaryWriteView *diaryWrite;
}

@end

@implementation DiaryListView

- (void)viewDidLoad{
	[super viewDidLoad];
	
	//初始化数据库及数据
	diary=[DiaryService new];
	dbOffset=0;
	dbSize=10;
	dbCount=diary.count;
	_dataSourceArr=nil;
	
	[self getDiaryList];
	
	
	__unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_header endRefreshing];
		dbOffset=0;
		dbCount=diary.count;
		[_dataSourceArr removeAllObjects];
		_dataSourceArr=nil;
		[self getDiaryList];
		[tableView reloadData];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [tableView.mj_footer endRefreshing];
		[self getDiaryList];
		[tableView reloadData];
		if(dbOffset >dbCount){
			[tableView.mj_footer endRefreshingWithNoMoreData];
		}
    }];
	
//	NSString *areaCode=[FileUtils getProfile:@"areaCode"];
//	if(areaCode==nil){
//		[FileUtils setProfile:@"" forKey:@"areaCode"];
//	}

}

-(void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	if (![self isViewLoaded])return;
	if (self.view.window)return;
	[diary closeDb];
}


//自定义加载数据
- (NSInteger)getDiaryList{
	if(_dataSourceArr == nil){
    	_dataSourceArr = [[NSMutableArray alloc] init];
	}
	FMResultSet *res=[diary selectAll:dbOffset len:dbSize];
	NSInteger len=0;
	while ([res next]) {
		len++;
		[_dataSourceArr addObject:[NSDictionary dictionaryWithObjectsAndKeys: 
							  [NSString stringWithFormat:@"%d",[res intForColumn:@"id"]], @"id",
                              [NSString stringWithFormat:@"%d",[res intForColumn:@"emote"]], @"emote",
                              [res stringForColumn:@"title"], @"title",
                              [res stringForColumn:@"subtitle"], @"subtitle",
                              [res stringForColumn:@"weather"], @"weather", 
                              nil]];
	}
	if(len>0){
		dbOffset+=dbSize;
	}
//	[self dbTest];
	return len;
}


//===============================表格显示==========================
//设置表格行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [_dataSourceArr count];
}

//设置表格单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"Item";
	static BOOL nibsRegistered = NO;
	
	//注册nib视图文件
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"ListItem" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
	
	//设置单元格
	ListItem *cell = (ListItem *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[ListItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.separatorInset = UIEdgeInsetsZero;
	
	NSDictionary *item=(NSDictionary *)[_dataSourceArr objectAtIndex:[indexPath row]];
	cell.emote.image=[UIImage imageNamed:[DiaryService getEmoteByIndex:[[item objectForKey:@"emote"] intValue]]];
	cell.title.text=[item objectForKey:@"title"];
	cell.subTitle.text=[item objectForKey:@"subtitle"];
	cell.weather.text=[item objectForKey:@"weather"];
	
    return cell;
}

//点击每一行事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndexPath = indexPath;
	diaryWrite = [[self storyboard] instantiateViewControllerWithIdentifier:@"diaryWrite"];
	diaryWrite.cid=[[_dataSourceArr[indexPath.row] objectForKey:@"id"] integerValue];
	[[self navigationController] pushViewController:diaryWrite animated:YES];
}

//每行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

//数据库测试
- (void) dbTest{
	NSLog(@"%lu",(long)(long)diary.count);
}

@end
