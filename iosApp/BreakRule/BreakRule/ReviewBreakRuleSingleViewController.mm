//
//  ReviewBreakRuleSingleViewController.m
//  BreakRule
//
//  Created by mac on 14-10-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ReviewBreakRuleSingleViewController.h"
#import "SingletonBridge.h"
#import "IosUtils.h"

ReviewBreakRuleSingleViewController *pReviewBR;

@interface ReviewBreakRuleSingleViewController ()

@end

@implementation ReviewBreakRuleSingleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateUI
{
    BRIDGE
    
    if( helpInfo.size()== 0 )
    {
        bHasRight = [bridge hasRight:RIGHT_BR_REVIEW_1];
        nsRightMsg = @"您没有违规初级批阅权限！" ;
        if (bHasRight) {
            [reviewContent1TextView setEditable:true];
        }
        
//        reviewContent1TextView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    }
    
    if( helpInfo.size()== 1 )
    {
        bHasRight = [bridge hasRight:RIGHT_BR_REVIEW_2];
        nsRightMsg = @"您没有违规中级批阅权限！" ;
        if (bHasRight) {
            [reviewContent2TextView setEditable:true];
        }
        reviewContent1TextView.text = [SingletonIce valueNSString:helpInfo rowForHelp:0 KeyForHelp:"review_content"];
        
    }
    
    if( helpInfo.size()== 2 )
    {
        bHasRight = [bridge hasRight:RIGHT_BR_REVIEW_3];
        nsRightMsg = @"您没有违规高级批阅权限！" ;
        if (bHasRight) {
            [reviewContent3TextView setEditable:true];
        }
        reviewContent1TextView.text = [SingletonIce valueNSString:helpInfo rowForHelp:0 KeyForHelp:"review_content"];
        reviewContent2TextView.text = [SingletonIce valueNSString:helpInfo rowForHelp:1 KeyForHelp:"review_content"];
        
    }
    
    if( helpInfo.size()== 3 )
    {
        bHasRight = [bridge hasRight:RIGHT_BR_REVIEW_4];
        nsRightMsg = @"您没有违规最高级批阅权限！" ;
        if (bHasRight) {
            [reviewContent4TextView setEditable:true];
        }
        reviewContent1TextView.text = [SingletonIce valueNSString:helpInfo rowForHelp:0 KeyForHelp:"review_content"];
        reviewContent2TextView.text = [SingletonIce valueNSString:helpInfo rowForHelp:1 KeyForHelp:"review_content"];
        reviewContent3TextView.text = [SingletonIce valueNSString:helpInfo rowForHelp:2 KeyForHelp:"review_content"];
        
    }
    orgNameTextField.text = bridge.nsReviewBR_OrgNameSelected;
    
    
    
}

- (void)updateUIPic
{
    BRIDGE
    
    NSString *nsDesPathName = [SingletonIce getFullTempPathName:bridge.nsReviewBR_PicNameSelected];
    //获取保存得图片
    
    UIImage *img = [UIImage imageWithContentsOfFile:nsDesPathName];
    [IosUtils fixOrientation:img];
    imageView.image = img;
    
    [actView stopAnimating];
    [actView setHidden:YES];
    [self clearState];
}

- (void)clearState
{
    [progressView setProgress:0];
    [progressView setHidden:YES];
    
    bTransmit = false;
    [progressLabel setHidden:YES];
}

- (void)updateUIProcess
{
    [progressView setProgress:fProgress/100];
    progressLabel.text = [NSString stringWithFormat:@"已下载:%0.0f%%", fProgress ];
    
}

void downloadProcessFinishedForReviewBR(string path, int iResult, const string &sError)
{
	printf("finished %s-- %d,%s", path.c_str(), iResult, sError.c_str());
    
}

void downloadProcessForReviewBR(string path, double iProgress)
{
	printf("  %s-- %0.2f ", path.c_str(), iProgress );
    pReviewBR->fProgress = iProgress;
    [pReviewBR performSelectorOnMainThread:@selector(updateUIProcess) withObject:nil waitUntilDone:NO];
    
}

bool downloadSetBreakSignal()
{
	return !pReviewBR->bTransmit;
    
}

- (void)queryReview
{
    ONEICE

    string strError;
    int iResult = [oneIce getReviewBreakRuleSingle:helpInfo error:strError];
    if( iResult<0 )
    {
        [IosUtils MessageBox:"请重新刷新页面！" withTitle:"网络错误"];
        return;
    }
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}

- (void)getReviewPic
{
    BRIDGE
    ONEICE
    
    bool bFileExits = [SingletonIce fileExistsInTemp:bridge.nsReviewBR_PicNameSelected];
    
    if ( !bFileExits ) {
        bool bResult = [oneIce downloadFile:bridge.nsReviewBR_PicNameSelected Callback:downloadProcessForReviewBR DoneCallback:downloadProcessFinishedForReviewBR setBreakSignal:downloadSetBreakSignal];
        
        [actView stopAnimating];
        [actView setHidden:YES];
        
        if (!bResult) {
            //            [IosUtils MessageBox:@"图片下载失败！"];
            [self clearState];
            return;
        }
    }
    
    [self performSelectorOnMainThread:@selector(updateUIPic) withObject:nil waitUntilDone:NO];
    
    
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
    
    pReviewBR = self;
    
    [self addTapGuestureForImageView:imageView];
    [IosUtils addTapGuestureForKeyOnView:self.view];
    // 注册通知，当键盘将要弹出时执行keyboardWillShow方法。
    [self registerObserverForKeyboard];
    
    BRIDGE
    
    title = [[NSMutableArray alloc]initWithObjects:@"审核状态", nil];
    subTitle = [[NSMutableArray alloc]initWithObjects:@"审核通过", nil];
    bridge.nsReviewStateBR = @"审核通过";
    
    orgNameTextField.text = bridge.nsReviewBR_OrgNameSelected;
    typeTextField.text = [SingletonBridge getBreakRuleTypeNameById:bridge.nsReviewBR_BreakRuleTypeSelected];
    timeTextField.text = bridge.nsReviewBR_TimeSelected;
    breakRuleContentTextField.text = bridge.nsReviewBR_BreakRuleContentSelected;
    
    [actView setHidden:NO];
    [actView startAnimating];
    
    [progressView setProgress:0];
    bTransmit = true;
    progressLabel.text = @"正在加载...";
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryReview) object:nil];
    [thread start];
    
    NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(getReviewPic) object:nil];
    [thread1 start];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
