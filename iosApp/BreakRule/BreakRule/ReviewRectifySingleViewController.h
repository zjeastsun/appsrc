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
    
    IBOutlet UILabel *progressLabelBR;
    IBOutlet UILabel *progressLabelRectify;
    IBOutlet UIProgressView *progressViewBR;
    IBOutlet UIProgressView *progressViewRectify;
    
    CSelectHelp	helpInfo;
    CSelectHelp helpRectifyInfo;
    
    string sCurFlowNode;
    string sReview_grade;
    NSString *nsReviewContent;
    string sNextNodeId;
    
    UITextView *textViewSelected;
    /** 弹出键盘fame */
    CGRect keyboardRect;
    
    bool bHasRight;
    NSString *nsRightMsg;
    
    double fProgressBR;
    double fProgressRectify;
    bool bTransmitBR;//是否正在传输图片
    bool bTransmitRectify;
}

- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;

@end
