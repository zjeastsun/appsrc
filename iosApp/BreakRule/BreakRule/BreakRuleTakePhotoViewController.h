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
}
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *optionTable;

@end
