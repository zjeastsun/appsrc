//
//  LoadView.m
//  BreakRule
//
//  Created by mac on 14-11-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "LoadView.h"

@implementation LoadView
@synthesize tipLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    activeView.hidesWhenStopped = YES;
}
- (void)startLoading
{
    [activeView startAnimating];
    tipLabel.text = NSLocalizedString(@"正在加载...",nil);
}
- (void)stopLoading
{
    [activeView stopAnimating];
    tipLabel.text = @" ";//[[NSString alloc] initWithString:MORE_STRING];
}
- (BOOL)isLoading
{
    return [activeView isAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
