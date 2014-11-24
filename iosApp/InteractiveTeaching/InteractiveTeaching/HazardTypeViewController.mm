//
//  HazardTypeViewController.m
//  BreakRule
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HazardTypeViewController.h"
#import "SingletonBridge.h"

@interface HazardTypeViewController ()

@end

@implementation HazardTypeViewController

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
    [self queryHazardType];
    // Do any additional setup after loading the view.
}

- (void)queryHazardType
{
    LOCALDB
    string error, sql;
    
    if (localDB.g_localDB->isLogin())
    {
        util::string_format(sql, "select * from BR_HAZARD_TYPE");
        localDB.g_localDB->select(sql, m_hazardTypeHelp, error);
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_hazardTypeHelp._count;
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
    string sContent = m_hazardTypeHelp.valueString(static_cast<int>(indexPath.row), "hazard_type_name");
    NSString *content = [NSString stringWithCString:(char*)sContent.c_str() encoding:NSUTF8StringEncoding];
    cell.textLabel.text = content;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    BRIDGE
    if (bridge.nsHazardTypeName == nil || [bridge.nsHazardTypeName length] == 0)
    {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        if ([cell.textLabel.text isEqualToString:bridge.nsHazardTypeName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRIDGE
    string sContent = m_hazardTypeHelp.valueString(static_cast<int>(indexPath.row), "hazard_type_id");
    bridge.nsHazardTypeId = [NSString stringWithCString:(char*)sContent.c_str() encoding:NSUTF8StringEncoding];
    sContent = m_hazardTypeHelp.valueString(static_cast<int>(indexPath.row), "hazard_type_name");
    bridge.nsHazardTypeName = [NSString stringWithCString:(char*)sContent.c_str() encoding:NSUTF8StringEncoding];
    [self back:nil];
    
    
}

- (IBAction)back:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
@end
