//
//  RectifyTakePhotoViewController.h
//  BreakRule
//
//  Created by mac on 14-11-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "SingletonBridge.h"

@interface RectifyTakePhotoViewController : UIViewController
{
    UIImagePickerController *imagePicker;
    IBOutlet UITextView *breakRuleTextView;
    IBOutlet UITextView *rectifyTextView;
    IBOutlet UIImageView *breakRuleImageView;
    IBOutlet UIImageView *rectifyImageView;
    IBOutlet UIScrollView *scrollView;
    
    
    /** 弹出键盘fame */
    CGRect keyboardRect;
    UITextView *textViewSelected;
    
    IBOutlet UIProgressView *progressView;
    double fProgress;
    
    IBOutlet UIActivityIndicatorView *actView;
    
    CLLocationManager* locationManager;
    
    NSDictionary* curMediaInfo;//当前照片的mediaInfo
    UIImage* curImage;//当前照片
    
    bool bFromPhotosAlbum;//照片是否来自照片库
    
    PHOTOINFO stPhotoInfo;
}
- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)fromPhotosAlbum:(id)sender;
- (IBAction)fromCamera:(id)sender;
@end
