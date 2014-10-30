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

+ (NSString *)valueNSString:(CSelectHelp)help rowForHelp:(int)row KeyForHelp:(std::string)key
{
    NSString *nsReturn;
    
    string sTemp = help.valueString( row, key );
    char *temp =const_cast<char*>(sTemp.c_str());
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    if (help.size() > 0) {
        nsReturn = [NSString stringWithCString:temp encoding:enc];
        return nsReturn;
    }
    
    return @"";
}

+ (string)NSStringToGBstring:(NSString *)nsString
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    string sReturn = [nsString cStringUsingEncoding: enc];
    return sReturn;
}
@end