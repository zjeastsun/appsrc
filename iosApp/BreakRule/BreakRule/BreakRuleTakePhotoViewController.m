//
//  BreakRuleTakePhotoViewController.m
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "BreakRuleTakePhotoViewController.h"

@interface BreakRuleTakePhotoViewController ()

@end

@implementation BreakRuleTakePhotoViewController

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
    title = [[NSMutableArray alloc]initWithObjects:@"判定性质", @"违规选项",nil];
    subTitle = [[NSMutableArray alloc]initWithObjects:@"一般违规", @"自定义",nil];
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
    return 2;
}
////表段头
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
//    label.text =@"表段头";
//    label.textColor = [UIColor redColor];
//    label.backgroundColor = [UIColor greenColor];
//    return label;
//}
//页眉
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"开始";
//}
////页脚
//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return @"结束";
//}
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
    cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
    
}

- (IBAction)back:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
@end
