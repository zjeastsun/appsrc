//
//  ReviewBreakRuleViewController.m
//  BreakRule
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ReviewBreakRuleViewController.h"
#import "CustomViewCell.h"
#import "SingletonBridge.h"


@interface ReviewBreakRuleViewController ()

@end

@implementation ReviewBreakRuleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addTableHeaderView
{
    NSArray* viewArray = [[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil];
    loadView = [viewArray objectAtIndex:0];
    reviewTableView.tableHeaderView = loadView;
//    loadView.tipLabel.text = [[NSString alloc] initWithString:MORE_STRING];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    theLock = [[NSLock alloc] init];
    
    [self addTableHeaderView];
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

- (IBAction)back:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)condition:(id)sender {
    BRIDGE
    bridge.nsWhoUseConditionViewController = @"ReviewBreakRuleViewController";
    
    UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"conditionView"];
    [self presentViewController:view animated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return helpInfo.size();
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.contentInset = UIEdgeInsetsMake( 0, 0, 0, 0);//有导航条的时候调整表头位置
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomViewCell *cell = (CustomViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"CustomViewCell" owner:nil options:nil];
        cell =  [array objectAtIndex:0];
    }
    if (helpInfo.size() == 0)
    {
        return cell;
    }

    //定制单元格
    cell.titleLabel.text = [SingletonIce valueNSString:helpInfo rowForHelp:static_cast<int>(indexPath.row) KeyForHelp:"org_name"];
    cell.descLabel.text = [SingletonIce valueNSString:helpInfo rowForHelp:static_cast<int>(indexPath.row) KeyForHelp:"break_rule_content"];
    
    NSString *nsTime = [SingletonIce valueNSString:helpInfo rowForHelp:static_cast<int>(indexPath.row) KeyForHelp:"update_time"];
    NSString *nsSubTime = [nsTime substringWithRange:NSMakeRange(2, 14)];
    cell.timeLabel.text = nsSubTime;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)updateUI
{
    [actView stopAnimating];
    [actView setHidden:YES];
    [loadView stopLoading];
    
    [theLock lock];
    if (reviewTableView) {
        [reviewTableView reloadData];
    }
    [theLock unlock];
}

- (void)queryDb
{
    BRIDGE
    ONEICE
    
    string strError;
    string strParam="";
    string sqlcode="get_break_last_view_review";
    SelectHelpParam helpParam;
    
    if ([bridge.nsRuleTypeForReviewBR isEqualToString:@"全部"])
    {
        sqlcode = "get_break_last_view_all_review";
    }
    else
    {
        NSString *nsBreakRuleType;
        if ([bridge.nsRuleTypeForReviewBR isEqualToString:@"一般违规"]) {
            nsBreakRuleType = @"0";
        }
        else if ([bridge.nsRuleTypeForReviewBR isEqualToString:@"严重违规"])
        {
            nsBreakRuleType = @"1";
        }
        else if ([bridge.nsRuleTypeForReviewBR isEqualToString:@"重大违规"])
        {
            nsBreakRuleType = @"2";
        }
        else
        {
            nsBreakRuleType = @"0";
        }
        string sRuleType = [nsBreakRuleType UTF8String];
        helpParam.add(sRuleType);
    }
    
    if (bridge.nsReviewStartTime == nil || bridge.nsReviewEndTime == nil)
    {
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *  endDate=[NSDate date];
        bridge.nsReviewEndTime=[dateformatter stringFromDate:endDate];
        
        NSDate* startDate = [[NSDate alloc] init];
        startDate = [endDate dateByAddingTimeInterval:-60*3600*24];
        bridge.nsReviewStartTime =[dateformatter stringFromDate:startDate];
    }
    
    string sStartTime, sEndTime;
    sStartTime = [bridge.nsReviewStartTime UTF8String];
    sEndTime = [bridge.nsReviewEndTime UTF8String];
    sEndTime += " 23:59:59";
    
    helpParam.add(sStartTime);
    helpParam.add(sEndTime);
    strParam = helpParam.get();
    
    [theLock lock];
    int iResult = oneIce.g_db->selectCmd("", sqlcode, strParam, helpInfo, strError);
    [theLock unlock];
    
    if( iResult<0 )
    {
        [SingletonBridge MessageBox:strError withTitle:"数据库错误"];
//        return;
    }

    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
    BRIDGE
    if (![nsReviewStartTimeOld isEqualToString:bridge.nsReviewStartTime] || ![nsReviewEndTimeOld isEqualToString:bridge.nsReviewEndTime] || ![nsRuleTypeOld isEqualToString:bridge.nsRuleTypeForReviewBR]) {

        [actView setHidden:NO];
        [actView startAnimating];
        
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryDb) object:nil];
        [thread start];
    }
    else
    {
        return;
    }
    
    nsReviewStartTimeOld = bridge.nsReviewStartTime;
    nsReviewEndTimeOld = bridge.nsReviewEndTime;
    nsRuleTypeOld = bridge.nsRuleTypeForReviewBR;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRIDGE

    int iRow = static_cast<int>(indexPath.row);
    bridge.nsReviewBR_BreakRuleIdSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_id"];
    bridge.nsReviewBR_OrgNameSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"org_name"];
    bridge.nsReviewBR_BreakRuleTypeSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_type"];
    bridge.nsReviewBR_TimeSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"update_time"];
    bridge.nsReviewBR_BreakRuleContentSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_content"];
    bridge.nsReviewBR_CurFlowNodeIdSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"node_id"];
    bridge.nsReviewBR_PicNameSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"pic_name"];
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewBreakRuleSingleView"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    loadView.tipLabel.text = @"下拉可以刷新";
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    CGPoint contentPos = scrollView.contentOffset;
    if (contentPos.y < -50)
    {
//        loadView.tipLabel.text = @"松开可以刷新";
    }
}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
//{
//    loadView.tipLabel.text = @"正在加载";
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (loadView.isLoading)
    {
		return ;
	}
//    CGSize contentSize = scrollView.contentSize;
//    CGRect frame = scrollView.frame;
    CGPoint contentPos = scrollView.contentOffset;
    //	if (contentPos.y > contentSize.height - frame.size.height)
    if (contentPos.y < -30)
    {
        [loadView startLoading];
        //刷新请求更多数据
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryDb) object:nil];
        [thread start];
//        [self performSelector:@selector(queryDb) withObject:nil afterDelay:2];
    }
}

@end
