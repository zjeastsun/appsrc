#import <Foundation/Foundation.h>

#define BRIDGE SingletonBridge *bridge; bridge = [SingletonBridge sharedInstance];

@interface SingletonBridge: NSObject


@property (strong, nonatomic) NSString *sRuleType;
@property (strong, nonatomic) NSString *sRuleOption;

+ (SingletonBridge *)sharedInstance;
- (void)unInit;

@end