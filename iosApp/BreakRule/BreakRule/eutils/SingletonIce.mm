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
        _g_db->setFileCache(409600);

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

+ (NSString *)getFullTempPathName:(NSString *)nsFileName
{
    //获取temp目录
    NSString *filePath = NSTemporaryDirectory();
    
    //获取Document目录
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *filePath = [paths objectAtIndex:0];

    NSString *nsFullPathName = [filePath stringByAppendingPathComponent:nsFileName];
    
    return nsFullPathName;
}

+ (bool)fileExistsInTemp:(NSString *)nsFileName
{
    NSString *nsFullPathName;
    nsFullPathName = [SingletonIce getFullTempPathName:nsFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:nsFullPathName])
    {
        return true;
    }
    return false;
}

- (bool)downloadFile:(NSString *)nsFileName
{
    if (nsFileName == nil) {
        return false;
    }

    NSString *nsDesPathName = NSTemporaryDirectory();
    
    string sDesPathName = [nsDesPathName UTF8String];
    string sFileName = REMOTE_PIC_PATH;
    sFileName += [nsFileName UTF8String];
    
    bool bResult = _g_db->downloadFile(sFileName, sDesPathName);
    
    return bResult;
}

//数据库查询函数------------------------------------------------
//获取项目信息
-(int)getProject:(CSelectHelp &)help loginName:(NSString *)nsLoginName;
{
    string sLoginName = [nsLoginName UTF8String];
    
    string strError;
    string strParam="";
    string sql="select * from T_ORGANIZATION a,T_ORG_TYPE b where org_id in ( select org_id FROM func_query_project( '";
    sql += sLoginName;
    sql += "') ) and a.org_type_id=b.org_type_id and b.org_type='3'";
    
    int iResult = _g_db->select(sql, help, strError);

    return iResult;
}


@end