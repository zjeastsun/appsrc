//
//  BreakRuleTakePhotoViewController.h
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "SingletonBridge.h"

@interface BreakRuleTakePhotoViewController : UIViewController<CLLocationManagerDelegate>{
    NSMutableArray *title;
    NSMutableArray *subTitle;
    UIImagePickerController *imagePicker;
    IBOutlet UIImageView *imageView;
    IBOutlet UITableView *ruleTableView;
    IBOutlet UITextView *contentTextView;

    NSString *nsBreakRuleType;
    
    
    /** 弹出键盘fame */
    CGRect keyboardRect;
    UITextView *textViewSelected;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIProgressView *progressView;
    double fProgress;
    
    CLLocationManager* locationManager;
    
    NSDictionary* curMediaInfo;//当前照片的mediaInfo
    UIImage* curImage;//当前照片
    
    bool bFromPhotosAlbum;//照片是否来自照片库
    
    PHOTOINFO stPhotoInfo;
}

- (IBAction)back:(id)sender;
- (IBAction)fromPhotosAlbum:(id)sender;
- (IBAction)fromCamera:(id)sender;
- (IBAction)fromVideo:(id)sender;
- (IBAction)commit:(id)sender;


@end
