//
//  ChartModel.h
//  EZDB
//
//  Created by wenming.zheng on 14-11-13.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "BOCOPPayBaseModelObject.h"

@interface ChartModel : BOCOPPayBaseModelObject

/** 开始时间 */
@property (nonatomic, copy) NSString *startDay;

/** 结束时间 */
@property (nonatomic, copy) NSString *endDay;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 标题时间 */
@property (nonatomic, copy) NSString *titleDay;

/** 标题金额 */
@property (nonatomic, copy) NSString *titleMoney;

/** Y轴最大值 */
@property (nonatomic, copy) NSString *maxYValue;

/** Y轴最小值*/
@property (nonatomic, copy) NSString *minYValue;

/** Y轴中间值 */
@property (nonatomic, copy) NSString *midYValue;

/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 显示金额数据 */
@property (nonatomic, strong) NSString *popMoney;

@end
