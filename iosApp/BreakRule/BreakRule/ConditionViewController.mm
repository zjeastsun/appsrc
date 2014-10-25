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

- (IBAction)selectStartTime:(id)sender {
    bStartTime = true;
    [self setHiddenCtrl:NO];
}

- (IBAction)selectEndTime:(id)sender {
    bStartTime = false;
    [self setHiddenCtrl:NO];
}

- (IBAction)setTime:(id)sender {
    [self setHiddenCtrl:YES];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];

    NSDate *date = datePicker.date;
    NSString *nsTime = [dateformatter stringFromDate:date];
    
    BRIDGE
    if (bStartTime) {
        startTimeText.text = nsTime;
        [dateformatter setDateFormat:@"YYYY-MM-dd 00:00:00"];
        bridge.nsReviewStartTime = [dateformatter stringFromDate:date];
    }
    else
    {
        endTimeText.text = nsTime;
        [dateformatter setDateFormat:@"YYYY-MM-dd 23:59:59"];
        bridge.nsReviewEndTime = [dateformatter stringFromDate:date];
    }
}

- (IBAction)cancel:(id)sender {
    [self setHiddenCtrl:YES];
}

- (void)setHiddenCtrl:(BOOL)bShow
{
    [setButton setHidden:bShow];
    [dateBackground setHidden:bShow];
    [cancelButton setHidden:bShow];
    [datePicker setHidden:bShow];
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
    
    if ([cell.detailTextLabel.text isEqualToString:@"一般违规"]) {
//        nsBreakRuleType = @"0";
    }
    else if ([cell.detailTextLabel.text isEqualToString:@"严重违规"])
    {
//        nsBreakRuleType = @"1";
    }
    else if ([cell.detailTextLabel.text isEqualToString:@"重大违规"])
    {
//        nsBreakRuleType = @"2";
    }
    else
    {
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

    [self back:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //重新载入所有数据
    [ruleTableView reloadData];
    
}

@end
