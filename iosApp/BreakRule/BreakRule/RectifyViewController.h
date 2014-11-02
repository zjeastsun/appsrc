//
//  RectifyViewController.h
//  BreakRule
//
//  Created by mac on 14-9-24.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadView.h"
#import "SingletonIce.h"

@interface RectifyViewController : UIViewController
{
    CSelectHelp	helpInfo;
    NSString *nsRuleTypeOld;
    NSString *nsRectifyStartTimeOld;
    NSString *nsRectifyEndTimeOld;
    
    LoadView* loadView;
    IBOutlet UITableView *rectifyTableView;
    IBOutlet UIActivityIndicatorView *actView;
}
- (IBAction)back:(id)sender;
- (IBAction)condition:(id)sender;

@end
