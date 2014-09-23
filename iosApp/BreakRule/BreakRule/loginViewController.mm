//
//  loginViewController.m
//  BreakRule
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "loginViewController.h"
#import "ProjectViewController.h"

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

//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.g_int = 10;
    
//    string sIp = getIPWithHostName("www.myxiu.com");
//    string sIp = getIPWithHostName("s911322.eicp.net");
    NSString *server = serverIpField.text;
    string sServer = [server UTF8String];
    
    NSString *user = userField.text;
    string sUser = [user UTF8String];
    
    NSString *pwd = pwdField.text;
    string sPwd = [pwd UTF8String];
    
    if( sServer.empty() )
    {
        [self MessageBox:@"请输入服务器域名或IP地址"];
        return;
    }
    if( sUser.empty() || sPwd.empty() )
    {
        [self MessageBox:@"请输入用户名和密码"];
        return;
    }
    
    string sIp;
    if ( !util::isIp( sServer.c_str() ) )
    {
        sIp = getIPWithHostName(sServer);
    }
    else
    {
        sIp = sServer;
    }

    ONEICE
    oneIce.g_db->setServer(sIp.c_str(), 8840);
    
    if( !oneIce.g_db->isLogin() )
    {
        if( !oneIce.g_db->login() )
        {
            //        NSLog(@"数据库连接失败！");
            [self MessageBox:@"服务器连接失败"];
            return;
        }
        NSLog(@"数据库连接成功！");
    }
    
    string strSQL="";
	string strError;
    CSelectHelp	helpUser;
    
    util::string_format(strSQL, "select * from T_USER where login_name='%s' and pwd='%s' ", sUser.c_str(), sPwd.c_str());
    oneIce.g_db->select(strSQL, helpUser, strError);

    if( helpUser.size() <= 0 )
    {
        [self MessageBox:@"用户名或者密码错误"];
        return;
    }
    NSLog(@"用户登录成功！");
    
    ProjectViewController *projectView = [self.storyboard instantiateViewControllerWithIdentifier:@"projectView"];
    [self presentViewController:projectView animated:YES completion:nil];
/*
    string sName;
    for( int j=0; j<helpUser.size(); ++j )
    {
        sName = helpUser.valueString( j, "org_name" );
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
*/
}

- (IBAction)backGround:(id)sender {
    //取消键盘
    [serverIpField resignFirstResponder];
    [userField resignFirstResponder];
    [pwdField resignFirstResponder];
}

-(void)MessageBox:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
}

-(void)changeViewController
{
    [self performSegueWithIdentifier:@"ToFirstViewController" sender:self];
}

@end
