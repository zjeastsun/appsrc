//用于gps定位处理

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>

@interface NSDictionary (CLLocation)

/**图片的GPSDictionary转化为CLLocation对象*/
- (CLLocation*)DictionaryToLocation;

@end

@interface CLLocation (NSDictionary)

/**CLLocation对象转换为图片的GPSDictionary*/
- (NSDictionary*)LocationToDictionary;
+ (void)lacationInit:(id)id locationManager:(CLLocationManager*)manager;

@end