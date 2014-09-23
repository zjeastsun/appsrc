#import "singletonIce.h"

@implementation singletonIce


+ (singletonIce *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static singletonIce *singletonInstanceIce= nil;
    
    dispatch_once(&onceToken, ^{
        singletonInstanceIce = [[singletonIce alloc] init];
    });
    
    return singletonInstanceIce;
}

- (id)init {
    
    if (self = [super init]) {
        
        _g_db = new CICEDBUtil();
        //        self.value = [[UITextField alloc]init];
        
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