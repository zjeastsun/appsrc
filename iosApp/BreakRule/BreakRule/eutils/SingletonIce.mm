#import "SingletonIce.h"

@implementation SingletonIce


+ (SingletonIce *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static SingletonIce *singletonInstanceIce= nil;
    
    dispatch_once(&onceToken, ^{
        singletonInstanceIce = [[SingletonIce alloc] init];
    });
    
    return singletonInstanceIce;
}

- (id)init {
    
    if (self = [super init]) {
        _g_db = new CICEDBUtil();
        _g_db->setFileCache(40960);

    }
    
    return self;
    
}

- (void)unInit {
    
    if( _g_db != NULL )
    {
        delete _g_db;
    }

}

@end