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
        _nsRuleTypeForReviewBR = @"全部";
    }
    
    return self;
    
}

- (void)unInit {

    
}

+ (NSString *)getReviewTypeName:(int)iType
{
    if (iType == REVIEW_PASS)
        return @"审核通过";
    
    if (iType == REVIEW_NOT_NEED_RECTIFY)
        return @"无需整改";
    
    if (iType == REVIEW_CANNOT_JUDGE)
        return @"无法判定";
    
    if (iType == REVIEW_NO_PASS)
        return @"审核不通过";
    
    return @"审核通过";
}

+ (int)getReviewTypeId:(NSString *)nsName
{
    if ([nsName isEqualToString:@"审核通过"])
        return 0;
    
    if ([nsName isEqualToString:@"无需整改"])
        return 1;
    
    if ([nsName isEqualToString:@"无法判定"])
        return 2;
    
    if ([nsName isEqualToString:@"审核不通过"])
        return 3;
    
    return 0;
}

+ (void)MessageBox:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)MessageBox:(string)sMsg withTitle:(string)sTitle
{
    NSString *nsMsg;
    NSString *nsTitle;
    nsMsg = [NSString stringWithCString:const_cast<char*>(sMsg.c_str()) encoding:NSUTF8StringEncoding];
    nsTitle = [NSString stringWithCString:const_cast<char*>(sTitle.c_str()) encoding:NSUTF8StringEncoding];
    
    if( sTitle == "" )
    {
        nsTitle = @"提示";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nsTitle
                                                    message:nsMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end