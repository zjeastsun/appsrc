//
//  loginViewController.m
//  BreakRule
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "loginViewController.h"

#import <netdb.h>
#include <arpa/inet.h>

#import "SingletonBridge.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [self addTapGuestureOnView];
    // 注册通知，当键盘将要弹出时执行keyboardWillShow方法。
    [self registerObserverForKeyboard];
    
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

- (void)dbHandleThread:(NSString *) param
{
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
    
    //    sIp = "192.168.3.109";
    
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
    
	string strError;
    string strParam="";
    const string sqlcode="login_check";
    
    SelectHelpParam helpParam;
    helpParam.add(sUser);
    helpParam.add(sPwd);
    strParam = helpParam.get();
    
    CSelectHelp	helpUser;
    oneIce.g_db->selectCmd("", sqlcode, strParam, helpUser, strError);
    
    if( helpUser.size() <= 0 )
    {
        [self MessageBox:@"用户名或者密码错误"];
        return;
    }
    NSLog(@"用户登录成功！");
    
    BRIDGE
    oneIce.g_db->selectCmd("", "get_user_info", sUser, helpUser, strError);
    if (helpUser.size()>0) {
        string sOrgId = helpUser.valueString( 0, "org_id" );
        char *temp =const_cast<char*>(sOrgId.c_str());
        
        bridge.nsOrgId = [NSString stringWithCString:temp encoding:NSASCIIStringEncoding];
        
        bridge.nsUserId = [NSString stringWithCString:const_cast<char*>(helpUser.valueString( 0, "user_id" ).c_str()) encoding:NSASCIIStringEncoding];
        bridge.nsLoginName = userField.text;
        
        NSLog(@"组织ID：%@", bridge.nsOrgId);
        
    }
    
    CSelectHelp	helpRight;
    oneIce.g_db->selectCmd("", "get_right", sUser, helpRight, strError);
    if (helpRight.size()>0) {
        bridge.helpRight.copy(helpRight);
    }
    
    UIViewController *projectView = [self.storyboard instantiateViewControllerWithIdentifier:@"projectView"];
    [self presentViewController:projectView animated:YES completion:nil];
}

- (IBAction)login:(id)sender {

//    UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"projectView"];
//    [self presentViewController:view animated:YES completion:nil];
//    
//    return;
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(dbHandleThread:) object:nil];
    [thread start];
    return;
    //    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.g_int = 10;
    
//    string sIp = getIPWithHostName("www.myxui.com");
//    string sIp = getIPWithHostName("s911322.eicp.net");
//    string sIp = getIPWithHostName("192.168.3.109");
  /*
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
    
	string strError;
    string strParam="";
    const string sqlcode="login_check";
    
    SelectHelpParam helpParam;
    helpParam.add(sUser);
    helpParam.add(sPwd);
    strParam = helpParam.get();
    
    CSelectHelp	helpUser;
    oneIce.g_db->selectCmd("", sqlcode, strParam, helpUser, strError);

    if( helpUser.size() <= 0 )
    {
        [self MessageBox:@"用户名或者密码错误"];
        return;
    }
    NSLog(@"用户登录成功！");
    
    BRIDGE
    oneIce.g_db->selectCmd("", "get_user_info", sUser, helpUser, strError);
    if (helpUser.size()>0) {
        string sOrgId = helpUser.valueString( 0, "org_id" );
        char *temp =const_cast<char*>(sOrgId.c_str());
        
        bridge.nsOrgId = [NSString stringWithCString:temp encoding:NSASCIIStringEncoding];

        bridge.nsUserId = [NSString stringWithCString:const_cast<char*>(helpUser.valueString( 0, "user_id" ).c_str()) encoding:NSASCIIStringEncoding];
        bridge.nsLoginName = userField.text;
        
        NSLog(@"组织ID：%@", bridge.nsOrgId);
        
    }
    
    CSelectHelp	helpRight;
    oneIce.g_db->selectCmd("", "get_right", sUser, helpRight, strError);
    if (helpRight.size()>0) {
        bridge.helpRight.copy(helpRight);
    }
    
    UIViewController *projectView = [self.storyboard instantiateViewControllerWithIdentifier:@"projectView"];
    [self presentViewController:projectView animated:YES completion:nil];
   */
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

