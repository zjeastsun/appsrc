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
#import "SingletonIce.h"

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
    
    
    [self addTapGuestureOnView];
    // 注册通知，当键盘将要弹出时执行keyboardWillShow方法。
    [self registerObserverForKeyboard];
    
    pBR = self;
    [progressView setHidden:YES];
    [progressView setProgressViewStyle:UIProgressViewStyleDefault]; //设置进度条类型
}

// 当通过键盘在输入完毕后，点击屏幕空白区域关闭键盘的操作。
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

// 在view上添加一个UITapGestureRecognizer，实现点击键盘以外空白区域隐藏键盘。
- (void)addTapGuestureOnView
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    // 是否取消手势识别
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
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
        
        if ([cell.detailTextLabel.text isEqualToString:@"一般违规"]) {
            nsBreakRuleType = @"0";
        }
        else if ([cell.detailTextLabel.text isEqualToString:@"严重违规"])
        {
            nsBreakRuleType = @"1";
        }
        else if ([cell.detailTextLabel.text isEqualToString:@"重大违规"])
        {
            nsBreakRuleType = @"2";
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
    
    if( picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum || picker.cameraCaptureMode == UIImagePickerControllerCameraCaptureModePhoto )//照片
    {
        //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//裁剪的照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始照片
        
        __block NSDictionary *metaData;
        NSDictionary *exifData;
//        __block NSString *nsPhotoData;
        
        //如果是从摄像头拍照来的保存照片到相册
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //获取新拍照片的元数据
            metaData = [info objectForKey:UIImagePickerControllerMediaMetadata];
            exifData = [metaData objectForKey:@"{Exif}"];
            //获取照片时间
            nsPhotoData = [exifData objectForKey:@"DateTimeOriginal"];
            NSLog(@"相册照片拍照时间=%@", nsPhotoData);
            
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
    if(error)
    {
        [SingletonBridge MessageBox:@"不能保存照片到相册"];
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
        [SingletonBridge MessageBox:@"不能保存视频到相册"];
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
    iResult = oneIce.g_db->command("get_sequence", "pic_id", sPicName);
    if( iResult<0 )
    {
        [SingletonBridge MessageBox:"获取照片ID错误" withTitle:"数据库错误"];
        return;
    }
    
    sPicName += ".jpg";
    NSString *nsPicName = [NSString stringWithFormat:@"%s", sPicName.c_str()];
    
    NSString *nsDesPathName = [filePath stringByAppendingPathComponent:nsPicName];
    
    //保存图片
    BOOL result = [UIImagePNGRepresentation(imageView.image)writeToFile: nsDesPathName    atomically:YES];
    if (result) {
        NSLog(@"success");
    }
    
    //获取保存得图片
//    UIImage *img = [UIImage imageWithContentsOfFile:nsDesPathName];
//    imageView.image = img;
    
    string sDesPathName = [nsDesPathName UTF8String];
  
    iResult = oneIce.g_db->upload(sDesPathName, "test", Process, ProcessFinished);
    if( iResult<0 )
    {
        [SingletonBridge MessageBox:"上传照片错误" withTitle:"传输错误"];
        return;
    }
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  nsTime=[dateformatter stringFromDate:senddate];
    
    string strError;
    string strParam="";
    const string sqlcode="put_break_law_info";

    string sBreakRuleId = "";
    iResult = oneIce.g_db->command("get_sequence", "break_rule_id", sBreakRuleId);
    if( iResult<0 )
    {
        [SingletonBridge MessageBox:"获取违规ID错误" withTitle:"数据库错误"];
        return;
    }
    
    string sNodeId;
    util::string_format(sNodeId, "%d", FLOW_NODE_BR_REVIEW_1);
    string sOrgId = [bridge.nsOrgIdSelected UTF8String];
    string sUserId = [bridge.nsUserId UTF8String];
    
    string sBreakRuleContent = [SingletonIce NSStringToGBstring:contentTextView.text];
    
//    string sPicName = "pic.jpg";
    string sPicTime = [nsTime UTF8String];//[nsPhotoData UTF8String];//时间不能正确获取？？
    string sBreakRuleType = [nsBreakRuleType UTF8String];
    string sUpdateTime = [nsTime UTF8String];
    string sLongitude = "0";
    string sLatitude = "0";
    
    SelectHelpParam helpParam;
    helpParam.add(sBreakRuleId);
    helpParam.add(sNodeId);
    helpParam.add(sOrgId);
    helpParam.add(sUserId);
    helpParam.add(sBreakRuleContent);
    helpParam.add(sPicName);
    helpParam.add(sPicTime);
    helpParam.add(sBreakRuleType);
    helpParam.add(sUpdateTime);
    helpParam.add(sLongitude);
    helpParam.add(sLatitude);
    strParam = helpParam.get();
    
    CSelectHelp	help;
    oneIce.g_db->execCmd("", sqlcode, strParam, help, strError);
    if( iResult<0 )
    {
        [SingletonBridge MessageBox:strError withTitle:"数据库错误"];
        return;
    }

    [self back:nil];
}

- (IBAction)commit:(id)sender {
    
//    || nsPhotoData.length == 0//为什么这个判断会出错呢？
    if (nsPhotoData == nil )
    {
        [SingletonBridge MessageBox:@"您还没有拍照或者导入照片！"];
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
