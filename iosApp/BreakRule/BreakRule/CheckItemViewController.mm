//
//  CheckItemViewController.m
//  BreakRule
//
//  Created by mac on 14-10-4.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "CheckItemViewController.h"
#import "SingletonBridge.h"

@interface CheckItemViewController ()

@end

@implementation CheckItemViewController

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
    [self queryCheckItem];
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
    return m_checkItemHelp.size();
    
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
    string sCheckItemName = m_checkItemHelp.valueString(static_cast<int>(indexPath.row), "check_item_name");
    NSString *nsCheckItemName = [NSString stringWithCString:(char*)sCheckItemName.c_str() encoding:NSUTF8StringEncoding];
    cell.textLabel.text = nsCheckItemName;
    
    BRIDGE
    if ([cell.textLabel.text isEqualToString:bridge.nsCheckItemName]) {
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
    string sCheckItemId = m_checkItemHelp.valueString(static_cast<int>(indexPath.row), "check_item_id");
    NSString *nsCheckItemId = [NSString stringWithCString:(char*)sCheckItemId.c_str() encoding:NSUTF8StringEncoding];
    string sCheckItemName = m_checkItemHelp.valueString(static_cast<int>(indexPath.row), "check_item_name");
    NSString *nsCheckItemName = [NSString stringWithCString:(char*)sCheckItemName.c_str() encoding:NSUTF8StringEncoding];
    
    bridge.nsCheckItemId = nsCheckItemId;
    bridge.nsCheckItemName = nsCheckItemName;
    [self back:nil];
    
}

- (void)queryCheckItem
{
    BRIDGE
    LOCALDB
    string error, sql;
    
    string sSafetyItemId = [bridge.nsSafetySubItemId UTF8String];
    string sCheckItemType = [bridge.nsProjectType UTF8String];
    
    if (localDB.g_localDB->isLogin())
    {
        util::string_format(sql, "select * from BR_CHECK_ITEM where safety_item_id='%s' ", sSafetyItemId.c_str());
        if (sCheckItemType != "0") {
            string sTemp;
            util::string_format(sTemp, " and check_item_type='%s' ", sCheckItemType.c_str());
            sql += sTemp;
        }
        
        localDB.g_localDB->select(sql, m_checkItemHelp, error);

    }
    
}

@end
