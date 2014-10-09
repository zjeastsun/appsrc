//
//  BreakRuleTakePhotoViewController.m
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "BreakRuleTakePhotoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SJAvatarBrowser.h"
#import "SingletonBridge.h"

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
    
    imageView.userInteractionEnabled = YES;
    //点击放大图片
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
    
    [imageView addGestureRecognizer:tap];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //重新载入所有数据
    [ruleTableView reloadData];
    
//    //只更新其中一行
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    UITableViewCell *cell = [ruleTableView cellForRowAtIndexPath:indexPath];
//    BRIDGE
//    cell.detailTextLabel.text = bridge.sRuleType;
//    [ruleTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                          withRowAnimation:UITableViewRowAnimationFade];
    BRIDGE
    contentTextView.text = bridge.nsContent;
}

- (void)magnifyImage
{
    NSLog(@"局部放大");
    [SJAvatarBrowser showImage:imageView];//调用方法
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
    
    BRIDGE
    if (indexPath.row == 0) {
        if (bridge.nsRuleType == nil || [bridge.nsRuleType length] == 0)
        {
            cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
        }
        else
        {
            cell.detailTextLabel.text = bridge.nsRuleType;
        }
    }
    else
    {
        if (bridge.nsRuleOption == nil || [bridge.nsRuleOption length] == 0)
        {
            cell.detailTextLabel.text = [subTitle objectAtIndex:indexPath.row];
        }
        else
        {
            cell.detailTextLabel.text = bridge.nsRuleOption;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
    
}

//选择、响应
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [indexPath row] == 0 )
    {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RuleTypeView"];
        
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else
    {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RuleOptionView"];
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
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
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = (id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self;
//        imagePicker.allowsEditing =YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)fromVideo:(id)sender {
    imagePicker = [[UIImagePickerController alloc] init];
    //检测照相设备是否可用
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //kUTTypeMovie带声音的视频，kUTTypeVideo不带声音的视频，kUTTypeImage图片
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;//视频质量
//        imagePicker.showsCameraControls = NO;
//        imagePicker.toolbarHidden = YES;
//        imagePicker.navigationBarHidden = YES;
        imagePicker.delegate = (id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if( picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum || picker.cameraCaptureMode == UIImagePickerControllerCameraCaptureModePhoto )
    {
        //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//裁剪的照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始照片
        
        __block NSDictionary *metaData;
        NSDictionary *exifData;
        __block NSString *nsPhotoData;
        
        //如果是从摄像头拍照来的保存照片到相册
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //获取新拍照片的元数据
            metaData = [info objectForKey:UIImagePickerControllerMediaMetadata];
            exifData = [metaData objectForKey:@"{Exif}"];
            //获取照片时间
            nsPhotoData = [exifData objectForKey:@"DateTimeOriginal"];
            NSLog(@"拍照时间=%@", nsPhotoData);
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        else
        {
            NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library assetForURL:assetURL
                     resultBlock:^(ALAsset *asset) {
//                         metaData = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
                         nsPhotoData = [ asset valueForProperty:ALAssetPropertyDate ] ;
                         NSLog(@"拍照时间=%@", nsPhotoData);
                     }
                    failureBlock:^(NSError *error) {
                    }];
        }
        imageView.image = image;
    }
    else//视频
    {
        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        [self saveVideo:mediaURL];
    }
    
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

-(void)video:(UIImage *)video didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    if(error)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                           message:@"不能保存视频到相册"
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }
    [alert show];
    
}

- (void)saveVideo:(NSURL *)mediaURL
{
    BOOL bCompatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaURL.path);
    if( bCompatible )
    {
        UISaveVideoAtPathToSavedPhotosAlbum(mediaURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (IBAction)commit:(id)sender {
    //获取temp目录
    NSString *tempPath = NSTemporaryDirectory();
}

@end
