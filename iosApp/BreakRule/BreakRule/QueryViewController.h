//
//  QueryViewController.h
//  BreakRule
//
//  Created by mac on 14-9-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonIce.h"
#import "LoadView.h"

@interface QueryViewController : UIViewController
{
    CSelectHelp	helpInfo;
    NSString *nsRuleTypeOld;
    NSString *nsQueryStartTimeOld;
    NSString *nsQueryEndTimeOld;
    
    IBOutlet UITableView *queryTableView;
    IBOutlet UIActivityIndicatorView *actView;
    
    LoadView* loadView;
    
    NSLock *theLock;
}
- (IBAction)back:(id)sender;
- (IBAction)condition:(id)sender;
@end
