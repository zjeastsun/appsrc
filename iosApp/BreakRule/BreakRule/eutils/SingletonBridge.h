#import <Foundation/Foundation.h>

#define BRIDGE SingletonBridge *bridge; bridge = [SingletonBridge sharedInstance];

@interface SingletonBridge: NSObject


@property (strong, nonatomic) NSString *nsRuleType;
@property (strong, nonatomic) NSString *nsRuleOption;
@property (strong, nonatomic) NSString *nsContent;//违规内容、整改内容、批阅内容等

@property (strong, nonatomic) NSString *nsSafetySubItemId;//安全分项
@property (strong, nonatomic) NSString *nsSafetySubItemName;

@property (strong, nonatomic) NSString *nsProjectType;
@property (strong, nonatomic) NSString *nsCheckItem;

+ (SingletonBridge *)sharedInstance;
- (void)unInit;

@end