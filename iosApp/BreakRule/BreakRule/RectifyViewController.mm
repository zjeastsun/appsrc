//
//  RectifyViewController.m
//  BreakRule
//
//  Created by mac on 14-9-24.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RectifyViewController.h"
#import "CustomViewCell.h"
#import "SingletonBridge.h"

@interface RectifyViewController ()

@end

@implementation RectifyViewController

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
    rectifyTableView.tableHeaderView = loadView;
    loadView.tipLabel.text = [[NSString alloc] initWithString:MORE_STRING];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    bridge.nsWhoUseConditionViewController = @"RectifyViewController";
    
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
    [rectifyTableView reloadData];
}

- (void)queryDb
{
    BRIDGE
    ONEICE
    
    string strError;
    string strParam="";
    string sqlcode="get_break_main_reform_notfull";
    SelectHelpParam helpParam;
    
    if ([bridge.nsRuleTypeForRectify isEqualToString:@"全部"])
    {
        sqlcode = "get_break_main_reform";
    }
    else
    {
        NSString *nsBreakRuleType;
        if ([bridge.nsRuleTypeForRectify isEqualToString:@"一般违规"]) {
            nsBreakRuleType = @"0";
        }
        else if ([bridge.nsRuleTypeForRectify isEqualToString:@"严重违规"])
        {
            nsBreakRuleType = @"1";
        }
        else if ([bridge.nsRuleTypeForRectify isEqualToString:@"重大违规"])
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
    
    if (bridge.nsRectifyStartTime == nil || bridge.nsRectifyEndTime == nil)
    {
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *  endDate=[NSDate date];
        bridge.nsRectifyEndTime=[dateformatter stringFromDate:endDate];
        
        NSDate* startDate = [[NSDate alloc] init];
        startDate = [endDate dateByAddingTimeInterval:-60*3600*24];
        bridge.nsRectifyStartTime =[dateformatter stringFromDate:startDate];
    }
    
    string sStartTime, sEndTime;
    sStartTime = [bridge.nsRectifyStartTime UTF8String];
    sEndTime = [bridge.nsRectifyEndTime UTF8String];
    sEndTime += " 23:59:59";
    
    helpParam.add(sStartTime);
    helpParam.add(sEndTime);
    strParam = helpParam.get();
    
    int iResult = oneIce.g_db->selectCmd("", sqlcode, strParam, helpInfo, strError);
    
    [actView stopAnimating];
    [actView setHidden:YES];
    [loadView stopLoading];
    
    if( iResult<0 )
    {
        [SingletonBridge MessageBox:strError withTitle:"数据库错误"];
        return;
    }
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    BRIDGE
    if (![nsRectifyStartTimeOld isEqualToString:bridge.nsRectifyStartTime] || ![nsRectifyEndTimeOld isEqualToString:bridge.nsRectifyEndTime] || ![nsRuleTypeOld isEqualToString:bridge.nsRuleTypeForRectify]) {
        
        [actView setHidden:NO];
        [actView startAnimating];
        
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryDb) object:nil];
        [thread start];
    }
    else
    {
        return;
    }
    
    nsRectifyStartTimeOld = bridge.nsRectifyStartTime;
    nsRectifyEndTimeOld = bridge.nsRectifyEndTime;
    nsRuleTypeOld = bridge.nsRuleTypeForRectify;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRIDGE
    
    int iRow = static_cast<int>(indexPath.row);
    bridge.nsRectify_BreakRuleIdSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_id"];
//    bridge.nsRectify_OrgNameSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"org_name"];
//    bridge.nsRectify_BreakRuleTypeSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_type"];
//    bridge.nsRectify_TimeSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"update_time"];
    bridge.nsRectify_BreakRuleContentSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_content"];
    bridge.nsRectify_PicNameSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"pic_name"];
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RectifyTakePhotoView"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
    
}

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
    if (contentPos.y < -5)
    {
        [loadView startLoading];
        //刷新请求更多数据
        [self performSelector:@selector(queryDb) withObject:nil afterDelay:2];
    }
}

@end
