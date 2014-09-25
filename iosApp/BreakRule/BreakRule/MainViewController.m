//
//  MainViewController.m
//  BreakRule
//
//  Created by mac on 14-9-24.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (IBAction)a:(id)sender {
    MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BreakRuleView"];
    
    //    BreakRuleTakePhotoViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
    [self presentViewController:mainViewController animated:YES completion:nil];
}

- (IBAction)b:(id)sender {
    MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RectifyView"];
    
    //    BreakRuleTakePhotoViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
    [self presentViewController:mainViewController animated:YES completion:nil];
}
@end
