//
//  HazardItemViewController.m
//  BreakRule
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "HazardItemViewController.h"
#import "SingletonBridge.h"

@interface HazardItemViewController ()

@end

@implementation HazardItemViewController

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
    
    BRIDGE
    if (bridge.nsHazardTypeId == nil || [bridge.nsHazardTypeId length] == 0)
    {
        [self queryHazardType];
    }
    [self queryHazard];
    // Do any additional setup after loading the view.
}

- (void)queryHazardType
{
    BRIDGE
    LOCALDB
    string error, sql;
    CSelectHelp hazardTypeHelp;
    
    if (localDB.g_localDB->isLogin())
    {
        util::string_format(sql, "select * from BR_HAZARD_TYPE limit 0,1");
        localDB.g_localDB->select(sql, hazardTypeHelp, error);
        if (hazardTypeHelp.size()>0) {
            string sHazardTypeId = hazardTypeHelp.valueString(0, "hazard_type_id");
            bridge.nsHazardTypeId = [NSString stringWithCString:(char*)sHazardTypeId.c_str() encoding:NSUTF8StringEncoding];
            
            string sHazardTypeName = hazardTypeHelp.valueString(0, "hazard_type_name");
            bridge.nsHazardTypeName = [NSString stringWithCString:(char*)sHazardTypeName.c_str() encoding:NSUTF8StringEncoding];
        }
    }
    
}

- (void)queryHazard
{
    BRIDGE
    LOCALDB
    string error, sql;
    string sHazardTypeId = [bridge.nsHazardTypeId UTF8String];
    
    if (localDB.g_localDB->isLogin())
    {
        util::string_format(sql, "select * from BR_HAZARD where hazard_type_id='%s' ", sHazardTypeId.c_str());
        localDB.g_localDB->select(sql, m_hazardHelp, error);

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

- (IBAction)save:(id)sender {
    BRIDGE
    string sContent;
    for (int i=0; i<m_vSelectedLine.size(); ++i) {
        sContent += m_hazardHelp.valueString(m_vSelectedLine[i], "hazard_content");
    }
    bridge.nsContent = [NSString stringWithCString:(char*)sContent.c_str() encoding:NSUTF8StringEncoding];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return 1;
    }
    return m_hazardHelp.size();
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

    BRIDGE
    if (tableView.tag == 0) {
        UIImage *ima = [UIImage imageNamed:@"share_this_icon.png"];
        cell.imageView.image =ima;
        cell.textLabel.text = @"类别";
        cell.detailTextLabel.text = bridge.nsHazardTypeName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else
    {
        UIImage *ima = [UIImage imageNamed:@"share_this_icon.png"];
        cell.imageView.image =ima;
        string sContent = m_hazardHelp.valueString(static_cast<int>(indexPath.row), "hazard_content");
        NSString *content = [NSString stringWithCString:(char*)sContent.c_str() encoding:NSUTF8StringEncoding];
        cell.textLabel.text = content;
        if ([self isCheckmark:indexPath.row])
        {
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
    UITableViewCell *cellView = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView.tag == 0)
    {
        UIViewController *viewController;
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HazardTypeView"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else
    {
        if(cellView.accessoryType == UITableViewCellAccessoryNone)
        {
            cellView.accessoryType = UITableViewCellAccessoryCheckmark;
            m_vSelectedLine.push_back(static_cast<int>(indexPath.row));
        }
        else
        {
            cellView.accessoryType = UITableViewCellAccessoryNone;
            m_vSelectedLine.erase(remove(m_vSelectedLine.begin(), m_vSelectedLine.end(), static_cast<int>(indexPath.row)), m_vSelectedLine.end());
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
}

- (BOOL)isCheckmark:(NSInteger )row
{
    vector<int>::iterator iter;
    iter=find( m_vSelectedLine.begin(), m_vSelectedLine.end(), row );
    if (iter != m_vSelectedLine.end()) {
        return true;
    }
    return false;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self queryHazard];
    //重新载入所有数据
    [hazardTypeTableView reloadData];
    [hazardItemTableView reloadData];
    
}

@end
