//
//  ReviewBreakRuleViewController.h
//  BreakRule
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonIce.h"

@interface ReviewBreakRuleViewController : UIViewController
{
    CSelectHelp	helpInfo;
    NSString *nsReviewStartTimeOld;
    NSString *nsReviewEndTimeOld;
    
    IBOutlet UITableView *reviewTableView;
}

- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;

@end
