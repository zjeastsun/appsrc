//
//  loginViewController.h
//  BreakRule
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SingletonIce.h"

@interface LoginViewController : UIViewController
{
    SingletonIce *oneIce;
    
    IBOutlet UITextField *serverIpField;
    IBOutlet UITextField *userField;
    IBOutlet UITextField *pwdField;
}
- (IBAction)login:(id)sender;
- (IBAction)backGround:(id)sender;


@end
