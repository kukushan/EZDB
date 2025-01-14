//
//  FundHeadCell.h
//  EZDB
//
//  Created by wenming.zheng on 14-10-30.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphKit.h"
#import "ChartData.h"
#import "UIViewController+BButton.h"

@protocol CellBtnBackDelegate <NSObject>

- (void)btnClick:(NSInteger )index withObject:(id)object withSender:(UIButton *)sender;

@end

@interface FundHeadCell : UITableViewCell<GKLineGraphDataSource>

@property (weak, nonatomic) IBOutlet UIView *chView;

@property (weak, nonatomic) IBOutlet GKLineGraph *graph;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) NSArray *labels;

@property (weak, nonatomic) IBOutlet UIView *sView;

/* 七日年化收益率 */
@property (weak, nonatomic) IBOutlet UILabel *sProRate;

@property (weak, nonatomic) IBOutlet UIButton *proRateBtn;

/* 万份收益 */
@property (weak, nonatomic) IBOutlet UILabel *tProfit;

@property (weak, nonatomic) IBOutlet UIButton *profitBtn;

/* 7日 */
@property (weak, nonatomic) IBOutlet UIButton *daysBtn;

/* 1个月 */
@property (weak, nonatomic) IBOutlet UIButton *oneMonth;

/* 2个月 */
@property (weak, nonatomic) IBOutlet UIButton *twoMonth;

@property (assign, nonatomic) NSInteger tag;

@property (assign, nonatomic) id<CellBtnBackDelegate>delegate;

@end
