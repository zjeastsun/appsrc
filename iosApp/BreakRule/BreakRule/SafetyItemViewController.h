//违规行为辨识库选择，即安全选项选择
//  SafetyItemViewController.h
//  BreakRule
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonDB.h"

@interface SafetyItemViewController : UIViewController
{
    IBOutlet UITableView *itemTableView;
    IBOutlet UITableView *contentTableView;
    
    NSMutableArray *title;
    NSMutableArray *subTitle;
    
    CSelectHelp m_itemHelp;
    vector<int> m_vSelectedLine;
    
    NSString *nsSafetySubItemIdOld;
    NSString *nsProjectTypeOld;
    NSString *nsCheckItemIdOld;
}
- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;

@end
