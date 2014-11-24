//
//  QuerySingleViewController.m
//  BreakRule
//
//  Created by mac on 14-11-5.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "QuerySingleViewController.h"
#import "SingletonBridge.h"
#import "IosUtils.h"

QuerySingleViewController *pQueryView;

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

- (void)addTapGuestureForImageView:(UIImageView *)imaView
{
    imaView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    [imaView addGestureRecognizer:tap];
}

- (void)magnifyImage:(UITapGestureRecognizer*)tapGr
{
    UIImageView *imaView= (UIImageView*) tapGr.view;
    NSLog(@"局部放大");
    if (imaView.image != nil) {
        BRIDGE
        bridge.image = imaView.image;
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MagnifyImageView"];
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addTapGuestureForImageView:imageView];
    [self addTapGuestureForImageView:imageViewRectify];
    
    pQueryView = self;
    
    BRIDGE
    
    orgNameTextField.text = bridge.nsQuery_OrgNameSelected;
    typeTextField.text = [SingletonBridge getBreakRuleTypeNameById:bridge.nsQuery_BreakRuleTypeSelected];
    timeTextField.text = bridge.nsQuery_TimeSelected;
    breakRuleContentTextField.text = bridge.nsQuery_BreakRuleContentSelected;
    
    [actView setHidden:NO];
    [actView startAnimating];
    
    [rectifyActView setHidden:NO];
    [rectifyActView startAnimating];
    
    [progressViewBR setProgress:0];
    bTransmitBR = true;
    progressLabelBR.text = @"正在加载...";
    [progressViewRectify setProgress:0];
    bTransmitRectify = true;
    progressLabelRectify.text = @"正在加载...";
    
    NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(queryRectifyInfo) object:nil];
    [thread1 start];
    
    NSThread *thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(getReviewPic) object:nil];
    [thread2 start];
    
    

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

- (void)queryRectifyInfo
{
    BRIDGE
    ONEICE
    
    string strError;
    
    int iResult = [oneIce getRectifySingle:helpRectifyInfo breakRuleId:bridge.nsQuery_BreakRuleIdSelected error:strError];
    if( iResult<0 )
    {
//        [IosUtils MessageBox:strError withTitle:"数据库错误"];
        return;
    }
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    
    NSThread *thread3 = [[NSThread alloc]initWithTarget:self selector:@selector(getRectifyPic) object:nil];
    [thread3 start];
}

- (void)updateUIBRPic
{
    BRIDGE
    
    NSString *nsDesPathName = [SingletonIce getFullTempPathName:bridge.nsQuery_PicNameSelected];
    //获取保存得图片
    
    UIImage *img = [UIImage imageWithContentsOfFile:nsDesPathName];
    [IosUtils fixOrientation:img];
    imageView.image = img;
    
    [actView stopAnimating];
    [actView setHidden:YES];
    
    [self clearStateBR];
}

- (void)clearStateBR
{
    [progressViewBR setProgress:0];
    [progressViewBR setHidden:YES];
    
    bTransmitBR = false;
    [progressLabelBR setHidden:YES];
}

- (void)updateUIProcessBR
{
    [progressViewBR setProgress:fProgressBR/100];
    progressLabelBR.text = [NSString stringWithFormat:@"已下载:%0.0f%%", fProgressBR ];
    
}

void downProcessFinishedForQueryBR(string path, int iResult, const string &sError)
{
	printf("finished %s-- %d,%s", path.c_str(), iResult, sError.c_str());
    
}

void downProcessForQueryBR(string path, double iProgress)
{
	printf("  %s-- %0.2f ", path.c_str(), iProgress );
    pQueryView->fProgressBR = iProgress;
    [pQueryView performSelectorOnMainThread:@selector(updateUIProcessBR) withObject:nil waitUntilDone:NO];
    
}

bool downSetBreakSignalQueryBR()
{
	return !pQueryView->bTransmitBR;
    
}

- (void)getReviewPic
{
    BRIDGE
    ONEICE
    
    bool bFileExits = [SingletonIce fileExistsInTemp:bridge.nsQuery_PicNameSelected];
    
    bool bResult;
    if ( !bFileExits ) {
        bResult = [oneIce downloadFile:bridge.nsQuery_PicNameSelected Callback:downProcessForQueryBR DoneCallback:downProcessFinishedForQueryBR setBreakSignal:downSetBreakSignalQueryBR];
        
        [actView stopAnimating];
        [actView setHidden:YES];
        
        if (!bResult) {
            //            [IosUtils MessageBox:@"违规图片下载失败！"];
            return;
        }
    }
    [self performSelectorOnMainThread:@selector(updateUIBRPic) withObject:nil waitUntilDone:NO];
    
}

- (void)updateUIRectifyPic
{
    BRIDGE
    
    NSString *nsRectifyPicName = [SingletonIce valueNSString:helpRectifyInfo rowForHelp:0 KeyForHelp:"pic_name"];
    NSString *nsDesPathNameRectify = [SingletonIce getFullTempPathName:nsRectifyPicName];
    //获取保存得图片
    
    UIImage *imgRectify = [UIImage imageWithContentsOfFile:nsDesPathNameRectify];
    [IosUtils fixOrientation:imgRectify];
    imageViewRectify.image = imgRectify;
    
    [rectifyActView stopAnimating];
    [rectifyActView setHidden:YES];
    
    [self clearStateRectify];
}

- (void)clearStateRectify
{
    [progressViewRectify setProgress:0];
    [progressViewRectify setHidden:YES];
    
    bTransmitRectify = false;
    [progressLabelRectify setHidden:YES];
}

- (void)updateUIProcessRectify
{
    [progressViewRectify setProgress:fProgressRectify/100];
    progressLabelRectify.text = [NSString stringWithFormat:@"已下载:%0.0f%%", fProgressRectify ];
    
}

void downProcessFinishedForQueryRectify(string path, int iResult, const string &sError)
{
	printf("finished %s-- %d,%s", path.c_str(), iResult, sError.c_str());
    
}

void downProcessForQueryRectify(string path, double iProgress)
{
	printf("  %s-- %0.2f ", path.c_str(), iProgress );
    pQueryView->fProgressRectify = iProgress;
    [pQueryView performSelectorOnMainThread:@selector(updateUIProcessRectify) withObject:nil waitUntilDone:NO];
    
}

bool downSetBreakSignalQueryRectify()
{
	return !pQueryView->bTransmitRectify;
    
}

- (void)getRectifyPic
{
    BRIDGE
    ONEICE
    
    NSString *nsRectifyPicName = [SingletonIce valueNSString:helpRectifyInfo rowForHelp:0 KeyForHelp:"pic_name"];
    bool bFileExits = [SingletonIce fileExistsInTemp:nsRectifyPicName];
    
    if ( !bFileExits ) {
        bool bResult = [oneIce downloadFile:nsRectifyPicName Callback:downProcessForQueryRectify DoneCallback:downProcessFinishedForQueryRectify setBreakSignal:downSetBreakSignalQueryRectify];
        
        [rectifyActView stopAnimating];
        [rectifyActView setHidden:YES];
        
        if (!bResult) {
            //            [IosUtils MessageBox:@"整改图片下载失败！"];
            return;
        }
    }
    
    [self performSelectorOnMainThread:@selector(updateUIRectifyPic) withObject:nil waitUntilDone:NO];
    
    
    
}

- (IBAction)back:(id)sender {
    bTransmitBR = false;
    bTransmitRectify = false;
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}



@end