//    [superview DidAppear:animated];
    scrollView.frame = CGRectMake(0, 0, kWidthOfMainScreen, kHeightOfMainScreen);
    [scrollView setContentSize:CGSizeMake(kWidthOfMainScreen, kHeightOfMainScreen + 220)];
    
    //重新载入所有数据
    [stateTableView reloadData];
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

- (IBAction)back:(id)sender {
    bTransmit = false;
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (bool)getReviewInfo
{
    bool bResult = true;
    
    BRIDGE
    string sCurNodeId = [bridge.nsReviewBR_CurFlowNodeIdSelected UTF8String];
    int iCurNodeId = atoi(sCurNodeId.c_str());
    
    if ([bridge.nsReviewStateBR isEqualToString:@"审核通过"]) {
        util::string_format(sNextNodeId, "%d", FLOW_NODE_RECTIFY_TAKEPHOTO);
    }
    else if ([bridge.nsReviewStateBR isEqualToString:@"无法判定"])
    {
        switch (iCurNodeId) {
            case FLOW_NODE_BR_REVIEW_1:
            {
                util::string_format(sNextNodeId, "%d", FLOW_NODE_BR_REVIEW_2);
                break;
            }
            case FLOW_NODE_BR_REVIEW_2:
            {
                util::string_format(sNextNodeId, "%d", FLOW_NODE_BR_REVIEW_3);
                break;
            }
            case FLOW_NODE_BR_REVIEW_3:
            {
                util::string_format(sNextNodeId, "%d", FLOW_NODE_BR_REVIEW_4);
                break;
            }

                
            default:
            {
                [IosUtils MessageBox:"流程ID号错误" withTitle:"数据库错误"];
                bResult = false;
                break;
            }
                
        }
    }
    else//无需整改结束流程
    {
        util::string_format(sNextNodeId, "%d", FLOW_NODE_FINISH);
    }

    switch (iCurNodeId) {
        case FLOW_NODE_BR_REVIEW_1:
        {
            sReview_grade = "1";
            nsReviewContent = reviewContent1TextView.text;
            break;
        }
        case FLOW_NODE_BR_REVIEW_2:
        {
            sReview_grade = "2";
            nsReviewContent = reviewContent2TextView.text;
            break;
        }
        case FLOW_NODE_BR_REVIEW_3:
        {
            sReview_grade = "3";
            nsReviewContent = reviewContent3TextView.text;
            break;
        }
        case FLOW_NODE_BR_REVIEW_4:
        {
            sReview_grade = "4";
            nsReviewContent = reviewContent4TextView.text;
            break;
        }
            
        default:
        {
            [IosUtils MessageBox:"流程ID号错误" withTitle:"数据库错误"];
            bResult = false;
            break;
            
        }
    }
    
    return bResult;
    
}

- (void)insertInfoToDb:(NSString *)param
{
    ONEICE
    
    string strError;
   
    bool bResult = [oneIce putBRReview:nsReviewContent grade:sReview_grade nextNodeId:sNextNodeId error:strError];
    if( !bResult )
    {
//        [IosUtils MessageBox:strError withTitle:"数据库错误"];
        return;
    }
    
    [self back:nil];
}

- (IBAction)save:(id)sender {
    
    if (!bHasRight) {
        [IosUtils MessageBox:nsRightMsg ];
        return;
    }
    if( ![self getReviewInfo] ) return;
    
    if ( [nsReviewContent length] == 0) {
        [IosUtils MessageBox:"请输入批阅内容！" withTitle:"错误"];
        return;
    }
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(insertInfoToDb:) object:nil];
    [thread start];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    tableView.contentInset = UIEdgeInsetsMake( 0, 0, 0, 0);//有导航条的时候调整表头位置
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
    }
    UIImage *ima = [UIImage imageNamed:@"share_this_icon.png"];
    cell.imageView.image =ima;
    cell.textLabel.text = [title objectAtIndex:indexPath.row];
    
    BRIDGE
    if (bridge.nsReviewStateBR == nil || [bridge.nsReviewStateBR length] == 0)
    {
        cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
    }
    else
    {
        cell.detailTextLabel.text = bridge.nsReviewStateBR;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRIDGE
    
    string sCurNodeId = [bridge.nsReviewBR_CurFlowNodeIdSelected UTF8String];
    int iCurNodeId = atoi(sCurNodeId.c_str());
    if (FLOW_NODE_BR_REVIEW_4 == iCurNodeId) {
        bridge.nsWhoUseReviewStateViewController = @"ReviewBreakRuleSingleViewControllerForHighest";//最高级批阅
    }
    else
    {
        bridge.nsWhoUseReviewStateViewController = @"ReviewBreakRuleSingleViewController";
    }
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewStateView"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textViewSelected = textView;
    [self adjustViewForKeyboardReveal:YES textView:textViewSelected];
    
}
/**
 * 键盘展开/收起时，动态调整当前scrollView高度，避免键盘挡住当前textView。
 * @param  showKeyboard    键盘是否弹出
 * @param  textView       当前textView
 */
- (void)adjustViewForKeyboardReveal:(BOOL)showKeyboard textView:(UITextView *)textView
{
    // 获取当前scrollView frame，当键盘弹出时，当前scrollView frame上移一定高度。
    CGRect scrollFrame = scrollView.frame;
    // 如果用户通过点击空白区域收起键盘，视图坐标恢复正常。
    if (!textView) {
        scrollFrame.origin.y = 0;
        [self viewChangeOriginYAnimation:scrollFrame];
        return;
    }
    // 键盘弹出，重新计算scrollView y轴。
    if (showKeyboard) {
        float offsetTop = ABS(scrollView.contentOffset.y) + ABS(scrollView.frame.origin.y);
        // 计算当前textField底部空间高度，如果当前textField下部的空间足以容纳弹出键盘，则不改变当前view高度。
        float bottomHeight = kHeightOfMainScreen + offsetTop - textView.frame.origin.y - textView.frame.size.height;
        
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
}

/** 键盘收起通知方法，动态调整当前scrollView高度。 */
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self adjustViewForKeyboardReveal:NO textView:textViewSelected];
}


@end
