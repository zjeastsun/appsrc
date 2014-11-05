//
//  ReviewRectifySingleViewController.h
//  BreakRule
//
//  Created by mac on 14-11-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonIce.h"

@interface ReviewRectifySingleViewController : UIViewController
{
    NSMutableArray *title;
    NSMutableArray *subTitle;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *stateTableView;
    
    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *imageViewRectify;
    IBOutlet UIActivityIndicatorView *actView;
    IBOutlet UIActivityIndicatorView *rectifyActView;
    
    IBOutlet UITextView *reviewContent1TextView;
    IBOutlet UITextView *reviewContent2TextView;
    IBOutlet UITextView *reviewContent3TextView;
    IBOutlet UITextView *reviewContent4TextView;

    IBOutlet UITextField *orgNameTextField;
    IBOutlet UITextField *typeTextField;
    IBOutlet UITextField *timeTextField;
    IBOutlet UITextView *breakRuleContentTextField;
    IBOutlet UITextView *rectifyContentTextField;
    
    CSelectHelp	helpInfo;
    CSelectHelp helpRectifyInfo;
    
    string sCurFlowNode;
    string sReview_grade;
    string sReviewContent;
    string sNextNodeId;
    
    UITextView *textViewSelected;
    /** 弹出键盘fame */
    CGRect keyboardRect;
}

- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;

@end
