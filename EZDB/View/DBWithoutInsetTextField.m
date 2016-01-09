//
//  DBWithoutInsetTextField.m
//  EZDB
//
//  Created by wenming.zheng on 14/11/24.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "DBWithoutInsetTextField.h"

@implementation DBWithoutInsetTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//不能进行复制粘贴功能
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
