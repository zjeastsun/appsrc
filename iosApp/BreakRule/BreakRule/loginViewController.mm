//
//  loginViewController.m
//  BreakRule
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "loginViewController.h"
#import"eutils.h"
#import <netdb.h>
#include <arpa/inet.h>

@interface loginViewController ()

@end

@implementation loginViewController

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

string getIPWithHostName(string hostName)
{
    struct hostent *remoteHostEnt = gethostbyname(hostName.c_str());
    struct in_addr *remoteInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[0];
    char *sRemoteInAddr = inet_ntoa(*remoteInAddr);
    return sRemoteInAddr;
}

- (IBAction)login:(id)sender {
    CICEDBUtil g_db;
    if( g_db.isLogin() ) return;
    
    string sIp = getIPWithHostName("www.myxiu.com");
    
//    g_db.setServer(sIp.c_str(), 8840);
    g_db.setServer("192.168.0.58", 8840);
    if( !g_db.login() )
    {
        NSLog(@"数据库连接失败！");
        return;
    }
    NSLog(@"数据库连接成功！");
}
@end