- (void)viewDidAppear:(BOOL)animated
{
    //    [superview DidAppear:animated];
    scrollView.frame = CGRectMake(0, 0, 320, kHeightOfMainScreen);
//    [scrollView setContentSize:CGSizeMake(320, 700)];

}

- (bool)textFieldShouldBeginEditing:(UITextField *)textField
{
    textFieldSelected = textField;
    [self adjustViewForKeyboardReveal:YES textField:textFieldSelected];
    return YES;
}
/** 处理键盘“return”按钮点击事件 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self adjustViewForKeyboardReveal:NO textField:textField];
    return YES;
}
/**
 * 键盘展开/收起时，动态调整当前scrollView高度，避免键盘挡住当前textView。
 * @param  showKeyboard    键盘是否弹出
 * @param  textView       当前textView
 */
- (void)adjustViewForKeyboardReveal:(BOOL)showKeyboard textField:(UITextField *)textField
{
    // 获取当前scrollView frame，当键盘弹出时，当前scrollView frame上移一定高度。
    CGRect scrollFrame = scrollView.frame;
    // 如果用户通过点击空白区域收起键盘，视图坐标恢复正常。
    if (!textField) {
        scrollFrame.origin.y = 0;
        [self viewChangeOriginYAnimation:scrollFrame];
        return;
    }
    // 键盘弹出，重新计算scrollView y轴。
    if (showKeyboard) {
        float offsetTop = ABS(scrollView.contentOffset.y) + ABS(scrollView.frame.origin.y);
        // 计算当前textField底部空间高度，如果当前textField下部的空间足以容纳弹出键盘，则不改变当前view高度。
        float bottomHeight = kHeightOfMainScreen + offsetTop - textField.frame.origin.y - textField.frame.size.height;
        
        if (bottomHeight >= keyboardRect.size.height) {
            return;
        }
        // 计算view Y轴位移量，使得弹出键盘和当前textField的距离等于指定值。
        scrollFrame.origin.y -= keyboardRect.size.height + kTextViewPadding - bottomHeight;
    }
    // 当键盘收起时，当前视图frame Y轴置为0。
    else {
        scrollFrame.origin.y = 0;
    }
    [self viewChangeOriginYAnimation:scrollFrame];
}

/**
 * view改变y坐标时，增加动画效果。
 * @param viewFrame view视图的新frame
 */
- (void)viewChangeOriginYAnimation:(CGRect)viewFrame
{
    // 视图上移/下移动画
    [UIView beginAnimations:kAnimationResizeForKeyboard context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    
    scrollView.frame = viewFrame;
    [UIView commitAnimations];
}

/** 注册通知，当键盘将要弹出/收起时执行keyboardWillShow/keyboardWillHide方法。 */
- (void)registerObserverForKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/** 键盘弹出通知方法，设置全局弹出键盘fame属性，并动态调整当前scrollView高度。 */
- (void)keyboardWillShow:(NSNotification *)notification
{
    // 返回通知关联的用户信息字典，从中取出弹出键盘尺寸信息。
    NSDictionary *userInfo = [notification userInfo];
    // 取键盘frame的value值，从而获取键盘frame。
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardRect = [value CGRectValue];
    [self adjustViewForKeyboardReveal:YES textField:textFieldSelected];
}

/** 键盘收起通知方法，动态调整当前scrollView高度。 */
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self adjustViewForKeyboardReveal:NO textField:textFieldSelected];
}

// 当通过键盘在输入完毕后，点击屏幕空白区域关闭键盘的操作。
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

// 在view上添加一个UITapGestureRecognizer，实现点击键盘以外空白区域隐藏键盘。
- (void)addTapGuestureOnView
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    // 是否取消手势识别
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

@end
