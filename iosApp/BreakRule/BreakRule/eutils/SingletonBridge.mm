#import "SingletonBridge.h"

@implementation SingletonBridge


+ (SingletonBridge *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static SingletonBridge *singletonInstanceBridge= nil;
    
    dispatch_once(&onceToken, ^{
        singletonInstanceBridge = [[SingletonBridge alloc] init];
    });
    
    return singletonInstanceBridge;
}

- (id)init {
    
    if (self = [super init]) {

        _nsRuleType = @"一般违规";
        _nsRuleOption = @"用户自定义";
        _nsProjectType = @"0";
        _nsProjectTypeName = @"全部项目";
        _nsRuleTypeForCondition = @"全部";
    }
    
    return self;
    
}

- (void)unInit {

    
}

@end