//
//  BaseTableCell.m
//  iosLibrary
//
//  Created by liu on 2018/3/13.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "BaseTableCell.h"
#import "TableViewAdapter.h"

@implementation BaseTableCell

-(void)setDataList:(NSArray *)data index:(NSInteger)index
{
    NSException* exception = [NSException exceptionWithName:@"BaseTableCell" reason:@"BaseTableCell - setData 子类必需实现该方法" userInfo:nil];
    @throw exception;
}

@end
