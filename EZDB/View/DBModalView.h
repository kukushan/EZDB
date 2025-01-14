//
//  DBModalView.h
//  EZDB
//
//  Created by wenming.zheng on 14-10-17.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBModalView : NSObject

@property (nonatomic, strong) UIView *mView;
@property (nonatomic, strong) UIView *fView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *actView;

+ (instancetype) shareModal;

- (void)showModalInView:(UIView *)superView title:(NSString *)title shouldHideBlackView:(BOOL)hided;

- (void)collapseModalView;

@end
