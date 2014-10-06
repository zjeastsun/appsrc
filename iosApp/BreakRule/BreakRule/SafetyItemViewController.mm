//
//  SafetyItemViewController.m
//  BreakRule
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "SafetyItemViewController.h"
#import "SingletonBridge.h"
#import "RuleOptionViewController.h"

@interface SafetyItemViewController ()

@end

@implementation SafetyItemViewController

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
    title = [[NSMutableArray alloc]initWithObjects:@"安全分项", @"项目类别", @"检查项目",nil];
    subTitle = [[NSMutableArray alloc]initWithObjects:@"安全文明生产", @"一般项目", @"安全生产责任制", nil];
    [self querySafetyItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)querySafetyItem
{
    LOCALDB
    string error, sql;
    if (localDB.g_localDB->isLogin())
    {
        util::string_format(sql, "select * from BR_CHECK_ITEM_DETAIL");
        localDB.g_localDB->select(sql, m_itemHelp, error);
    }
    
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
        sContent += m_itemHelp.valueString(m_vSelectedLine[i], "content");
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
        return 3;
    }
    else
    {
        return m_itemHelp._count;
    }
    return 0;
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
    
    if (tableView.tag == 0) {
        UIImage *ima = [UIImage imageNamed:@"share_this_icon.png"];
        cell.imageView.image =ima;
        cell.textLabel.text = [title objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        BRIDGE
        if (indexPath.row == 0) {//安全分项
            if (bridge.nsSafetySubItemName == nil || [bridge.nsSafetySubItemName length] == 0)
            {
                cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
            }
            else
            {
                cell.detailTextLabel.text = bridge.nsSafetySubItemName;
            }
        }
        else if (indexPath.row == 1)//项目类别
        {
            if (bridge.nsProjectType == nil || [bridge.nsProjectType length] == 0)
            {
                cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
            }
            else
            {
                cell.detailTextLabel.text = bridge.nsProjectType;
            }
        }
        else if (indexPath.row == 2)//检查项目
        {
            if (bridge.nsCheckItem == nil || [bridge.nsCheckItem length] == 0)
            {
                cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
            }
            else
            {
                cell.detailTextLabel.text = bridge.nsCheckItem;
            }
        }
        
    }
    else
    {
        UIImage *ima = [UIImage imageNamed:@"share_this_icon.png"];
        cell.imageView.image =ima;
        string sContent = m_itemHelp.valueString(static_cast<int>(indexPath.row), "content");
        NSString *content = [NSString stringWithCString:(char*)sContent.c_str() encoding:NSUTF8StringEncoding];
        cell.textLabel.text = content;
//        cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
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
        if (indexPath.row == 0) {
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SafetySubItemView"];
        }
        else if (tableView.tag == 0)
        {
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectTypeView"];
        }
        else
        {
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckItemView"];
        }
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
    //重新载入所有数据
    [itemTableView reloadData];
    
}

@end
