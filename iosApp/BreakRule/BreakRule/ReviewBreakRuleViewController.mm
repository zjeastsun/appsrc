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

- (IBAction)back:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)condition:(id)sender {
    UIViewController *projectView = [self.storyboard instantiateViewControllerWithIdentifier:@"conditionView"];
    [self presentViewController:projectView animated:YES completion:nil];
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
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    string sOrgName = helpInfo.valueString( indexPath.row, "org_name" );
    string sContent = helpInfo.valueString( indexPath.row, "break_rule_content" );
    string sTime = helpInfo.valueString( indexPath.row, "update_time" );

    //定制单元格
    cell.titleLabel.text = [NSString stringWithCString:const_cast<char*>(sOrgName.c_str()) encoding:enc];
    cell.descLabel.text = [NSString stringWithCString:const_cast<char*>(sContent.c_str()) encoding:enc];
    cell.timeLabel.text = [NSString stringWithCString:const_cast<char*>(sTime.c_str()) encoding:enc];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)queryDb//sql语句不对，没有根据项目过滤，还要调整，时间也没有？
{
    BRIDGE
    ONEICE
    
    string strError;
    string strParam="";
    string sqlcode="get_break_last_view_review";
    SelectHelpParam helpParam;
    
    if ([bridge.nsRuleTypeForCondition isEqualToString:@"全部"])
    {
        sqlcode = "get_break_last_view_all_review";
    }
    else
    {
        NSString *nsBreakRuleType;
        if ([bridge.nsRuleTypeForCondition isEqualToString:@"一般违规"]) {
            nsBreakRuleType = @"0";
        }
        else if ([bridge.nsRuleTypeForCondition isEqualToString:@"严重违规"])
        {
            nsBreakRuleType = @"1";
        }
        else if ([bridge.nsRuleTypeForCondition isEqualToString:@"重大违规"])
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
    
    helpParam.add(sStartTime);
    helpParam.add(sEndTime);
    strParam = helpParam.get();
    
    oneIce.g_db->selectCmd("", sqlcode, strParam, helpInfo, strError);
    [reviewTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    BRIDGE
    if (![nsReviewStartTimeOld isEqualToString:bridge.nsReviewStartTime] || ![nsReviewEndTimeOld isEqualToString:bridge.nsReviewEndTime] || ![nsRuleTypeOld isEqualToString:bridge.nsRuleTypeForCondition]) {

        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryDb) object:nil];
        [thread start];
    }
    else
    {
        return;
    }
    
    nsReviewStartTimeOld = bridge.nsReviewStartTime;
    nsReviewEndTimeOld = bridge.nsReviewEndTime;
    nsRuleTypeOld = bridge.nsRuleTypeForCondition;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    BRIDGE
    string sBreakRuleId = helpInfo.valueString(static_cast<int>(indexPath.row), "break_rule_id");
    string sOrgName = helpInfo.valueString(static_cast<int>(indexPath.row), "org_name");
    string sBreakRuleType = helpInfo.valueString(static_cast<int>(indexPath.row), "break_rule_type");
    string sTime = helpInfo.valueString(static_cast<int>(indexPath.row), "update_time");
    string sBreakRuleContent = helpInfo.valueString(static_cast<int>(indexPath.row), "break_rule_content");
    
    bridge.nsReviewBR_BreakRuleIdSelected = [NSString stringWithCString:const_cast<char*>(sBreakRuleId.c_str()) encoding:enc];
    bridge.nsReviewBR_OrgNameSelected = [NSString stringWithCString:const_cast<char*>(sOrgName.c_str()) encoding:enc];
    bridge.nsReviewBR_BreakRuleTypeSelected = [NSString stringWithCString:const_cast<char*>(sBreakRuleType.c_str()) encoding:enc];
    bridge.nsReviewBR_TimeSelected = [NSString stringWithCString:const_cast<char*>(sTime.c_str()) encoding:enc];
    bridge.nsReviewBR_BreakRuleContentSelected = [NSString stringWithCString:const_cast<char*>(sBreakRuleContent.c_str()) encoding:enc];

    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewBreakRuleSingleView"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
    
}

@end
