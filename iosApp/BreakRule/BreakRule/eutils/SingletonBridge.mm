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

        _sRuleType = @"一般违规";
        _sRuleOption = @"用户自定义";
    }
    
    return self;
    
}

- (void)unInit {

    
}

@end