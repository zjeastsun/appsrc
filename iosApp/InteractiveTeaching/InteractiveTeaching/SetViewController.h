//
//  setViewController.h
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetViewController : UIViewController
{
    IBOutlet UITextField *serverAddressTextField;
    IBOutlet UITextField *projectNameTextField;
    
    IBOutlet UISwitch *Transmit3gSwitchButton;
    
    bool bTransmit3g;
}
- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)project:(id)sender;

- (IBAction)UpdateDb:(id)sender;

- (IBAction)transmit3g:(id)sender;
@end
