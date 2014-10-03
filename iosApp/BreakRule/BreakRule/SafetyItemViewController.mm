//
//  SafetyItemViewController.m
//  BreakRule
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "SafetyItemViewController.h"

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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbFileName = @"break_law_init.db";
    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:dbFileName];
    
    LOCALDB
    string sDataFilePath = [dataFilePath UTF8String];
    if (!localDB.g_localDB->isLogin()) {
        bool bLogin = localDB.g_localDB->login( sDataFilePath );
        if (!bLogin) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:@"本地数据库连接失败"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    string error, sql;
    util::string_format(sql, "select * from BR_CHECK_ITEM_DETAIL");
    localDB.g_localDB->select(sql, m_ItemHelp, error);
    
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
    if (tableView.tag == 0) {
        return 3;
    }
    else
    {
        return m_ItemHelp._count;
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
        
    }
    else
    {
        UIImage *ima = [UIImage imageNamed:@"share_this_icon.png"];
        cell.imageView.image =ima;
        string sContent = m_ItemHelp.valueString(static_cast<int>(indexPath.row), "content");
        NSString *content = [NSString stringWithCString:(char*)sContent.c_str() encoding:NSUTF8StringEncoding];
        cell.textLabel.text = content;
//        cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
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
    
    
}
@end
