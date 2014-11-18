//
//  magnifyImageViewController.m
//  BreakRule
//
//  Created by mac on 14-11-18.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "magnifyImageViewController.h"
#import "PZPhotoView.h"
#import"Global.h"
#import "SingletonBridge.h"

@interface magnifyImageViewController ()< PZPhotoViewDelegate>

@end

@implementation magnifyImageViewController

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
    
    BRIDGE
    
    PZPhotoView *photoView = [[PZPhotoView alloc] initWithFrame:kBoundsOfMainScreen];
    
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self.view addSubview:photoView];
    [UIView commitAnimations];
    
    
    UIImage *image = bridge.image;
    
    photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    photoView.photoViewDelegate = self;
    
    [photoView displayImage:image];
    
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
- (void)photoViewDidSingleTap:(PZPhotoView *)photoView {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
