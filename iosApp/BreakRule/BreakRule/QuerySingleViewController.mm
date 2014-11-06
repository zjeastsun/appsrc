//
//  QuerySingleViewController.m
//  BreakRule
//
//  Created by mac on 14-11-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "QuerySingleViewController.h"
#import "SingletonBridge.h"

@interface QuerySingleViewController ()

@end

@implementation QuerySingleViewController

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
    BRIDGE
    
    orgNameTextField.text = bridge.nsQuery_OrgNameSelected;
    typeTextField.text = [SingletonBridge getBreakRuleTypeNameById:bridge.nsQuery_BreakRuleTypeSelected];
    timeTextField.text = bridge.nsQuery_TimeSelected;
    breakRuleContentTextField.text = bridge.nsQuery_BreakRuleContentSelected;
    
    [actView setHidden:NO];
    [actView startAnimating];
    
    [rectifyActView setHidden:NO];
    [rectifyActView startAnimating];
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryReview) object:nil];
    [thread start];
    
    NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(queryRectifyInfo) object:nil];
    [thread1 start];

    scrollView.frame = CGRectMake(0, 0, kWidthOfMainScreen, kHeightOfMainScreen);
    [scrollView setContentSize:CGSizeMake(kWidthOfMainScreen, kHeightOfMainScreen + 220)];
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
- (void)updateUI
{
    BRIDGE
    
    rectifyContentTextField.text = [SingletonIce valueNSString:helpRectifyInfo rowForHelp:0 KeyForHelp:"rectify_content"];
    flowState.text = bridge.nsQuery_CurFlowNodeNameSelected;
    rectifyTimeTextField.text = [SingletonIce valueNSString:helpRectifyInfo rowForHelp:0 KeyForHelp:"update_time"];
}

- (void)queryReview
{
    BRIDGE
    ONEICE
    
    bool bFileExits = [SingletonIce fileExistsInTemp:bridge.nsQuery_PicNameSelected];
    
    bool bResult;
    if ( !bFileExits ) {
        bResult = [oneIce downloadFile:bridge.nsQuery_PicNameSelected Callback:nil DoneCallback:nil];
        
        [actView stopAnimating];
        [actView setHidden:YES];
        
        if (!bResult) {
            [SingletonBridge MessageBox:@"违规图片下载失败！"];
            return;
        }
    }
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    
    NSString *nsDesPathName = [SingletonIce getFullTempPathName:bridge.nsQuery_PicNameSelected];
    //获取保存得图片
    
    UIImage *img = [UIImage imageWithContentsOfFile:nsDesPathName];
    imageView.image = img;
    
    [actView stopAnimating];
    [actView setHidden:YES];
    
}

- (void)queryRectifyInfo
{
    BRIDGE
    ONEICE
    
    string strError;
    string strParam="";
    string sqlcode="get_br_rectify_info";
    SelectHelpParam helpParam;
    
    string sId = [bridge.nsQuery_BreakRuleIdSelected UTF8String];
    
    int iResult;
    bool bResult;
    
    iResult = oneIce.g_db->selectCmd("", sqlcode, sId, helpRectifyInfo, strError);
    if( iResult<0 )
    {
        [SingletonBridge MessageBox:strError withTitle:"数据库错误"];
        return;
    }
    
    NSString *nsRectifyPicName = [SingletonIce valueNSString:helpRectifyInfo rowForHelp:0 KeyForHelp:"pic_name"];
    bool bFileExits = [SingletonIce fileExistsInTemp:nsRectifyPicName];
    
    if ( !bFileExits ) {
        bResult = [oneIce downloadFile:nsRectifyPicName Callback:nil DoneCallback:nil];
        
        [rectifyActView stopAnimating];
        [rectifyActView setHidden:YES];
        
        if (!bResult) {
            [SingletonBridge MessageBox:@"整改图片下载失败！"];
            return;
        }
    }
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    
    NSString *nsDesPathNameRectify = [SingletonIce getFullTempPathName:nsRectifyPicName];
    //获取保存得图片
    
    UIImage *imgRectify = [UIImage imageWithContentsOfFile:nsDesPathNameRectify];
    imageViewRectify.image = imgRectify;
    
    [rectifyActView stopAnimating];
    [rectifyActView setHidden:YES];
    
}

- (IBAction)back:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}



@end
