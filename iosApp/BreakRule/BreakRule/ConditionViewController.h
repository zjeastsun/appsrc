//查询条件选择页
//  ConditionViewController.h
//  BreakRule
//
//  Created by mac on 14-10-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConditionViewController : UIViewController
{
    IBOutlet UITextField *startTimeText;
    IBOutlet UITextField *endTimeText;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIButton *setButton;
    IBOutlet UITextView *dateBackground;
    IBOutlet UIButton *cancelButton;
    bool bStartTime;
    
    NSMutableArray *title;
    NSMutableArray *subTitle;
    IBOutlet UITableView *ruleTableView;
    IBOutlet UILabel *timeLabel;
    
    NSString *nsRuleTypeOld;
}

- (IBAction)back:(id)sender;
- (IBAction)selectStartTime:(id)sender;
- (IBAction)selectEndTime:(id)sender;
- (IBAction)setTime:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;


@end
