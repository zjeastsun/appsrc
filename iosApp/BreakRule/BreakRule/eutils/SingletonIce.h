#import <Foundation/Foundation.h>
#import"Eutils.h"

#define ONEICE SingletonIce *oneIce; oneIce = [SingletonIce sharedInstance];

@interface SingletonIce : NSObject

@property (nonatomic) CICEDBUtil *g_db;

+ (SingletonIce *)sharedInstance;
- (void)unInit;

@end