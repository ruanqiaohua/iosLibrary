//
//  BaseTableCell.h
//  iosLibrary
//
//  Created by liu on 2018/3/13.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewAdapter;

@interface BaseTableCell : UITableViewCell

@property(weak, nonatomic) TableViewAdapter * listAdapter;

-(void)setDataList:(NSArray *)data index:(NSInteger)index;

@end
