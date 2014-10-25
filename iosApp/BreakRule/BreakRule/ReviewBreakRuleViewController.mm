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

- (IBAction)save:(id)sender {
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

- (void)queryDb
{
    BRIDGE
    ONEICE
    
    string strError;
    string strParam="";
    const string sqlcode="get_break_last_view_all_review";
    
    if (bridge.nsReviewStartTime == nil || bridge.nsReviewEndTime == nil)
    {
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        NSDate *  endDate=[NSDate date];
        bridge.nsReviewEndTime=[dateformatter stringFromDate:endDate];
        
        NSDate* startDate = [[NSDate alloc] init];
        startDate = [endDate dateByAddingTimeInterval:-70*3600*24];
        bridge.nsReviewStartTime =[dateformatter stringFromDate:startDate];
    }
    
    string sStartTime, sEndTime;
    sStartTime = [bridge.nsReviewStartTime UTF8String];
    sEndTime = [bridge.nsReviewEndTime UTF8String];
    
    SelectHelpParam helpParam;
    helpParam.add(sStartTime);
    helpParam.add(sEndTime);
    strParam = helpParam.get();
    
    oneIce.g_db->selectCmd("", sqlcode, strParam, helpInfo, strError);
    [reviewTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    BRIDGE
    if (![nsReviewStartTimeOld isEqualToString:bridge.nsReviewStartTime] || ![nsReviewEndTimeOld isEqualToString:bridge.nsReviewEndTime]) {

        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryDb) object:nil];
        [thread start];
    }
    else
    {
        return;
    }
    
    nsReviewStartTimeOld = bridge.nsReviewStartTime;
    nsReviewEndTimeOld = bridge.nsReviewEndTime;
    
}
@end