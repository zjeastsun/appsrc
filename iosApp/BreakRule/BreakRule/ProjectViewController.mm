//
//  ProjectViewController.m
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ProjectViewController.h"
#import "SingletonBridge.h"

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

- (void)queryProject:(NSString *)orgId
{
    ONEICE
    
    string strError;
    string strParam="";
    const string sqlcode="get_project";
    
    string sOrgId = [orgId UTF8String];
    SelectHelpParam helpParam;
    helpParam.add(sOrgId);
    helpParam.add(sOrgId);
    strParam = helpParam.get();

    oneIce.g_db->selectCmd("", sqlcode, strParam, helpProject, strError);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BRIDGE
    [self queryProject:bridge.nsOrgId];
    
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
    return helpProject.size();
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
//    NSInteger row = [indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UIImage *ima = [UIImage imageNamed:@"share_this_icon.png"];
    cell.imageView.image =ima;
    
    string sProject = helpProject.valueString( indexPath.row, "org_name" );
    char *temp =const_cast<char*>(sProject.c_str());
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    cell.textLabel.text = [NSString stringWithCString:temp encoding:enc];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if(row == 0)
    {
    }
    BRIDGE
    string sContent = helpProject.valueString(static_cast<int>(indexPath.row), "org_id");
    bridge.nsOrgIdSelected = [NSString stringWithCString:(char*)sContent.c_str() encoding:NSUTF8StringEncoding];
    sContent = helpProject.valueString(static_cast<int>(indexPath.row), "org_name");
    bridge.nsOrgNameSelected = [NSString stringWithCString:(char*)sContent.c_str() encoding:NSUTF8StringEncoding];
    
    UIViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];

    [self presentViewController:mainViewController animated:YES completion:nil];
    
}
@end
