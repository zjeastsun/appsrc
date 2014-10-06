#import "SingletonDB.h"

@implementation SingletonDB


+ (SingletonDB *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static SingletonDB *singletonInstanceLocalDB= nil;
    
    dispatch_once(&onceToken, ^{
        singletonInstanceLocalDB = [[SingletonDB alloc] init];
    });
    
    return singletonInstanceLocalDB;
}

+ (void)moveDbToSandBox
{
    //1、获得数据库文件在工程中的路径——源路径。
    NSString *sourcesPath = [[NSBundle mainBundle] pathForResource:@"break_law_init" ofType:@"db"];
    
    //2、获得沙盒中Document文件夹的路径——目的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *desPath = [documentPath stringByAppendingPathComponent:@"break_law_init.db"];
    
    if (sourcesPath == nil ) {
        return;
    }
    
    //3、通过NSFileManager类，将工程中的数据库文件复制到沙盒中。
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:desPath])
    {
        NSError *error ;
        
        if ([fileManager copyItemAtPath:sourcesPath toPath:desPath error:&error]) {
            NSLog(@"数据库移动成功");
        }
        else {
            NSLog(@"数据库移动失败");
        }
        
    }
    
}

- (void)loginDb
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbFileName = @"break_law_init.db";
    NSString *dataFilePath = [documentsDirectory stringByAppendingPathComponent:dbFileName];
    
    string sDataFilePath = [dataFilePath UTF8String];
    if (!_g_localDB->isLogin()) {
        bool bLogin = _g_localDB->login( sDataFilePath );
        if (!bLogin) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:@"本地数据库连接失败"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
}

- (id)init {
    
    if (self = [super init]) {
        _g_localDB = new CSQLiteUtil();
        [SingletonDB moveDbToSandBox];
        [self loginDb];
    }
    
    return self;
    
}

- (void)unInit {
//    
//    if( _g_db != NULL )
//    {
//        delete _g_db;
//    }
    
}



@end