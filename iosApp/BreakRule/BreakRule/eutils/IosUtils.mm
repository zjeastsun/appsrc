#import "IosUtils.h"
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>


@implementation IosUtils

#pragma mark -
#pragma mark 消息函数

+ (void)MessageBox:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)MessageBox:(string)sMsg withTitle:(string)sTitle
{
    NSString *nsMsg;
    NSString *nsTitle;
    nsMsg = [NSString stringWithCString:const_cast<char*>(sMsg.c_str()) encoding:NSUTF8StringEncoding];
    nsTitle = [NSString stringWithCString:const_cast<char*>(sTitle.c_str()) encoding:NSUTF8StringEncoding];
    
    if( sTitle == "" )
    {
        nsTitle = @"提示";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nsTitle
                                                    message:nsMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark -
#pragma mark 键盘
// 当通过键盘在输入完毕后，点击屏幕空白区域关闭键盘的操作。
+(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

// 在view上添加一个UITapGestureRecognizer，实现点击键盘以外空白区域隐藏键盘。
+ (void)addTapGuestureOnView:(UIView *)view
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    // 是否取消手势识别
    tapGr.cancelsTouchesInView = NO;
    [view addGestureRecognizer:tapGr];
}



#pragma mark -
#pragma mark 照片处理函数
+ (PHOTOINFO)getPhotoInfo:(NSDictionary *)info fromAlbum:(bool)bAlbum
{
    __block PHOTOINFO stInfo;
    __block NSDictionary *metaData;
    NSDictionary *exifData;
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    if (bAlbum) {//无法正常获取数据，如下代码还有问题？
        NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:assetURL
                 resultBlock:^(ALAsset *asset) {
                     NSDate* picDate = [ asset valueForProperty:ALAssetPropertyDate ];
                     NSString* nsPicDate = [dateformatter stringFromDate:picDate];
                     stInfo.sTime = [nsPicDate UTF8String];
                     
                     metaData = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
                     NSDictionary *GPSDict = [metaData objectForKey:( NSString*)CFBridgingRelease(kCGImagePropertyGPSDictionary)];
                     if (GPSDict != nil) {
                         CLLocation *loc = [GPSDict DictionaryToLocation];
                         
                         NSString *nsLatitude = [NSString stringWithFormat:@"%f", loc.coordinate.latitude ];
                         stInfo.sLatitude = [nsLatitude UTF8String];
                         NSString *nsLongitude = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
                         stInfo.sLongitude = [nsLongitude UTF8String];
                     }
                     else
                     {//没有定位信息重新获取定位
                         
                     }
//                     NSLog(@"%@",GPSDict);
                 }
                failureBlock:^(NSError *error) {
                }];
    }
    else
    {
        //获取新拍照片的元数据
        metaData = [info objectForKey:UIImagePickerControllerMediaMetadata];
        exifData = [metaData objectForKey:@"{Exif}"];
        //获取照片时间
        NSString* nsPicDate = [exifData objectForKey:@"DateTimeOriginal"];
        nsPicDate = [nsPicDate stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"-"];
        nsPicDate = [nsPicDate stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"-"];
        stInfo.sTime = [nsPicDate UTF8String];
    }
    
    
    return stInfo;
}

+ (NSDictionary *)writeGpsToPhoto:(NSDictionary *)mediaInfo location:(CLLocation *)loc
{
    //获取照片元数据
    NSDictionary *dict = [mediaInfo objectForKey:UIImagePickerControllerMediaMetadata];
    NSDictionary *metadata = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    //将GPS数据写入图片并保存到相册
    NSDictionary * gpsDict=[loc LocationToDictionary];//CLLocation对象转换为NSDictionary
    if (metadata && gpsDict) {
        [metadata setValue:gpsDict forKey:(NSString*)CFBridgingRelease(kCGImagePropertyGPSDictionary)];
        return metadata;
    }
    return nil;
}

/*
 保存图片到相册
 */
+ (void)writeCGImage:(UIImage*)image metadata:(NSDictionary *)metadata{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Write image with metadata to Photo Library");
        }
    };
    
    //保存相片到相册 注意:必须使用[image CGImage]不能使用强制转换: (__bridge CGImageRef)image,否则保存照片将会报错
    [library writeImageToSavedPhotosAlbum:[image CGImage]
                                 metadata:metadata
                          completionBlock:imageWriteCompletionBlock];
}

@end