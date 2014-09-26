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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    tableView.contentInset = UIEdgeInsetsMake( 0, 0, 0, 0);//有导航条的时候调整表头位置
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
//    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,5,20)] ;
    
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

- (IBAction)fromPhotosAlbum:(id)sender {
    imagePicker = [[UIImagePickerController alloc]init];
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//图片库
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//相册
    imagePicker.delegate = (id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)fromCamera:(id)sender {
    imagePicker = [[UIImagePickerController alloc] init];
    //检测照相设备是否可用
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = (id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self;
//        imagePicker.allowsEditing =YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)fromVideo:(id)sender {
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//裁剪的照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始照片
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    imageView.image = image;
    
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    if(error)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                           message:@"不能保存照片到相册"
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }
    else
    {
//        alert = [[UIAlertView alloc] initWithTitle:@"成功"
//                                           message:@"保存照片到相册成功"
//                                          delegate:self
//                                 cancelButtonTitle:@"OK"
//                                 otherButtonTitles:nil];
    }
    [alert show];
    
}

@end
