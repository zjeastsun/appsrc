//
//  RectifyViewController.m
//  BreakRule
//
//  Created by mac on 14-9-24.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RectifyViewController.h"
#import "CustomViewCell.h"
#import "SingletonBridge.h"
#import "IosUtils.h"

@interface RectifyViewController ()

@end

@implementation RectifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addTableHeaderView
{
    NSArray* viewArray = [[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil];
    loadView = [viewArray objectAtIndex:0];
    rectifyTableView.tableHeaderView = loadView;
//    loadView.tipLabel.text = [[NSString alloc] initWithString:MORE_STRING];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    theLock = [[NSLock alloc] init];
    [self addTableHeaderView];
    bQuerying = false;
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

- (IBAction)back:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)condition:(id)sender {
    BRIDGE
    bridge.nsWhoUseConditionViewController = @"RectifyViewController";
    
    UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"conditionView"];
    [self presentViewController:view animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return helpInfo.size();
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.contentInset = UIEdgeInsetsMake( 0, 0, 0, 0);//有导航条的时候调整表头位置
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSInteger row = [indexPath row];
    
    CustomViewCell *cell = (CustomViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"CustomViewCell" owner:nil options:nil];
        cell =  [array objectAtIndex:0];
    }
    if (helpInfo.size() == 0)
    {
        return cell;
    }
    
    //定制单元格
    cell.titleLabel.text = [SingletonIce valueNSString:helpInfo rowForHelp:row KeyForHelp:"org_name"];
    cell.descLabel.text = [SingletonIce valueNSString:helpInfo rowForHelp:row KeyForHelp:"break_rule_content"];
    
    NSString *nsTime = [SingletonIce valueNSString:helpInfo rowForHelp:row KeyForHelp:"pic_time"];
    NSString *nsSubTime = [nsTime substringWithRange:NSMakeRange(2, 14)];
    cell.timeLabel.text = nsSubTime;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)updateUI
{
    [actView stopAnimating];
    [actView setHidden:YES];
    [loadView stopLoading];
    
    [theLock lock];
    if (rectifyTableView) {
        [rectifyTableView reloadData];
    }
    [theLock unlock];

    if (helpInfo.size()==0) {
        loadView.tipLabel.text = @"没有待整改抓拍的违规信息";
    }
}

- (void)queryDb
{
    ONEICE
    
    string strError;
    [theLock lock];
    int iResult = [oneIce getPreRectify:helpInfo error:strError];
    [theLock unlock];
    
    bQuerying = false;
    
    if( iResult<0 )
    {
//        [IosUtils MessageBox:strError withTitle:"数据库错误"];
//        return;
    }
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    BRIDGE
    if (![nsRectifyStartTimeOld isEqualToString:bridge.nsRectifyStartTime] || ![nsRectifyEndTimeOld isEqualToString:bridge.nsRectifyEndTime] || ![nsRuleTypeOld isEqualToString:bridge.nsRuleTypeForRectify]) {
        
        if (!bQuerying) {
            bQuerying = true;
            [actView setHidden:NO];
            [actView startAnimating];
            
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryDb) object:nil];
            [thread start];
        }
    }
    else
    {
        return;
    }
    
    nsRectifyStartTimeOld = bridge.nsRectifyStartTime;
    nsRectifyEndTimeOld = bridge.nsRectifyEndTime;
    nsRuleTypeOld = bridge.nsRuleTypeForRectify;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRIDGE
    
    int iRow = static_cast<int>(indexPath.row);
    bridge.nsRectify_BreakRuleIdSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_id"];
//    bridge.nsRectify_OrgNameSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"org_name"];
//    bridge.nsRectify_BreakRuleTypeSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_type"];
//    bridge.nsRectify_TimeSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"update_time"];
    bridge.nsRectify_BreakRuleContentSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"break_rule_content"];
    bridge.nsRectify_PicNameSelected = [SingletonIce valueNSString:helpInfo rowForHelp:iRow KeyForHelp:"pic_name"];
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RectifyTakePhotoView"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    loadView.tipLabel.text = @"下拉可以刷新";
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (loadView.isLoading)
    {
		return ;
	}
    
    CGPoint contentPos = scrollView.contentOffset;
    
    if (contentPos.y < -30)
    {
        if (!bQuerying) {
            bQuerying = true;
            [loadView startLoading];
            //刷新
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(queryDb) object:nil];
            [thread start];
        }
    }
}

@end
