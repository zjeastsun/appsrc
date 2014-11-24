//安全分项选择
//  SafetySubItemViewController.h
//  BreakRule
//
//  Created by mac on 14-10-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonDB.h"

@interface SafetySubItemViewController : UIViewController
{
    CSelectHelp m_safetyItemHelp;
}
- (IBAction)back:(id)sender;

@end
