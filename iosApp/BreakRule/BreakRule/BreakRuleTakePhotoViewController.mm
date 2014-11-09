//
//  BreakRuleTakePhotoViewController.m
//  BreakRule
//
//  Created by mac on 14-9-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "BreakRuleTakePhotoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "SJAvatarBrowser.h"
#import "SingletonIce.h"
#import "IosUtils.h"

BreakRuleTakePhotoViewController *pBR;

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
    
    [IosUtils addTapGuestureOnView:self.view];
    // 注册通知，当键盘将要弹出时执行keyboardWillShow方法。
    [self registerObserverForKeyboard];
    
    pBR = self;
    [progressView setHidden:YES];
    [progressView setProgressViewStyle:UIProgressViewStyleDefault]; //设置进度条类型
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
    if (bridge.nsContent != nil && [bridge.nsContent length] != 0)
    {
        contentTextView.text = bridge.nsContent;
    }
    
    scrollView.frame = CGRectMake(0, 0, kWidthOfMainScreen, kHeightOfMainScreen);
    
    [self lacationInit];
}

- (void)magnifyImage
{
    NSLog(@"局部放大");
    if (imageView.image != nil) {
        [SJAvatarBrowser showImage:imageView];//调用方法
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

- (void)lacationInit
{
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc]init];
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
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
        imagePicker.delegate = (id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self;//有导航栏的代理
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
    
    //图片质量处理，大小控制？
    
    if( picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum || picker.cameraCaptureMode == UIImagePickerControllerCameraCaptureModePhoto )//照片
    {
        //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//裁剪的照片
        UIImage *ima = [info objectForKey:UIImagePickerControllerOriginalImage];//原始照片
        
        //如果是从摄像头拍照来的保存照片到相册
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            bFromPhotosAlbum = false;
            [locationManager startUpdatingLocation];
            
            //照片mediaInfo
            curMediaInfo=[NSDictionary dictionaryWithDictionary:info];
            stPhotoInfo = [IosUtils getPhotoInfo:info fromAlbum:bFromPhotosAlbum];
//            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        else//相片库照片
        {
            bFromPhotosAlbum = true;
            /*
            stPhotoInfo = [IosUtils getPhotoInfo:info fromAlbum:bFromPhotosAlbum];
            if (stPhotoInfo.sLatitude == "") {
                [locationManager startUpdatingLocation];
            }
            */
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            
            stPhotoInfo = [IosUtils getPhotoInfo:info fromAlbum:bFromPhotosAlbum];
                    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                    [library assetForURL:assetURL
                             resultBlock:^(ALAsset *asset) {
                                 NSDate* picDate = [ asset valueForProperty:ALAssetPropertyDate ];
                                 NSString* nsPicDate = [dateformatter stringFromDate:picDate];
                                 stPhotoInfo.sTime = [nsPicDate UTF8String];
            
                                 NSDictionary *metaData = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
                                 NSDictionary *GPSDict = [metaData objectForKey:( NSString*)CFBridgingRelease(kCGImagePropertyGPSDictionary)];
                                 if (GPSDict != nil) {
                                     CLLocation *loc = [GPSDict DictionaryToLocation];
            
                                     NSString *nsLatitude = [NSString stringWithFormat:@"%f", loc.coordinate.latitude ];
                                     stPhotoInfo.sLatitude = [nsLatitude UTF8String];
                                     NSString *nsLongitude = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
                                     stPhotoInfo.sLongitude = [nsLongitude UTF8String];
                                 }
                                 else
                                 {//没有定位信息重新获取定位
                                     [locationManager startUpdatingLocation];
                                 }
            //                     NSLog(@"%@",GPSDict);
                             }
                            failureBlock:^(NSError *error) {
                            }];
            
           
        }
        
        
        imageView.image = ima;
        curImage = ima;
    }
    else//视频
    {
        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        [self saveVideo:mediaURL];
    }
    
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        [IosUtils MessageBox:@"不能保存照片到相册"];
    }
    else
    {
//        alert = [[UIAlertView alloc] initWithTitle:@"成功"
//                                           message:@"保存照片到相册成功"
//                                          delegate:self
//                                 cancelButtonTitle:@"OK"
//                                 otherButtonTitles:nil];
    }
    
}

-(void)video:(UIImage *)video didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        [IosUtils MessageBox:@"不能保存视频到相册"];
    }
}

- (void)saveVideo:(NSURL *)mediaURL
{
    BOOL bCompatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaURL.path);
    if( bCompatible )
    {
        UISaveVideoAtPathToSavedPhotosAlbum(mediaURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"定位成功！");
    [manager stopUpdatingLocation];

    NSString *nsLatitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude ];
    stPhotoInfo.sLatitude = [nsLatitude UTF8String];
    
    NSString *nsLongitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    stPhotoInfo.sLongitude = [nsLongitude UTF8String];
    
    if (!bFromPhotosAlbum) {
        NSDictionary *metadata = [IosUtils writeGpsToPhoto:curMediaInfo location:newLocation];
        [IosUtils writeCGImage:curImage metadata:metadata];
    }
    
}

- (void)updateUI
{
    [pBR->progressView setProgress:fProgress/100];
}

void ProcessFinished(string path, int iResult, const string &sError)
{
	printf("finished %s--%d,%s", path.c_str(), iResult, sError.c_str());
    [pBR->progressView setHidden:YES];
}

