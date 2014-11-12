//ios应用全局函数

#import"eutils.h"
#import"Global.h"
#import "Location.h"

@interface IosUtils: NSObject

#pragma mark -
#pragma mark 消息函数
+ (void)MessageBox:(NSString *)msg;
+ (void)MessageBox:(string)msgs withTitle:(string)sTitle;

#pragma mark -
#pragma mark 键盘
/** 在view上添加一个UITapGestureRecognizer，实现点击键盘以外空白区域隐藏键盘。*/
+ (void)addTapGuestureOnView:(UIView *)view;

#pragma mark -
#pragma mark 照片处理函数
/**获取照片信息*/
+ (PHOTOINFO)getPhotoInfo:(NSDictionary *)info fromAlbum:(bool)bAlbum;
/**照片中写入gps信息*/
+ (NSDictionary *)writeGpsToPhoto:(NSDictionary *)mediaInfo location:(CLLocation *)loc;
/**保持图片到相册*/
+ (void)writeCGImage:(UIImage*)image metadata:(NSDictionary *)metadata;

@end