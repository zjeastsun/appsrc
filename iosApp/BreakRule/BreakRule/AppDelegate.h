//
//  AppDelegate.h
//  BreakRule
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import"eutils.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    int g_int;
//    CICEDBUtil g_db;
}

@property (nonatomic) int g_int;
//@property (nonatomic) CICEDBUtil g_db;
@property (strong, nonatomic) UIWindow *window;

@end
