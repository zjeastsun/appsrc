//
//  MainViewController.m
//  BreakRule
//
//  Created by mac on 14-9-24.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MainViewController.h"
#import "SingletonBridge.h"
#import "IosUtils.h"
#import "Global.h"
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

- (IBAction)toBreakRuleView:(id)sender {
    
    BRIDGE
    if (![bridge hasRight:RIGHT_BREAK_RULE]) {
        [IosUtils MessageBox:@"您没有违规抓拍的权限！" ];
        return;
    }
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BreakRuleView"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)toQueryView:(id)sender {
    BRIDGE
    if (![bridge hasRight:RIGHT_QUERY]) {
        [IosUtils MessageBox:@"对不起，您没有查询的权限！" ];
        return;
    }
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QueryView"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)set:(id)sender {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SetView"];
    [self presentViewController:viewController animated:YES completion:nil];
}


- (IBAction)toReviewBreakRule:(id)sender {
    BRIDGE
    if (![bridge hasRight:RIGHT_REVIEW_BREAK_RULE]) {
        [IosUtils MessageBox:@"对不起，您没有批阅违规的权限！" ];
        return;
    }
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewBreakRuleView"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)toRectifyView:(id)sender {
    BRIDGE
    if (![bridge hasRight:RIGHT_RECTIFY]) {
        [IosUtils MessageBox:@"对不起，您没有整改抓拍的权限！" ];
        return;
    }
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RectifyView"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)toReviewRectifyView:(id)sender {
    BRIDGE
    if (![bridge hasRight:RIGHT_REVIEW_RECTIFY]) {
        [IosUtils MessageBox:@"对不起，您没有批阅整改的权限！" ];
        return;
    }
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewRectifyView"];
    [self presentViewController:viewController animated:YES completion:nil];
}
@end
