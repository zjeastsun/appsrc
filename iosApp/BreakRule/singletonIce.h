#import <Foundation/Foundation.h>
#import"eutils.h"

@interface singletonIce : NSObject


@property (strong, nonatomic) NSString *value;
@property (nonatomic) CICEDBUtil *g_db;

+ (singletonIce *)sharedInstance;
- (void)unInit;

@end