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
}
- (IBAction)back:(id)sender;
- (IBAction)fromPhotosAlbum:(id)sender;
- (IBAction)fromCamera:(id)sender;
- (IBAction)fromVideo:(id)sender;


@end
