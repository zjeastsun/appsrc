//
//  ProjectViewController.m
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ProjectViewController.h"
#import "BreakRuleTakePhotoViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    string strSQL="";
	string strError;
    CSelectHelp	helpUser;
    
    util::string_format(strSQL, "select * from T_USER where login_name='admin' and pwd='12345' ");
    [singletonIce sharedInstance].g_db->select(strSQL, helpUser, strError);
    
    if( helpUser.size() <= 0 )
    {
        NSLog(@"ProjectViewController用户登录失败！");
        return;
    }
    NSLog(@"ProjectViewController用户登录成功！");
    
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
    return 5;
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
    cell.textLabel.text =@"项目1";
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if(row == 0)
    {
    }
    
    BreakRuleTakePhotoViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
    [self presentViewController:mainViewController animated:YES completion:nil];
    
}
@end
