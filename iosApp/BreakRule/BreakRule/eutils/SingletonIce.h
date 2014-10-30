//ice访问单例
#import <Foundation/Foundation.h>
#import"Eutils.h"

#define ONEICE SingletonIce *oneIce; oneIce = [SingletonIce sharedInstance];

@interface SingletonIce : NSObject

@property (nonatomic) CICEDBUtil *g_db;

+ (SingletonIce *)sharedInstance;
- (void)unInit;

+ (NSString *)valueNSString:(CSelectHelp)help rowForHelp:(int)row KeyForHelp:(std::string)key;
+ (string)NSStringToGBstring:(NSString *)nsString;

@end