//
//  LoadView.h
//  BreakRule
//
//  Created by mac on 14-11-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MORE_STRING  NSLocalizedString(@"向下拖动可以刷新",@"向下拖动可以刷新")
#define NO_MORE_STRING NSLocalizedString(@"已经没有更多数据了",@"已经没有更多数据了")

@interface LoadView : UIView
{
    IBOutlet UIActivityIndicatorView *activeView;
    IBOutlet UILabel *tipLabel;
}
@property(nonatomic,readonly) BOOL isLoading;
@property(nonatomic,readonly) UILabel* tipLabel;
- (void)startLoading;
- (void)stopLoading;

@end
