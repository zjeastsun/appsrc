//本地数据库访问单例
#import <Foundation/Foundation.h>
#import"eutils.h"

#define LOCALDB SingletonDB *localDB; localDB = [SingletonDB sharedInstance];
#define LOCALDBNAME "break_law_init";//本地数据库文件名

@interface SingletonDB : NSObject

@property (nonatomic) CSQLiteUtil *g_localDB;

+ (SingletonDB *)sharedInstance;
- (void)unInit;

/**将工程中的数据库文件复制到沙盒中,只在程序第一次运行时执行*/
+ (void)moveDbToSandBox;

- (void)loginDb;

@end