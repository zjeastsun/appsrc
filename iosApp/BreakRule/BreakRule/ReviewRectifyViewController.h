//
//  ReviewRectifyViewController.h
//  BreakRule
//
//  Created by mac on 14-11-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonIce.h"
#import "LoadView.h"

@interface ReviewRectifyViewController : UIViewController
{
    CSelectHelp	helpInfo;
    NSString *nsRuleTypeOld;
    NSString *nsReviewRectifyStartTimeOld;
    NSString *nsReviewRectifyEndTimeOld;
    
    IBOutlet UITableView *reviewTableView;
    IBOutlet UIActivityIndicatorView *actView;
    
    LoadView* loadView;
    
    NSLock *theLock;
}
- (IBAction)back:(id)sender;
- (IBAction)condition:(id)sender;

@end
