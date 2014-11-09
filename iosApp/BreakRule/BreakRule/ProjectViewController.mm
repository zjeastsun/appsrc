//
//  ProjectViewController.m
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ProjectViewController.h"
#import "SingletonBridge.h"
#import "IosUtils.h"

@interface ProjectViewController ()

@end

@implementation ProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateUI
{
    //重新载入所有数据
    [theLock lock];
    [projectTableView reloadData];
    [theLock unlock];
}

- (void)queryProject
{
    BRIDGE
    ONEICE
    
    if (bridge.nsLoginName == nil || [bridge.nsLoginName length] == 0)
    {
        return;
    }

    string strError;
    [theLock lock];
    int iResult = [oneIce getProject:helpProject user:bridge.nsLoginName error:strError];
    [theLock unlock];
    
    if( iResult<0 )
    {
        [IosUtils MessageBox:strError withTitle:"数据库错误"];
        //        return;
    }
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    theLock = [[NSLock alloc] init];
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryProject) object:nil];
    [thread start];
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int iRows = helpProject.size();
    return iRows;
}

//表段头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    label.text =@"项目选择";
    label.textColor = [UIColor redColor];
//    label.backgroundColor = [UIColor greenColor];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSInteger row = [indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UIImage *ima = [UIImage imageNamed:@"share_this_icon.png"];
    cell.imageView.image =ima;
    
    if (helpProject.size() == 0) {
//        cell.textLabel.text = @"目前没有项目";
    }
    else
    {
        cell.textLabel.text = [SingletonIce valueNSString:helpProject rowForHelp:row KeyForHelp:"org_name"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if(row == 0)
    {
    }
    
    BRIDGE
    bridge.nsOrgIdSelected = [SingletonIce valueNSString:helpProject rowForHelp:row KeyForHelp:"org_id"];
    bridge.nsOrgNameSelected = [SingletonIce valueNSString:helpProject rowForHelp:row KeyForHelp:"org_name"];
    
    UIViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];

    [self presentViewController:mainViewController animated:YES completion:nil];
    
}
@end
