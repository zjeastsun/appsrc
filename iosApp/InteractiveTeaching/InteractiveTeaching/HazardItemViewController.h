//
//  HazardItemViewController.h
//  BreakRule
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonDB.h"

@interface HazardItemViewController : UIViewController
{
    CSelectHelp m_hazardHelp;
    vector<int> m_vSelectedLine;
    IBOutlet UITableView *hazardTypeTableView;
    IBOutlet UITableView *hazardItemTableView;
}
- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;

@end
