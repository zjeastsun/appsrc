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
    IBOutlet UITextField *serverIpField;
    IBOutlet UITextField *userField;
    IBOutlet UITextField *pwdField;
    IBOutlet UIScrollView *scrollView;
    
    UITextField *textFieldSelected;
    /** 弹出键盘fame */
    CGRect keyboardRect;
    IBOutlet UIActivityIndicatorView *actView;
}
- (IBAction)login:(id)sender;


@end
