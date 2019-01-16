//
//  BaseAdapter.h
//  iosLibrary
//
//  Created by liu on 2018/10/1.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataBase.h"

@class BaseAppVC;

//列表菜单
@interface TableViewMenuItem : NSObject
@property(copy, nonatomic) NSString * name;
@property(assign, nonatomic) BOOL isDestructive;
+(instancetype)initWithName:(NSString *)name isDestructive:(BOOL)isDestructive;
@end

@interface BaseAdapter : NSObject

@property(strong, nonatomic) NSMutableArray<DataBase *> * dataList;
@property(assign, nonatomic) NSInteger curPage;
@property(assign, nonatomic) NSInteger totalPage;
@property(weak, nonatomic) BaseAppVC * viewController;
@property(strong, nonatomic) UIScrollView * dataView;

-(void)addRefresh;
-(void)addLoadMore;
-(void)removeLoadMore;
-(void)autoRefresh;
-(BOOL)updateData:(DataBase *)data;
-(BOOL)removeData:(DataBase *)data;
-(BOOL)removeDataById:(NSString *)autoId;
-(void)addData:(NSArray<DataBase *> *)list toStart:(BOOL)ts isClear:(BOOL)isClear;//添加数据到列表，toStart是否添加到列表头 为NO是到尾部 isClear 是否清空数据后添加
-(void)endRefresh;
-(void)endLoadMore;
//////////////////////
-(BOOL)isNeedRowMenuIndexPath:(NSIndexPath *)ip;
-(void)onRefresh;
-(void)onLoadMore;
-(void)onRowMenuClick:(TableViewMenuItem *)item data:(DataBase *)data;
-(NSArray<TableViewMenuItem *> *) getRowMenuItemIndexPath:(NSIndexPath *)ip;

@end
