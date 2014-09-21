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
    
//    string sIp = getIPWithHostName("www.myxiu.com");
    string sIp = getIPWithHostName("s911322.eicp.net");
    
    g_db.setServer(sIp.c_str(), 8840);

    if( !g_db.login() )
    {
        NSLog(@"数据库连接失败！");
        return;
    }
    NSLog(@"数据库连接成功！");
    
    string strSQL="";
	string strError;
    CSelectHelp		g_helpProvince;
    
    util::string_format(strSQL, "select org_name from T_ORGANIZATION  order by org_id");
    g_db.select(strSQL, g_helpProvince, strError);

    string sName;
    for( int j=0; j<g_helpProvince.size(); ++j )
    {
        sName = g_helpProvince.valueString( j, "org_name" );
        char * ss =const_cast<char*>(sName.c_str());
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *str = [NSString stringWithCString:(char*)ss encoding:enc];
//        const char *ss ="东太";
//        
//        char p_OutBuf[30];
//        int p_OutSize = 30;
//        CSystemUtil::CodeChange(ss,p_OutBuf,&p_OutSize,"utf-8","gb2312");

//        NSData *data = [NSData dataWithBytes: ss   length:strlen(ss)];
//        NSString *str=[[NSString alloc]initWithData:data encoding:NSUnicodeStringEncoding];
//        NSString *str = [NSString stringWithCString:(char*)ss encoding:NSUTF8StringEncoding];
        NSLog(@"组织机构：%@", str);

    }

}

@end
