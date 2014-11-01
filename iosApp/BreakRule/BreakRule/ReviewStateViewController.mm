//
//  ReviewStateViewController.m
//  BreakRule
//
//  Created by mac on 14-10-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ReviewStateViewController.h"
#import "SingletonBridge.h"

@interface ReviewStateViewController ()

@end

@implementation ReviewStateViewController

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
    bridge.nsReviewState = @"审核通过";
    if( [bridge.nsWhoUseReviewStateViewController isEqualToString:@"ReviewBreakRuleSingleViewController"] )
    {
        //违规批阅
        title = [[NSMutableArray alloc]initWithObjects:@"审核通过", @"无需整改", @"无法判定", nil];
    }
    else if( [bridge.nsWhoUseReviewStateViewController isEqualToString:@"ReviewBreakRuleSingleViewControllerForHighest"])
    {
        //违规批阅－最高级
        title = [[NSMutableArray alloc]initWithObjects:@"审核通过", @"无需整改", nil];
    }
    else if([bridge.nsWhoUseReviewStateViewController isEqualToString:@"ReviewRectifySingleViewController"])
    {
        //整改批阅
        title = [[NSMutableArray alloc]initWithObjects:@"审核通过", @"审核不通过", @"无法判定", nil];
    }
    else if( [bridge.nsWhoUseReviewStateViewController isEqualToString:@"ReviewRectifySingleViewControllerForHighest"])
    {
        //整改批阅-最高级
        title = [[NSMutableArray alloc]initWithObjects:@"审核通过", @"审核不通过", nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    BRIDGE
    if ([cell.textLabel.text isEqualToString:bridge.nsReviewState]) {
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
    bridge.nsReviewState = [title objectAtIndex:indexPath.row];
    [self back:nil];
    
    
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


@end
