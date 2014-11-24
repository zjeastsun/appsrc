#import "Location.h"

@implementation NSDictionary (CLLocation)

- (CLLocation*)DictionaryToLocation{
    CLLocationDegrees latitude= [(NSNumber*)[self objectForKey:(NSString*)CFBridgingRelease(kCGImagePropertyGPSLatitude)] doubleValue];
    CLLocationDegrees longitude= [(NSNumber*)[self objectForKey:(NSString*)CFBridgingRelease(kCGImagePropertyGPSLongitude)] doubleValue];
    CLLocationDistance altitude= [(NSNumber*)[self objectForKey:(NSString*)CFBridgingRelease(kCGImagePropertyGPSAltitude)] doubleValue];
    
    NSTimeZone    *timeZone   = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"HH:mm:ss.SS"];
    NSString * timeStamp=[self objectForKey:(NSString*)CFBridgingRelease(kCGImagePropertyGPSTimeStamp)];
    NSDate *timeDate=[formatter dateFromString:timeStamp];
    
    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(latitude, longitude);
    CLLocation *loc=[[CLLocation alloc] initWithCoordinate:(CLLocationCoordinate2D)coordinate
                                                  altitude:altitude
                                        horizontalAccuracy:0
                                          verticalAccuracy:0
                                                 timestamp:timeDate];
    return loc;
}
@end

@implementation CLLocation (NSDictionary)

- (NSDictionary*)LocationToDictionary{
    NSTimeZone    *timeZone   = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"HH:mm:ss.SS"];
    CLLocation *location=self;
    NSDictionary *gpsDict   = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithFloat:fabs(location.coordinate.latitude)], kCGImagePropertyGPSLatitude,
                               ((location.coordinate.latitude >= 0) ? @"N" : @"S"), kCGImagePropertyGPSLatitudeRef,
                               [NSNumber numberWithFloat:fabs(location.coordinate.longitude)], kCGImagePropertyGPSLongitude,
                               ((location.coordinate.longitude >= 0) ? @"E" : @"W"), kCGImagePropertyGPSLongitudeRef,
                               [formatter stringFromDate:[location timestamp]], kCGImagePropertyGPSTimeStamp,
                               nil];
    return gpsDict;
}

//+ (void)lacationInit:(id)id locationManager:(CLLocationManager*)manager
//{
//    if (!manager) {
//        manager = [[CLLocationManager alloc]init];
//        [manager setDelegate:id];
//        [manager setDistanceFilter:kCLDistanceFilterNone];
//        [manager setDesiredAccuracy:kCLLocationAccuracyBest];
//    }
//}


@end