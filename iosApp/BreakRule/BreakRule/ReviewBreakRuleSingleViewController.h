//
//  ReviewBreakRuleSingleViewController.h
//  BreakRule
//
//  Created by mac on 14-10-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewBreakRuleSingleViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *stateTableView;
    
    NSMutableArray *title;
    NSMutableArray *subTitle;
}
- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;

@end
