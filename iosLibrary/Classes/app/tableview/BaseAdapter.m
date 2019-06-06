//
//  BaseAdapter.m
//  iosLibrary
//
//  Created by liu on 2018/10/1.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "BaseAdapter.h"
#import <MJRefresh.h>
#import "toolMacro.h"

@implementation TableViewMenuItem

+(instancetype)initWithName:(NSString *)name isDestructive:(BOOL)isDestructive
{
    TableViewMenuItem * item = ONEW(TableViewMenuItem);
    item.name = name;
    item.isDestructive = isDestructive;
    return item;
}

@end

@implementation BaseAdapter

-(void)addRefresh
{
    if (self.dataView.mj_header)return;
    WEAKOBJ(self);
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [weak_self reqNetDataPage:1];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.dataView.mj_header = header;
}

-(void)addLoadMore
{
    if (self.dataView.mj_footer)return;
    WEAKOBJ(self);
    MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        [weak_self reqNetDataPage:[weak_self getCurPage] + 1];
    }];
    footer.stateLabel.hidden = YES;
    self.dataView.mj_footer = footer;
}

-(void)removeLoadMore
{
    self.dataView.mj_footer = nil;
}

-(void)autoRefresh
{
    [self.dataView.mj_header beginRefreshing];
}

-(BOOL)updateData:(DataBase *)data
{
    for (NSInteger i = self.dataList.count - 1; i > -1; i--)
    {
        if ([self.dataList[i].autoId isEqualToString:data.autoId])
        {
            self.dataList[i] = data;
            return YES;
        }
    }
    return NO;
}

-(BOOL)removeData:(DataBase *)data
{
    return [self removeDataById:data.autoId];
}

-(BOOL)removeDataById:(NSString *)autoId
{
    for (NSInteger i = self.dataList.count - 1; i > -1; i--)
    {
        if ([self.dataList[i].autoId isEqualToString:autoId])
        {
            [self.dataList removeObjectAtIndex:i];
            return YES;
        }
    }
    return NO;
}

-(void)addData:(NSArray<DataBase *> *)list toStart:(BOOL)ts isClear:(BOOL)isClear
{
    if (!self.dataList)
    {
        self.dataList = [list mutableCopy];
        return;
    }
    if (isClear)
    {
        [self.dataList removeAllObjects];
    }
    if (ts)
    {
        [self.dataList insertObjects:list atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, list.count)]];
    }else
    {
        [self.dataList addObjectsFromArray:list];
    }
}

-(void)endRefresh
{
    [self.dataView.mj_header endRefreshing];
}

-(void)endLoadMore
{
    [self.dataView.mj_footer endRefreshing];
}

-(NSArray *)getDataList
{
    return self.dataList;
}

-(NSInteger)getCurPage
{
    return self.curPage;
}

-(void)reqNetDataPage:(NSInteger)page{}
//////////////////////////
-(BOOL)isNeedRowMenuIndexPath:(NSIndexPath *)ip
{
    return NO;
}
-(void)onRowMenuClick:(TableViewMenuItem *)item data:(DataBase *)data{}
-(NSArray<TableViewMenuItem *> *) getRowMenuItemIndexPath:(NSIndexPath *)ip
{
    return nil;
}

@end
