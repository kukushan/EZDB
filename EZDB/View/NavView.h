//
//  NavView.h
//  EZDB
//
//  Created by wenming.zheng on 14-10-18.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopViewContrlDelegate <NSObject>

- (void)popViewContrl:(NSInteger )index;

@end

@interface NavView : UIView

@property (strong ,nonatomic) DBTitleView *titleView;
@property (assign ,nonatomic) id<PopViewContrlDelegate>delegate;

- (id)initWithFrame:(CGRect)frame navTitle:(NSString *)title lBtnImg:(NSString *)imgStrBack rBtnImg:(NSString *)imgStrHome;

@end
