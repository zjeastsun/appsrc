//
//  RectifyTakePhotoViewController.h
//  BreakRule
//
//  Created by mac on 14-11-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectifyTakePhotoViewController : UIViewController
{
    UIImagePickerController *imagePicker;
    IBOutlet UITextView *breakRuleTextView;
    IBOutlet UITextView *rectifyTextView;
    IBOutlet UIImageView *breakRuleImageView;
    IBOutlet UIImageView *rectifyImageView;
    IBOutlet UIScrollView *scrollView;
    
    __block NSString *nsPhotoData;
    
    /** 弹出键盘fame */
    CGRect keyboardRect;
    UITextView *textViewSelected;
    
    IBOutlet UIProgressView *progressView;
    double fProgress;
}
- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)fromPhotosAlbum:(id)sender;
- (IBAction)fromCamera:(id)sender;
@end
