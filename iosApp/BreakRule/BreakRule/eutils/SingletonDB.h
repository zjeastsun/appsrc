#import <Foundation/Foundation.h>
//#import "sqlite3.h"
#import"eutils.h"

#define LOCALDB SingletonDB *localDB; localDB = [SingletonDB sharedInstance];

@interface SingletonDB : NSObject

//@property (nonatomic) sqlite3 *g_localDB;
@property (nonatomic) CSQLiteUtil *g_localDB;

+ (SingletonDB *)sharedInstance;
- (void)unInit;
+ (void)moveDbToSandBox;

@end