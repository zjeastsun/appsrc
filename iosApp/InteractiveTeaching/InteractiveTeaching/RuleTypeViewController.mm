//
//  RuleTypeViewController.m
//  BreakRule
//
//  Created by mac on 14-9-28.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RuleTypeViewController.h"
#import "SingletonBridge.h"

@interface RuleTypeViewController ()

@end

@implementation RuleTypeViewController

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
    BRIDGE
    if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"ReviewBreakRuleViewController"] )
    {
        title = [[NSMutableArray alloc]initWithObjects:@"一般违规", @"严重违规", @"重大违规", @"全部", nil];
    }
    else if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"RectifyViewController"] )
    {
        title = [[NSMutableArray alloc]initWithObjects:@"一般违规", @"严重违规", @"重大违规", @"全部", nil];
    }
    else if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"ReviewRectifyViewController"] )
    {
        title = [[NSMutableArray alloc]initWithObjects:@"一般违规", @"严重违规", @"重大违规", @"全部", nil];
    }
    else if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"QueryViewController"] )
    {
        title = [[NSMutableArray alloc]initWithObjects:@"一般违规", @"严重违规", @"重大违规", @"全部", nil];
    }
    else
    {
        title = [[NSMutableArray alloc]initWithObjects:@"一般违规", @"严重违规", @"重大违规", nil];
    }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return title.count;
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
    
    NSString *nsRuleType;
    BRIDGE
    if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"ReviewBreakRuleViewController"] )
    {
        nsRuleType = bridge.nsRuleTypeForReviewBR;
    }
    else if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"RectifyViewController"] )
    {
        nsRuleType = bridge.nsRuleTypeForRectify;
    }
    else if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"ReviewRectifyViewController"] )
    {
        nsRuleType = bridge.nsRuleTypeForReviewRectify;
    }
    else if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"QueryViewController"] )
    {
        nsRuleType = bridge.nsRuleTypeForQuery;
    }
    else
    {
        nsRuleType = bridge.nsRuleType;
    }
    
    if ([cell.textLabel.text isEqualToString:nsRuleType]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellView = [tableView cellForRowAtIndexPath:indexPath];
    if(cellView.accessoryType == UITableViewCellAccessoryNone)
    {
        cellView.accessoryType =UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cellView.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    BRIDGE
    if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"ReviewBreakRuleViewController"] )
    {
        bridge.nsRuleTypeForReviewBR = [title objectAtIndex:indexPath.row];
    }
    else if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"RectifyViewController"] )
    {
        bridge.nsRuleTypeForRectify = [title objectAtIndex:indexPath.row];
    }
    else if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"ReviewRectifyViewController"] )
    {
        bridge.nsRuleTypeForReviewRectify = [title objectAtIndex:indexPath.row];
    }
    else if( [bridge.nsWhoUseRuleTypeViewController isEqualToString:@"QueryViewController"] )
    {
        bridge.nsRuleTypeForQuery = [title objectAtIndex:indexPath.row];
    }
    else
    {
        bridge.nsRuleType = [title objectAtIndex:indexPath.row];
    }
    
    [self back:nil];
    

}

@end
