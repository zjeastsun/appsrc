//
//  ReviewBreakRuleSingleViewController.m
//  BreakRule
//
//  Created by mac on 14-10-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ReviewBreakRuleSingleViewController.h"

@interface ReviewBreakRuleSingleViewController ()

@end

@implementation ReviewBreakRuleSingleViewController

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
//    scrollView.contentSize = CGSizeMake(280.0, 1200.0);
//    [scrollView setContentSize:CGSizeMake(1280, 480)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
//    [superview DidAppear:animated];
//    scrollView.contentSize = CGSizeMake(280.0, 1200.0);
    scrollView.frame = CGRectMake(0, 0, 320, 480);
    
    [scrollView setContentSize:CGSizeMake(320, 1000)];
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

@end
