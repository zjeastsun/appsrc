//检查项目选择
//  CheckItemViewController.h
//  BreakRule
//
//  Created by mac on 14-10-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonDB.h"

@interface CheckItemViewController : UIViewController
{
    CSelectHelp m_checkItemHelp;
}
- (IBAction)back:(id)sender;

@end
