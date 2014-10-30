//本地数据库访问单例
#import <Foundation/Foundation.h>
#import"eutils.h"

#define LOCALDB SingletonDB *localDB; localDB = [SingletonDB sharedInstance];

@interface SingletonDB : NSObject

@property (nonatomic) CSQLiteUtil *g_localDB;

+ (SingletonDB *)sharedInstance;
- (void)unInit;
+ (void)moveDbToSandBox;
- (void)loginDb;

@end