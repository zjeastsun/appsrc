#import <Foundation/Foundation.h>
#import"Eutils.h"

#define ONEICE {oneIce = [SingletonIce sharedInstance];}

@interface SingletonIce : NSObject


@property (strong, nonatomic) NSString *value;
@property (nonatomic) CICEDBUtil *g_db;

+ (SingletonIce *)sharedInstance;
- (void)unInit;

@end