void Process(string path, double iProgress)
{
	printf("  %s--%0.2f ", path.c_str(), iProgress );
    pBR->fProgress = iProgress;
    [pBR performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
   
}
 
-(void)insertInfoToDb:(NSString *)param
{
    ONEICE
    BRIDGE
    
    int iResult = 0;
    
    //获取temp目录
    NSString *filePath = NSTemporaryDirectory();
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *filePath = [paths objectAtIndex:0];
    string sPicName;
    sPicName = [oneIce getId:SEQ_pic_id];
    if( sPicName == "" )
    {
        [IosUtils MessageBox:"获取照片ID失败" withTitle:"数据库错误"];
        return;
    }
    
    sPicName += ".jpg";
    NSString *nsPicName = [NSString stringWithFormat:@"%s", sPicName.c_str()];
    
    NSString *nsDesPathName = [filePath stringByAppendingPathComponent:nsPicName];
    
    //保存图片
    BOOL bResult = [UIImagePNGRepresentation(imageView.image)writeToFile: nsDesPathName    atomically:YES];
    if (bResult) {
        NSLog(@"success");
    }
    
    //获取保存得图片
//    UIImage *img = [UIImage imageWithContentsOfFile:nsDesPathName];
//    imageView.image = img;
    
//    NSDate *  senddate=[NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *  nsTime=[dateformatter stringFromDate:senddate];
    
    string strError;
    bResult = [oneIce putBreakRuleInfo:contentTextView.text picName:sPicName picInfo:stPhotoInfo error:strError];
    if( !bResult )
    {
        [IosUtils MessageBox:strError withTitle:"数据库错误"];
        return;
    }
    
    string sDesPathName = [nsDesPathName UTF8String];
    
    iResult = oneIce.g_db->upload(sDesPathName, REMOTE_PIC_PATH, Process, ProcessFinished);
    if( iResult<0 )
    {
        [IosUtils MessageBox:"上传照片失败" withTitle:"传输错误"];
        return;
    }
    
    [self back:nil];
}

- (IBAction)commit:(id)sender {
    
//    || nsPhotoDate.length == 0//为什么这个判断会出错呢？
    if (stPhotoInfo.sTime == "" )
    {
        [IosUtils MessageBox:@"您还没有拍照或者导入照片！"];
        return;
    }
    [progressView setProgress:0];
    [progressView setHidden:NO];
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(insertInfoToDb:) object:nil];
    [thread start];

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textViewSelected = textView;
    [self adjustViewForKeyboardReveal:YES textView:textViewSelected];
    
}
/**
 * 键盘展开/收起时，动态调整当前scrollView高度，避免键盘挡住当前textView。
 * @param  showKeyboard    键盘是否弹出
 * @param  textView       当前textView
 */

- (void)adjustViewForKeyboardReveal:(BOOL)showKeyboard textView:(UITextView *)textView
{
    // 获取当前scrollView frame，当键盘弹出时，当前scrollView frame上移一定高度。
    CGRect scrollFrame = scrollView.frame;
    // 如果用户通过点击空白区域收起键盘，视图坐标恢复正常。
    if (!textView) {
        scrollFrame.origin.y = 0;
        [self viewChangeOriginYAnimation:scrollFrame];
        return;
    }
    // 键盘弹出，重新计算scrollView y轴。
    if (showKeyboard) {
        float offsetTop = ABS(scrollView.contentOffset.y) + ABS(scrollView.frame.origin.y);
        // 计算当前textField底部空间高度，如果当前textField下部的空间足以容纳弹出键盘，则不改变当前view高度。
        float bottomHeight = kHeightOfMainScreen + offsetTop - textView.frame.origin.y - textView.frame.size.height;
        
        if (bottomHeight >= keyboardRect.size.height) {
            return;
        }
        // 计算view Y轴位移量，使得弹出键盘和当前textField的距离等于指定值。
        scrollFrame.origin.y -= keyboardRect.size.height + kTextViewPadding - bottomHeight;
    }
    // 当键盘收起时，当前视图frame Y轴置为0。
    else {
        scrollFrame.origin.y = 0;
    }
    [self viewChangeOriginYAnimation:scrollFrame];
}

/**
 * view改变y坐标时，增加动画效果。
 * @param viewFrame view视图的新frame
 */
- (void)viewChangeOriginYAnimation:(CGRect)viewFrame
{
    // 视图上移/下移动画
    [UIView beginAnimations:kAnimationResizeForKeyboard context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    
    scrollView.frame = viewFrame;
    [UIView commitAnimations];
}

/** 注册通知，当键盘将要弹出/收起时执行keyboardWillShow/keyboardWillHide方法。 */
- (void)registerObserverForKeyboard
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/** 键盘弹出通知方法，设置全局弹出键盘fame属性，并动态调整当前scrollView高度。 */
- (void)keyboardWillShow:(NSNotification *)notification
{
    // 返回通知关联的用户信息字典，从中取出弹出键盘尺寸信息。
    NSDictionary *userInfo = [notification userInfo];
    // 取键盘frame的value值，从而获取键盘frame。
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyboardRect = [value CGRectValue];
}

/** 键盘收起通知方法，动态调整当前scrollView高度。 */
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self adjustViewForKeyboardReveal:NO textView:textViewSelected];
}

@end
