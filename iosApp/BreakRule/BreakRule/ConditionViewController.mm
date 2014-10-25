//
//  ConditionViewController.m
//  BreakRule
//
//  Created by mac on 14-10-25.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ConditionViewController.h"
#import "SingletonBridge.h"

@interface ConditionViewController ()

@end

@implementation ConditionViewController

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
    [self setHiddenCtrl:YES];
    title = [[NSMutableArray alloc]initWithObjects:@"判定性质", nil];
    subTitle = [[NSMutableArray alloc]initWithObjects:@"全部", nil];
    
    BRIDGE
    startTimeText.text = bridge.nsReviewStartTime;
    endTimeText.text = bridge.nsReviewEndTime;
    nsRuleTypeOld = bridge.nsRuleTypeForCondition;
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
    BRIDGE
    bridge.nsRuleTypeForCondition = nsRuleTypeOld;
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectStartTime:(id)sender {
    bStartTime = true;
    timeLabel.text = @"开始时间";
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *startTime = [dateformatter dateFromString:startTimeText.text];
    [datePicker setDate:startTime animated:YES];
    [self setHiddenCtrl:NO];
}

- (IBAction)selectEndTime:(id)sender {
    bStartTime = false;
    timeLabel.text = @"结束时间";
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *startTime = [dateformatter dateFromString:endTimeText.text];
    [datePicker setDate:startTime animated:YES];
    [self setHiddenCtrl:NO];
}

- (IBAction)setTime:(id)sender {
    [self setHiddenCtrl:YES];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];

    NSDate *date = datePicker.date;
    NSString *nsTime = [dateformatter stringFromDate:date];
    
    if (bStartTime) {
        startTimeText.text = nsTime;
    }
    else
    {
        endTimeText.text = nsTime;
    }
}

- (IBAction)cancel:(id)sender {
    [self setHiddenCtrl:YES];
}

- (IBAction)save:(id)sender {
    BRIDGE
    bridge.nsReviewStartTime = startTimeText.text;
    bridge.nsReviewEndTime = endTimeText.text;
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}

- (void)setHiddenCtrl:(BOOL)bShow
{
    [setButton setHidden:bShow];
    [dateBackground setHidden:bShow];
    [cancelButton setHidden:bShow];
    [datePicker setHidden:bShow];
    [timeLabel setHidden:bShow];
    
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
    if (bridge.nsRuleTypeForCondition == nil || [bridge.nsRuleTypeForCondition length] == 0)
    {
        cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
    }
    else
    {
        cell.detailTextLabel.text = bridge.nsRuleTypeForCondition;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RuleTypeView"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
    BRIDGE
    bridge.nsWhoUseRuleTypeViewController = @"ConditionViewController";

//    [self back:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //重新载入所有数据
    [ruleTableView reloadData];
    
}

@end
