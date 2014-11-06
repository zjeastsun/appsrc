//
//  ReviewRectifyViewController.m
//  BreakRule
//
//  Created by mac on 14-11-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ReviewRectifyViewController.h"
#import "CustomViewCell.h"
#import "SingletonBridge.h"

@interface ReviewRectifyViewController ()

@end

@implementation ReviewRectifyViewController

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
    bridge.nsWhoUseConditionViewController = @"ReviewRectifyViewController";
    
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
    string sqlcode="get_break_last_view_reform";
    SelectHelpParam helpParam;
    
    if ([bridge.nsRuleTypeForReviewRectify isEqualToString:@"全部"])
    {
        sqlcode = "get_break_last_view_all_reform";
    }
    else
    {
        string sRuleType = [SingletonBridge getBreakRuleTypeByName:bridge.nsRuleTypeForReviewRectify];
        helpParam.add(sRuleType);
    }
    
    if (bridge.nsReviewRectifyStartTime == nil || bridge.nsReviewRectifyEndTime == nil)
    {
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *  endDate=[NSDate date];
        bridge.nsReviewRectifyEndTime=[dateformatter stringFromDate:endDate];
        
        NSDate* startDate = [[NSDate alloc] init];
        startDate = [endDate dateByAddingTimeInterval:-60*3600*24];
        bridge.nsReviewRectifyStartTime =[dateformatter stringFromDate:startDate];
    }
    
    string sStartTime, sEndTime;
    sStartTime = [bridge.nsReviewRectifyStartTime UTF8String];
    sEndTime = [bridge.nsReviewRectifyEndTime UTF8String];
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
    if (![nsReviewRectifyStartTimeOld isEqualToString:bridge.nsReviewRectifyStartTime] || ![nsReviewRectifyEndTimeOld isEqualToString:bridge.nsReviewRectifyEndTime] || ![nsRuleTypeOld isEqualToString:bridge.nsRuleTypeForReviewRectify]) {
        
        [actView setHidden:NO];
        [actView startAnimating];
        
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryDb) object:nil];
        [thread start];
    }
    else
    {
        return;
    }
    
    nsReviewRectifyStartTimeOld = bridge.nsReviewRectifyStartTime;
    nsReviewRectifyEndTimeOld = bridge.nsReviewRectifyEndTime;
    nsRuleTypeOld = bridge.nsRuleTypeForReviewRectify;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRIDGE
    
    int iRow = static_cast<int>(indexPath.row);
    bridge.nsReviewRectify_BreakRuleIdSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_id"];
    bridge.nsReviewRectify_OrgNameSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"org_name"];
    bridge.nsReviewRectify_BreakRuleTypeSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_type"];
    bridge.nsReviewRectify_TimeSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"update_time"];
    bridge.nsReviewRectify_BreakRuleContentSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_content"];
    bridge.nsReviewRectify_CurFlowNodeIdSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"node_id"];
    bridge.nsReviewRectify_PicNameSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"pic_name"];
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewRectifySingleView"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    loadView.tipLabel.text = @"下拉可以刷新";
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (loadView.isLoading)
    {
		return ;
	}
    
    CGPoint contentPos = scrollView.contentOffset;
    if (contentPos.y < -30)
    {
        [loadView startLoading];
        //刷新请求更多数据
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryDb) object:nil];
        [thread start];
    }
}

@end
