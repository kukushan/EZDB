//
//  FundInfoCell.h
//  EZDB
//
//  Created by wenming.zheng on 14-10-30.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FundInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *funIntro;

@property (weak, nonatomic) IBOutlet UILabel *fullName;

@property (weak, nonatomic) IBOutlet UILabel *simName;

@property (weak, nonatomic) IBOutlet UILabel *fundCode;

@property (weak, nonatomic) IBOutlet UILabel *regFirmName;

@property (weak, nonatomic) IBOutlet UILabel *regFirmCode;

@property (weak, nonatomic) IBOutlet UILabel *manName;

@property (weak, nonatomic) IBOutlet UILabel *manCode;

@property (weak, nonatomic) IBOutlet UILabel *proState;

@property (weak, nonatomic) IBOutlet UILabel *chargeSty;

@end
