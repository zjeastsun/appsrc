//
//  BreakRuleTakePhotoViewController.h
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreakRuleTakePhotoViewController : UIViewController
{
    NSMutableArray *title;
    NSMutableArray *subTitle;
    UIImagePickerController *imagePicker;
    IBOutlet UIImageView *imageView;
    IBOutlet UITableView *ruleTableView;
    IBOutlet UITextView *contentTextView;
    
    __block NSString *nsPhotoData;
    NSString *nsBreakRuleType;
    
    
    /** 弹出键盘fame */
    CGRect keyboardRect;
    UITextView *textViewSelected;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIProgressView *progressView;
    double fProgress;
}

- (IBAction)back:(id)sender;
- (IBAction)fromPhotosAlbum:(id)sender;
- (IBAction)fromCamera:(id)sender;
- (IBAction)fromVideo:(id)sender;
- (IBAction)commit:(id)sender;


@end
