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

        _nsRuleOption = @"用户自定义";
        _nsProjectType = @"0";
        _nsProjectTypeName = @"全部项目";
        
        _nsRuleType = @"一般违规";
        _nsRuleTypeForReviewBR = @"全部";
        _nsRuleTypeForQuery = @"全部";
        _nsRuleTypeForReviewRectify = @"全部";
        _nsRuleTypeForRectify = @"全部";
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

+ (string)getBreakRuleTypeByName:(NSString *)nsName
{
    string sRuleType;
    if ([nsName isEqualToString:@"一般违规"]) {
        sRuleType = "0";
    }
    else if ([nsName isEqualToString:@"严重违规"])
    {
        sRuleType = "1";
    }
    else if ([nsName isEqualToString:@"重大违规"])
    {
        sRuleType = "2";
    }
    else
    {
        sRuleType = "0";
    }
    return sRuleType;
}

+(NSString *)getBreakRuleTypeNameById:(NSString *)nsId
{
    NSString *nsBreakRuleType;
    
    if ([nsId isEqualToString:@"0"]) {
        nsBreakRuleType = @"一般违规";
    }
    else if ([nsId isEqualToString:@"1"]) {
        nsBreakRuleType = @"严重违规";
    }
    else if ([nsId isEqualToString:@"2"]) {
        nsBreakRuleType = @"重大违规";
    }
    return nsBreakRuleType;
}

- (bool)hasRight:(string)sRightId
{
	string sTemp;
    
	if( [_nsLoginName isEqualToString:@"SysAdmin"] )
	{
		return true;
	}
    
	for( unsigned int i=0; i<_helpRight.size(); i++)
	{
		if( _helpRight.valueString( i, "privilege_code" ) == sRightId )
		{
			return true;
		}
	}
	return false;
}

@end