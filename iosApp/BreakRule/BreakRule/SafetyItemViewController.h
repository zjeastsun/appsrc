//
//  SafetyItemViewController.h
//  BreakRule
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafetyItemViewController : UIViewController
{
    IBOutlet UITableView *itemTableView;
    IBOutlet UITableView *contentTableView;
    
    NSMutableArray *title;
    NSMutableArray *subTitle;
}
- (IBAction)back:(id)sender;

@end
