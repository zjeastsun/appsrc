//
//  ProjectViewController.h
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonIce.h"

@interface ProjectViewController : UIViewController
{
    CSelectHelp	helpProject;
    
}

@property (strong, nonatomic) IBOutlet UITableView *projectTable;

@end
