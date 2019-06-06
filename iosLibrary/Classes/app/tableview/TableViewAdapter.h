//
//  TableViewAdapter.h
//  iosLibrary
//
//  Created by liu on 2018/3/13.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseTableCell.h"
#import "BaseAdapter.h"

@interface TableViewAdapter : BaseAdapter<UITableViewDelegate, UITableViewDataSource>

-(instancetype)initWithTableView:(UITableView *)tv tvCell:(Class)tcCls isRefresh:(BOOL)isRefresh isLoaded:(BOOL)isLoaded isFirstRefresh:(BOOL)isFirstRefresh viewController:(BaseAppVC *)vc;

-(void)initData;
-(void)setTableViewCell:(BaseTableCell *)cell;

@end
