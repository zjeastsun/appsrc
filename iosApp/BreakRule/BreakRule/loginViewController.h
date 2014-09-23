//
//  loginViewController.h
//  BreakRule
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "singletonIce.h"

@interface loginViewController : UIViewController
{
    singletonIce *oneIce;
    
    IBOutlet UITextField *serverIpField;
    IBOutlet UITextField *userField;
    IBOutlet UITextField *pwdField;
}
- (IBAction)login:(id)sender;
- (IBAction)backGround:(id)sender;


@end
