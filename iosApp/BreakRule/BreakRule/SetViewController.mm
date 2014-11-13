//
//  setViewController.m
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "SetViewController.h"
#import "SingletonBridge.h"
#import "IosUtils.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getNSUserDafaults
{
    NSUserDefaults * def =[NSUserDefaults standardUserDefaults];
    
    NSString *nsServerAddress;
    nsServerAddress = [def valueForKey:@"server address"];
    if ([nsServerAddress length] == 0) {
        serverAddressTextField.text = [NSString stringWithFormat:@"%s", CENT_ADDRESS.c_str()];
    }
    else
    {
        serverAddressTextField.text = nsServerAddress;
    }
    
    projectNameTextField.text = [def valueForKey:@"project name"];
    
}

-(void)setNSUserDafaults
{
    BRIDGE
    
    NSUserDefaults * def =[NSUserDefaults standardUserDefaults];
    [def setObject:serverAddressTextField.text forKey:@"server address"];
    [def setObject:projectNameTextField.text forKey:@"project name"];
    [def setObject:bridge.nsOrgIdSelected forKey:@"project id"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [IosUtils addTapGuestureForKeyOnView:self.view];
    [self getNSUserDafaults];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewDidAppear:(BOOL)animated
{
    BRIDGE
    if (bridge.nsOrgNameSelected != nil )
    {
        projectNameTextField.text= bridge.nsOrgNameSelected;
    }
}

- (IBAction)back:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    [self setNSUserDafaults];
    [self back:nil];
}

- (IBAction)project:(id)sender {
    UIViewController *projectView = [self.storyboard instantiateViewControllerWithIdentifier:@"projectView"];
    [self presentViewController:projectView animated:YES completion:nil];
}

- (IBAction)UpdateDb:(id)sender {

}

- (IBAction)transmit3g:(id)sender {
    BOOL isButtonOn = [Transmit3gSwitchButton isOn];
    if (isButtonOn) {
        bTransmit3g = true;
    }else {
        bTransmit3g = false;
    }
}
@end
