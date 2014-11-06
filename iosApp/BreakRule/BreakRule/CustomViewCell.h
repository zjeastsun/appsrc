//自定义TableViewCell
//  CustomViewCell.h
//  BreakRule
//
//  Created by mac on 14-10-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewCell : UITableViewCell
{
    UILabel* titleLabel_;
    UILabel* descLabel_;
    UILabel* timeLabel_;
    UILabel* statusLabel_;
    UIImageView* iconView_;
    UIImageView* statusView_;
    UIImageView* rightIcon_;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@end
