//
//  TableViewAdapter.m
//  iosLibrary
//
//  Created by liu on 2018/3/13.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TableViewAdapter.h"
#import <MJRefresh.h>
#import "BaseAppVC.h"
#import "toolMacro.h"

@interface TableViewAdapter()
{
    Class                           cellClass;
}
@end

@implementation TableViewAdapter

-(instancetype)initWithTableView:(UITableView *)tv tvCell:(Class)tcCls isRefresh:(BOOL)isRefresh isLoaded:(BOOL)isLoaded isFirstRefresh:(BOOL)isFirstRefresh viewController:(BaseAppVC *)vc
{
    self = [super init];
    if (self)
    {
        self.dataView = tv;
        self.viewController = vc;
        cellClass = tcCls;
        tv.tableFooterView = [[UIView alloc] init];
        tv.delegate = self;
        tv.dataSource = self;
        [tv registerClass:tcCls forCellReuseIdentifier:NSStringFromClass(tcCls)];
        //
        if (isRefresh)
        {
            [self addRefresh];
        }
        if (isLoaded)
        {
            [self addLoadMore];
        }
        if (isFirstRefresh)
        {
            if (isRefresh) [tv.mj_header beginRefreshing];
            else [self reqNetDataPage:1];
        }
        [self initData];

    }
    return self;
}

-(void)initData{}

/****************** UITableViewDataSource *************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getDataList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableCell * cell = (BaseTableCell *) [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
    [self setTableViewCell:cell];
    cell.listAdapter = self;
    [cell setDataList:[self getDataList] index:indexPath.row];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self isNeedRowMenuIndexPath:indexPath];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * items = [self getRowMenuItemIndexPath:indexPath];
    if (items)
    {
        NSMutableArray * menus = ONEW(NSMutableArray);
        UITableViewRowAction * act;
        for (TableViewMenuItem * item in items)
        {
            WEAKOBJ(self);
            act = [UITableViewRowAction rowActionWithStyle:item.isDestructive ? UITableViewRowActionStyleDestructive : UITableViewRowActionStyleNormal title:item.name handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
                   {
                       if (action.style == UITableViewRowActionStyleDestructive)
                       {
                           [weak_self.viewController showAlertTitle:@"提醒" msg:[NSString stringWithFormat:@"您确定要%@吗？",item.name] actNames:@[@"取消",@"确定"] redActIndex:0 clickAction:^(NSInteger index) {

                               if (index == 1)
                               {
                                   [weak_self onRowMenuClick:item data:weak_self.dataList[indexPath.row]];
                               }
                           }];
                       }else
                       {
                           [weak_self onRowMenuClick:item data:weak_self.dataList[indexPath.row]];
                       }
                   }];
            [menus addObject:act];
        }
        return menus;
    }
    return nil;
}

-(void)setTableViewCell:(BaseTableCell *)cell
{
}

@end
