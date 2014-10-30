//
//  ReviewBreakRuleSingleViewController.h
//  BreakRule
//
//  Created by mac on 14-10-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonIce.h"

@interface ReviewBreakRuleSingleViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *stateTableView;
    
    NSMutableArray *title;
    NSMutableArray *subTitle;
    
    IBOutlet UITextField *orgNameTextField;
    IBOutlet UITextField *typeTextField;
    IBOutlet UITextField *timeTextField;
    IBOutlet UITextView *breakRuleContentTextField;
    
    IBOutlet UITextView *reviewContent1TextView;
    IBOutlet UITextView *reviewContent2TextView;
    IBOutlet UITextView *reviewContent3TextView;
    IBOutlet UITextView *reviewContent4TextView;
    
    CSelectHelp	helpInfo;
    string sCurFlowNode;
    string sReview_grade;
    
}
- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;

@end
