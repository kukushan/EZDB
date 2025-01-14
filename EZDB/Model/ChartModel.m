//
//  ChartModel.m
//  EZDB
//
//  Created by wenming.zheng on 14-11-13.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "ChartModel.h"

@implementation ChartModel

-(id)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)setStartDay:(NSString *)startDay
{
    NSMutableString * newStartDay =  [NSMutableString stringWithString:startDay];
    [newStartDay insertString:@"-" atIndex:4];
    [newStartDay insertString:@"-" atIndex:7];
    _startDay = newStartDay;
}

- (void)setEndDay:(NSString *)endDay
{
    NSMutableString * newEndDay =  [NSMutableString stringWithString:endDay];
    if (![newEndDay length]) {
        return;
    }
    [newEndDay insertString:@"-" atIndex:4];
    [newEndDay insertString:@"-" atIndex:7];
    _endDay = newEndDay;
}

- (void)setTitleDay:(NSString *)titleDay
{
    NSMutableString * newTitleDay =  [NSMutableString stringWithString:titleDay];
    if (![newTitleDay length]) {
        return;
    }
    [newTitleDay insertString:@"-" atIndex:4];
    [newTitleDay insertString:@"-" atIndex:7];
    _titleDay = newTitleDay;
}

@end
