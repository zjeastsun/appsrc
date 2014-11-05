//
//  QuerySingleViewController.h
//  BreakRule
//
//  Created by mac on 14-11-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonIce.h"

@interface QuerySingleViewController : UIViewController
{
    NSMutableArray *title;
    NSMutableArray *subTitle;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *imageViewRectify;
    IBOutlet UIActivityIndicatorView *actView;
    IBOutlet UIActivityIndicatorView *rectifyActView;

    IBOutlet UITextField *orgNameTextField;
    IBOutlet UITextField *typeTextField;
    IBOutlet UITextField *timeTextField;
    IBOutlet UITextField *rectifyTimeTextField;
    IBOutlet UITextView *breakRuleContentTextField;
    IBOutlet UITextView *rectifyContentTextField;
    IBOutlet UITextField *flowState;
    
    CSelectHelp	helpInfo;
    CSelectHelp helpRectifyInfo;
    
    string sReview_grade;
    string sReviewContent;
    
}

- (IBAction)back:(id)sender;

@end
