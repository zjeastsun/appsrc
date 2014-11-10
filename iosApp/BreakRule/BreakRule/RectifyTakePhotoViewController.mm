//
//  RectifyTakePhotoViewController.m
//  BreakRule
//
//  Created by mac on 14-11-2.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "RectifyTakePhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SJAvatarBrowser.h"
#import "SingletonIce.h"
#import "IosUtils.h"

RectifyTakePhotoViewController *pRectifyTakePhotoView;

@interface RectifyTakePhotoViewController ()

@end

@implementation RectifyTakePhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)downloadPic
{
    BRIDGE
    ONEICE
    
    bool bFileExits = [SingletonIce fileExistsInTemp:bridge.nsRectify_PicNameSelected];
    
    bool bResult;
    if ( !bFileExits ) {
        bResult = [oneIce downloadFile:bridge.nsRectify_PicNameSelected Callback:nil DoneCallback:nil];
        
        [actView stopAnimating];
        [actView setHidden:YES];
        
        if (!bResult) {
            [IosUtils MessageBox:@"图片下载失败！"];
            return;
        }
    }
    
    NSString *nsDesPathName = [SingletonIce getFullTempPathName:bridge.nsRectify_PicNameSelected];
    //获取保存得图片
    
    UIImage *img = [UIImage imageWithContentsOfFile:nsDesPathName];
    breakRuleImageView.image = img;
    
    [actView stopAnimating];
    [actView setHidden:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    bTransmit = false;
    [progressLabel setHidden:YES];
    
    breakRuleImageView.userInteractionEnabled = YES;
    rectifyImageView.userInteractionEnabled = YES;
    
    //点击放大图片
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
    
    [breakRuleImageView addGestureRecognizer:tap];
    [rectifyImageView addGestureRecognizer:tap];
    
    [IosUtils addTapGuestureOnView:self.view];
    // 注册通知，当键盘将要弹出时执行keyboardWillShow方法。
    [self registerObserverForKeyboard];
    
    pRectifyTakePhotoView = self;
    [progressView setHidden:YES];
    [progressView setProgressViewStyle:UIProgressViewStyleDefault]; //设置进度条类型
    
    BRIDGE
    breakRuleTextView.text = bridge.nsRectify_BreakRuleContentSelected;
    
    [actView setHidden:NO];
    [actView startAnimating];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadPic) object:nil];
    [thread start];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    scrollView.frame = CGRectMake(0, 0, kWidthOfMainScreen, kHeightOfMainScreen);
}

- (void)magnifyImage
{
    NSLog(@"局部放大");
    if (breakRuleImageView.image != nil) {
        [SJAvatarBrowser showImage:breakRuleImageView];//调用方法
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
    if (bTransmit) {
        return;
    }
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    
    if (bTransmit) {
        return;
    }
    
    if (rectifyTextView.text == nil || [rectifyTextView.text length] == 0)
    {
        [IosUtils MessageBox:@"您还没有输入整改内容！"];
        return;
    }
    
    if (stPhotoInfo.sTime == "" )
    {
        [IosUtils MessageBox:@"您还没有拍照或者导入照片！"];
        return;
    }
    [progressView setProgress:0];
    [progressView setHidden:NO];
    [progressLabel setHidden:NO];
    progressLabel.text = @"正在上传...";
    
    bTransmit = true;
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(insertInfoToDb:) object:nil];
    [thread start];
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if( picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum || picker.cameraCaptureMode == UIImagePickerControllerCameraCaptureModePhoto )//照片
    {
        //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//裁剪的照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始照片
        
        //如果是从摄像头拍照来的保存照片到相册
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            bFromPhotosAlbum = false;
            [locationManager startUpdatingLocation];
            
            //照片mediaInfo
            curMediaInfo=[NSDictionary dictionaryWithDictionary:info];
            stPhotoInfo = [IosUtils getPhotoInfo:info fromAlbum:bFromPhotosAlbum];
        }
        else
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
        rectifyImageView.image = image;
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
    [pRectifyTakePhotoView->progressView setProgress:fProgress/100];
    progressLabel.text = [NSString stringWithFormat:@"已上传:%0.0f%%", fProgress ];
}

void ProcessFinishedForRectify(string path, int iResult, const string &sError)
{
	printf("finished %s--%d,%s", path.c_str(), iResult, sError.c_str());
    [pRectifyTakePhotoView->progressView setHidden:YES];
    [pRectifyTakePhotoView->progressLabel setHidden:YES];
}

void ProcessForRectify(string path, double iProgress)
{
	printf("  %s--%0.2f ", path.c_str(), iProgress );
    pRectifyTakePhotoView->fProgress = iProgress;
    [pRectifyTakePhotoView performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
    
}

-(void)insertInfoToDb:(NSString *)param
{
    ONEICE
    BRIDGE
    
    int iResult = 0;
    
    //获取temp目录
    NSString *filePath = NSTemporaryDirectory();
    
    string sPicName;
    sPicName = [oneIce getId:SEQ_pic_id];
    if( sPicName == "" )
    {
        [IosUtils MessageBox:"获取照片ID错误" withTitle:"数据库错误"];
        return;
    }
    
    sPicName += ".jpg";
    NSString *nsPicName = [NSString stringWithFormat:@"%s", sPicName.c_str()];
    
    NSString *nsDesPathName = [filePath stringByAppendingPathComponent:nsPicName];
    
    //保存图片
    BOOL bResult = [UIImagePNGRepresentation(rectifyImageView.image)writeToFile: nsDesPathName    atomically:YES];
    if (bResult) {
        NSLog(@"success");
    }
    
    string sDesPathName = [nsDesPathName UTF8String];
    
    iResult = oneIce.g_db->upload(sDesPathName, REMOTE_PIC_PATH, ProcessForRectify, ProcessFinishedForRectify);
    if( iResult<0 )
    {
        [IosUtils MessageBox:"上传照片错误" withTitle:"传输错误"];
        return;
    }
    
    string strError;
    bResult = [oneIce putRectifyInfo:rectifyTextView.text picName:sPicName picInfo:stPhotoInfo error:strError];
    if( !bResult )
    {
        [IosUtils MessageBox:strError withTitle:"数据库错误"];
        bTransmit = false;
        return;
    }
    
    bTransmit = false;
    [self back:nil];
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
