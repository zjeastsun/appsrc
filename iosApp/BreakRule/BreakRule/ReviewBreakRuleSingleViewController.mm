//
//  ReviewBreakRuleSingleViewController.m
//  BreakRule
//
//  Created by mac on 14-10-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ReviewBreakRuleSingleViewController.h"
#import "SingletonBridge.h"

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
- (void)queryReview
{
    BRIDGE
    ONEICE

    orgNameTextField.text = bridge.nsReviewBR_OrgNameSelected;
    
    string strError;
    string strParam="";
    string sqlcode="get_br_review";
    SelectHelpParam helpParam;
    
    string sId = [bridge.nsReviewBR_BreakRuleIdSelected UTF8String];
    
    oneIce.g_db->selectCmd("", sqlcode, sId, helpInfo, strError);

    if( helpInfo.size()== 0 )
    {
        [reviewContent1TextView setEditable:true];
    }
    
    if( helpInfo.size()== 1 )
    {
        reviewContent1TextView.text = [SingletonIce valueNSString:helpInfo rowForHelp:0 KeyForHelp:"review_content"];
        [reviewContent2TextView setEditable:true];
    }
    
    if( helpInfo.size()== 2 )
    {
        reviewContent2TextView.text = [SingletonIce valueNSString:helpInfo rowForHelp:1 KeyForHelp:"review_content"];
        [reviewContent3TextView setEditable:true];
    }
    
    if( helpInfo.size()== 3 )
    {
        reviewContent3TextView.text = [SingletonIce valueNSString:helpInfo rowForHelp:2 KeyForHelp:"review_content"];
        [reviewContent4TextView setEditable:true];
    }
    
    //下载图片？
    {
    }

}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    title = [[NSMutableArray alloc]initWithObjects:@"审核状态", nil];
    subTitle = [[NSMutableArray alloc]initWithObjects:@"审核通过", nil];
    
    BRIDGE
    orgNameTextField.text = bridge.nsReviewBR_OrgNameSelected;
    
    if ([bridge.nsReviewBR_BreakRuleTypeSelected isEqualToString:@"0"]) {
        typeTextField.text = @"一般违规";
    }
    else if ([bridge.nsReviewBR_BreakRuleTypeSelected isEqualToString:@"1"]) {
        typeTextField.text = @"严重违规";
    }
    else if ([bridge.nsReviewBR_BreakRuleTypeSelected isEqualToString:@"2"]) {
        typeTextField.text = @"重大违规";
    }
    
    timeTextField.text = bridge.nsReviewBR_TimeSelected;
    breakRuleContentTextField.text = bridge.nsReviewBR_BreakRuleContentSelected;
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryReview) object:nil];
    [thread start];
    
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
    scrollView.frame = CGRectMake(0, 0, 320, 480);
    [scrollView setContentSize:CGSizeMake(320, 700)];
    
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
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (string)getNextNodeId
{
    string sNextNodeId;
    
    BRIDGE
    string sCurId = [bridge.nsReviewBR_CurFlowNodeIdSelected UTF8String];
    int iCurId = atoi(sCurId.c_str());
    
    if ([bridge.nsReviewState isEqualToString:@"审核通过"]) {
        util::string_format(sNextNodeId, "%d", FLOW_NODE_RECTIFY_TAKEPHOTO);
    }
    else if ([bridge.nsReviewState isEqualToString:@"无法判定"])
    {
        switch (iCurId) {
            case FLOW_NODE_BR_REVIEW_1:
            {
                util::string_format(sNextNodeId, "%d", FLOW_NODE_BR_REVIEW_2);
                sReview_grade = "1";
                break;
            }
            case FLOW_NODE_BR_REVIEW_2:
            {
                util::string_format(sNextNodeId, "%d", FLOW_NODE_BR_REVIEW_3);
                sReview_grade = "2";
                break;
            }
            case FLOW_NODE_BR_REVIEW_3:
            {
                util::string_format(sNextNodeId, "%d", FLOW_NODE_BR_REVIEW_4);
                sReview_grade = "3";
                break;
            }
            case FLOW_NODE_BR_REVIEW_4:
            {
                //最高级不能选择“无法判定”
                sReview_grade = "4";
                break;
            }
                
            default:
                break;
        }
    }
    else
    {
        util::string_format(sNextNodeId, "%d", FLOW_NODE_FINISH);
    }

    return sNextNodeId;
}

- (void)insertInfoToDb:(NSString *)param
{
    ONEICE
    BRIDGE
    
    string strError;
    string strParam="";
    const string sqlcode="put_br_review";
    
    string sReviewId = "";
    oneIce.g_db->command("get_sequence", "review_id", sReviewId);
    
    string sNodeId = [self getNextNodeId];
    string sBreakRuleId = [bridge.nsReviewBR_BreakRuleIdSelected UTF8String];
    string sUserId = [bridge.nsUserId UTF8String];
    string sRectifyId = "0";
    
    string sReviewContent = [SingletonIce NSStringToGBstring:reviewContent1TextView.text];
    
    SelectHelpParam helpParam;
    helpParam.add(sReviewId);
    helpParam.add(sBreakRuleId);
    helpParam.add(sUserId);
    helpParam.add(sReviewContent);
    helpParam.add(sReview_grade);
    helpParam.add(sRectifyId);
    strParam = helpParam.get();
    
    CSelectHelp	help;
    oneIce.g_db->execCmd("", sqlcode, strParam, help, strError);

}

- (IBAction)save:(id)sender {
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
    if (bridge.nsReviewState == nil || [bridge.nsReviewState length] == 0)
    {
        cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
    }
    else
    {
        cell.detailTextLabel.text = bridge.nsReviewState;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewStateView"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   
}



@end
