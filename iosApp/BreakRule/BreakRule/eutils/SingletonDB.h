#import <Foundation/Foundation.h>
#import "sqlite3.h"

#define ONEICE SingletonDB *localDB; localDB = [SingletonDB sharedInstance];

@interface SingletonDB : NSObject

@property (nonatomic) sqlite3 *g_localDB;

+ (SingletonDB *)sharedInstance;
- (void)unInit;
+ (void)moveDbToSandBox;

@end