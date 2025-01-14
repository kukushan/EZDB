//
//  ChangeCardCell.h
//  EZDB
//
//  Created by wenming.zheng on 14/11/14.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLastNumberLabel;
@end
