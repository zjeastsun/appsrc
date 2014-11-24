//
//  ReviewBreakRuleViewController.h
//  BreakRule
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonIce.h"
#import "LoadView.h"

@interface ReviewBreakRuleViewController : UIViewController
{
    CSelectHelp	helpInfo;
    NSString *nsRuleTypeOld;
    NSString *nsReviewStartTimeOld;
    NSString *nsReviewEndTimeOld;
    
    IBOutlet UITableView *reviewTableView;
    IBOutlet UIActivityIndicatorView *actView;
    
    LoadView* loadView;
    NSLock *theLock;
    
    bool bQuerying;//是否正在查询
}

- (IBAction)back:(id)sender;
- (IBAction)condition:(id)sender;

@end
