//
//  loginViewController.h
//  BreakRule
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"eutils.h"



@interface loginViewController : UIViewController
{
    CICEDBUtil g_db;
    IBOutlet UITextField *serverIpField;
    IBOutlet UITextField *userField;
    IBOutlet UITextField *pwdField;
}
- (IBAction)login:(id)sender;

@end
