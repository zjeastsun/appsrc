//ice访问单例
#import <Foundation/Foundation.h>
#import"Eutils.h"

#define ONEICE SingletonIce *oneIce; oneIce = [SingletonIce sharedInstance];

const string DATA_FILE_FOLDER = "test";//服务器保存照片的相对路径文件夹

@interface SingletonIce : NSObject

@property (nonatomic) CICEDBUtil *g_db;

+ (SingletonIce *)sharedInstance;
- (void)unInit;

+ (NSString *)valueNSString:(CSelectHelp)help rowForHelp:(int)row KeyForHelp:(std::string)key;
+ (string)NSStringToGBstring:(NSString *)nsString;
+ (NSString *)getFullTempPathName:(NSString *)nsFileName;//获取temp目录全路径文件名

- (bool)downloadFile:(NSString *)nsFileName;

@end