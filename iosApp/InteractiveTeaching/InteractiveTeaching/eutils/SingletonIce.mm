#import "SingletonIce.h"
#import "IosUtils.h"

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
        _g_db->setFileCache(CACHE_SIZE);
        _g_db->setFileRetryTimes(RETRRY_TIMES);
        bridge = [SingletonBridge sharedInstance];

    }
    
    return self;
    
}

- (void)unInit {
    
    if( _g_db != NULL )
    {
        delete _g_db;
    }

}

#pragma mark -
#pragma mark 字符串转换

+ (NSString *)valueNSString:(CSelectHelp)help rowForHelp:(NSInteger)row KeyForHelp:(std::string)key
{
    NSString *nsReturn;
    
    string sTemp = help.valueString( static_cast<int>(row), key );
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

#pragma mark -
#pragma mark 文件处理

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

- (bool)downloadFile:(NSString *)nsFileName Callback:(ProgressFileCallback)pF DoneCallback:(ProgressFileDoneCallback)pFinished setBreakSignal:(setBreakTransmitSignalCallback)pSignal
{
    if (nsFileName == nil) {
        return false;
    }

    NSString *nsDesPathName = NSTemporaryDirectory();
    
    string sDesPathName = [nsDesPathName UTF8String];
    string sFileName = REMOTE_PIC_PATH;
    sFileName += [nsFileName UTF8String];
    
    bool bResult = _g_db->downloadFile(sFileName, sDesPathName, pF, pFinished, pSignal);
    
    return bResult;
}

#pragma mark -
#pragma mark 数据库查询函数

//数据库查询函数------------------------------------------------
- (bool)loginCheck:(NSString *)nsUser passWord:(NSString *)nsPwd error:(string &)strError
{
    string strParam="";
    const string sqlcode="login_check";
    
    string sUser = [nsUser UTF8String];
    string sPwd = [nsPwd UTF8String];
    
    SelectHelpParam helpParam;
    helpParam.add(sUser);
    helpParam.add(sPwd);
    strParam = helpParam.get();
    
    int iResult;
    CSelectHelp	helpUser;
    iResult = _g_db->selectCmd("", sqlcode, strParam, helpUser, strError);
    if( iResult<0 )
    {
        return false;
    }
    
    if( helpUser.size() <= 0 )
    {
        strError = "用户名或者密码错误";
        return false;
    }
    return true;
}

- (bool)getUserInfo:(CSelectHelp &)help user:(NSString *)nsUser error:(string &)strError
{
    string sUser = [nsUser UTF8String];
    int iResult = _g_db->selectCmd("", "get_user_info", sUser, help, strError);
    if( iResult<0 )
    {
        return false;
    }
    return true;
}

- (bool)getRight:(CSelectHelp &)help user:(NSString *)nsUser error:(string &)strError
{
    string sUser = [nsUser UTF8String];
    int iResult = _g_db->selectCmd("", "get_right", sUser, help, strError);
    if( iResult<0 )
    {
        return false;
    }
    return true;
}

- (int)getProject:(CSelectHelp &)help user:(NSString *)nsUser error:(string &)strError
{
    string sUser = [nsUser UTF8String];
    
    string strParam="";
    string sql="select * from T_ORGANIZATION a,T_ORG_TYPE b where org_id in ( select org_id FROM func_query_project( '";
    sql += sUser;
    sql += "') ) and a.org_type_id=b.org_type_id and b.org_type='3'";
    
    int iResult = _g_db->select(sql, help, strError);

    return iResult;
}

- (string)getId:(string)sIdSeq
{
    string sId;
    int iResult = _g_db->command("get_sequence", sIdSeq, sId);
    if( iResult<0 )
    {
        return "";
    }
    
    return sId;
}

- (bool)putBreakRuleInfo:(NSString *)nsContent picName:(string)sPicName picInfo:(PHOTOINFO )stInfo error:(string &)strError
{
    string strParam="";
    const string sqlcode="put_break_law_info";
    
    string sBreakRuleId = "";
    sBreakRuleId = [self getId:SEQ_break_rule_id];
    if( sBreakRuleId == "" )
    {
        strError = "获取违规ID失败";
        return false;
    }
    
    string sNodeId;
    util::string_format(sNodeId, "%d", FLOW_NODE_BR_REVIEW_1);
    string sOrgId = [bridge.nsOrgIdSelected UTF8String];
    string sUserId = [bridge.nsUserId UTF8String];
    
    string sBreakRuleContent = [SingletonIce NSStringToGBstring:nsContent];
    string sBreakRuleType = [SingletonBridge getBreakRuleTypeByName:bridge.nsRuleType];
    
    string sPicTime = stInfo.sTime;
    string sLongitude = stInfo.sLongitude;
    string sLatitude = stInfo.sLatitude;

    string sUpdateTime = [IosUtils getTime];
    
    SelectHelpParam helpParam;
    helpParam.add(sBreakRuleId);
    helpParam.add(sNodeId);
    helpParam.add(sOrgId);
    helpParam.add(sUserId);
    helpParam.add(sBreakRuleContent);
    helpParam.add(sPicName);
    helpParam.add(sPicTime);
    helpParam.add(sBreakRuleType);
    helpParam.add(sUpdateTime);
    helpParam.add(sLongitude);
    helpParam.add(sLatitude);
    strParam = helpParam.get();
    
    CSelectHelp	help;
    int iResult = _g_db->execCmd("", sqlcode, strParam, help, strError);
    if( iResult<0 )
    {
        return false;
    }

    return true;
}

//获取权限对应的批阅违规流程节点
- (string)getNodeIdForReviewBR
{
    string sNodeId;
    string sTemp;
    if ([bridge hasRight:RIGHT_BR_REVIEW_1])
    {
        sNodeId += util::string_format(sTemp, "%d,", FLOW_NODE_BR_REVIEW_1);
    }
    else if([bridge hasRight:RIGHT_BR_REVIEW_2])
    {
        sNodeId += util::string_format(sTemp, "%d,", FLOW_NODE_BR_REVIEW_2);
    }
    else if([bridge hasRight:RIGHT_BR_REVIEW_3])
    {
        sNodeId += util::string_format(sTemp, "%d,", FLOW_NODE_BR_REVIEW_3);
    }
    else if([bridge hasRight:RIGHT_BR_REVIEW_4])
    {
        sNodeId += util::string_format(sTemp, "%d,", FLOW_NODE_BR_REVIEW_4);
    }

    sNodeId += "99";
    
    return sNodeId;
}

//获取权限对应的批阅整改流程节点
- (string)getNodeIdForReviewRectify
{
    string sNodeId;
    string sTemp;
    if ([bridge hasRight:RIGHT_RECTIFY_REVIEW_1])
    {
        sNodeId += util::string_format(sTemp, "%d,", FLOW_NODE_RECTIFY_REVIEW_1);
    }
    else if([bridge hasRight:RIGHT_RECTIFY_REVIEW_2])
    {
        sNodeId += util::string_format(sTemp, "%d,", FLOW_NODE_RECTIFY_REVIEW_2);
    }
    else if([bridge hasRight:RIGHT_RECTIFY_REVIEW_3])
    {
        sNodeId += util::string_format(sTemp, "%d,", FLOW_NODE_RECTIFY_REVIEW_3);
    }
    else if([bridge hasRight:RIGHT_RECTIFY_REVIEW_4])
    {
        sNodeId += util::string_format(sTemp, "%d,", FLOW_NODE_RECTIFY_REVIEW_4);
    }
    
    sNodeId += "99";
    
    return sNodeId;
    
}

- (int)getPreReviewBreakRule:(CSelectHelp &)help error:(string &)strError
{
    string strParam="";
    string sqlcode="get_break_last_view_review";
    SelectHelpParam helpParam;

    string sNodeId = [self getNodeIdForReviewBR];
    
    if ([bridge.nsRuleTypeForReviewBR isEqualToString:@"全部"])
    {
        sqlcode = "get_break_last_view_all_review";
    }
    else
    {
        string sRuleType = [SingletonBridge getBreakRuleTypeByName:bridge.nsRuleTypeForReviewBR];
        helpParam.add(sRuleType);
    }
    
    if (bridge.nsReviewStartTime == nil || bridge.nsReviewEndTime == nil)
    {
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *  endDate=[NSDate date];
        bridge.nsReviewEndTime=[dateformatter stringFromDate:endDate];
        
        NSDate* startDate = [[NSDate alloc] init];
        startDate = [endDate dateByAddingTimeInterval:-60*3600*24];
        bridge.nsReviewStartTime =[dateformatter stringFromDate:startDate];
    }
    
    string sStartTime, sEndTime;
    sStartTime = [bridge.nsReviewStartTime UTF8String];
    sEndTime = [bridge.nsReviewEndTime UTF8String];
    sEndTime += " 23:59:59";
    helpParam.add(sNodeId);
    helpParam.add(sStartTime);
    helpParam.add(sEndTime);
    strParam = helpParam.get();

    int iResult = _g_db->selectCmd("", sqlcode, strParam, help, strError);

    return iResult;
}

- (int)getReviewBreakRuleSingle:(CSelectHelp &)help error:(string &)strError
{
    string strParam="";
    string sqlcode="get_br_review";
    SelectHelpParam helpParam;
    
    string sId = [bridge.nsReviewBR_BreakRuleIdSelected UTF8String];
    
    int iResult = _g_db->selectCmd("", sqlcode, sId, help, strError);
    return iResult;
}

- (int)updateFlowNode:(string)sNodeId breakRuleId:(string)sBreakRuleId error:(string &)strError
{
    string strParam="";
    string sqlcode = "update_break_law_node";
    SelectHelpParam helpParamNode;
    helpParamNode.add(sNodeId);
    helpParamNode.add(sBreakRuleId);
    strParam = helpParamNode.get();
    
    CSelectHelp	help;
    int iResult = _g_db->execCmd("", sqlcode, strParam, help, strError);

    return iResult;

}

- (bool)putBRReview:(NSString *)nsContent grade:(string)sGrade nextNodeId:(string)sNextNodeId error:(string &)strError
{
    string strParam="";
    string sqlcode="put_br_review";
    
    string sReviewId = [self getId:SEQ_review_id];
    
    string sBreakRuleId = [bridge.nsReviewBR_BreakRuleIdSelected UTF8String];
    string sUserId = [bridge.nsUserId UTF8String];
    string sContent = [SingletonIce NSStringToGBstring:nsContent];
    string sRectifyId = "0";
    
    SelectHelpParam helpParam;
    helpParam.add(sReviewId);
    helpParam.add(sBreakRuleId);
    helpParam.add(sUserId);
    helpParam.add(sContent);
    helpParam.add(sGrade);
    helpParam.add(sRectifyId);
    strParam = helpParam.get();
    
    int iResult = 0;
    CSelectHelp	help;
    iResult = _g_db->execCmd("", sqlcode, strParam, help, strError);
    if( iResult<0 )
    {
        return false;
    }
    
    iResult = [self updateFlowNode:sNextNodeId breakRuleId:sBreakRuleId error:strError];
    if( iResult<0 )
    {
        return false;
    }
    return true;
}

- (int)getPreRectify:(CSelectHelp &)help error:(string &)strError
{
    string strParam="";
    string sqlcode="get_break_main_reform_notfull";
    SelectHelpParam helpParam;
    
    if ([bridge.nsRuleTypeForRectify isEqualToString:@"全部"])
    {
        sqlcode = "get_break_main_reform";
    }
    else
    {
        string sRuleType = [SingletonBridge getBreakRuleTypeByName:bridge.nsRuleTypeForRectify];
        helpParam.add(sRuleType);
    }
    
    if (bridge.nsRectifyStartTime == nil || bridge.nsRectifyEndTime == nil)
    {
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *  endDate=[NSDate date];
        bridge.nsRectifyEndTime=[dateformatter stringFromDate:endDate];
        
        NSDate* startDate = [[NSDate alloc] init];
        startDate = [endDate dateByAddingTimeInterval:-60*3600*24];
        bridge.nsRectifyStartTime =[dateformatter stringFromDate:startDate];
    }
    
    string sStartTime, sEndTime;
    sStartTime = [bridge.nsRectifyStartTime UTF8String];
    sEndTime = [bridge.nsRectifyEndTime UTF8String];
    sEndTime += " 23:59:59";
    
    helpParam.add(sStartTime);
    helpParam.add(sEndTime);
    strParam = helpParam.get();

    int iResult = _g_db->selectCmd("", sqlcode, strParam, help, strError);
    return iResult;
}

- (bool)putRectifyInfo:(NSString *)nsContent picName:(string)sPicName picInfo:(PHOTOINFO )stInfo error:(string &)strError
{
    string strParam="";
    string sqlcode="put_br_recify_info";
    
    string sRectifyId = [self getId:SEQ_rectify_id];
    if( sRectifyId == "" )
    {
        strError = "获取整改ID失败";
        return false;
    }
    
    string sOrgId = [bridge.nsOrgIdSelected UTF8String];
    string sUserId = [bridge.nsUserId UTF8String];
    string sBreakRuleId = [bridge.nsRectify_BreakRuleIdSelected UTF8String];
    string sRectifyContent = [SingletonIce NSStringToGBstring:nsContent];
    
    string sPicTime = stInfo.sTime;
    string sLongitude = stInfo.sLongitude;
    string sLatitude = stInfo.sLatitude;
    string sUpdateTime = [IosUtils getTime];
    
    SelectHelpParam helpParam;
    helpParam.add(sRectifyId);
    helpParam.add(sBreakRuleId);
    helpParam.add(sUserId);
    helpParam.add(sRectifyContent);
    helpParam.add(sPicName);
    helpParam.add(sPicTime);
    helpParam.add(sUpdateTime);
    helpParam.add(sLongitude);
    helpParam.add(sLatitude);
    strParam = helpParam.get();
    
    CSelectHelp	help;
    int iResult = _g_db->execCmd("", sqlcode, strParam, help, strError);
    if( iResult<0 )
    {
        return false;
    }
    
    string sNodeId;
    util::string_format(sNodeId, "%d", FLOW_NODE_RECTIFY_REVIEW_1);
    iResult = [self updateFlowNode:sNodeId breakRuleId:sBreakRuleId error:strError];
    if( iResult<0 )
    {
        return false;
    }
    
    return true;

}

- (int)getPreReviewRectify:(CSelectHelp &)help error:(string &)strError
{
    string strParam="";
    string sqlcode="get_break_last_view_reform";
    SelectHelpParam helpParam;
    
    string sNodeId = [self getNodeIdForReviewRectify];
    
    if ([bridge.nsRuleTypeForReviewRectify isEqualToString:@"全部"])
    {
        sqlcode = "get_break_last_view_all_reform";
    }
    else
    {
        string sRuleType = [SingletonBridge getBreakRuleTypeByName:bridge.nsRuleTypeForReviewRectify];
        helpParam.add(sRuleType);
    }
    
    if (bridge.nsReviewRectifyStartTime == nil || bridge.nsReviewRectifyEndTime == nil)
    {
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *  endDate=[NSDate date];
        bridge.nsReviewRectifyEndTime=[dateformatter stringFromDate:endDate];
        
        NSDate* startDate = [[NSDate alloc] init];
        startDate = [endDate dateByAddingTimeInterval:-60*3600*24];
        bridge.nsReviewRectifyStartTime =[dateformatter stringFromDate:startDate];
    }
    
    string sStartTime, sEndTime;
    sStartTime = [bridge.nsReviewRectifyStartTime UTF8String];
    sEndTime = [bridge.nsReviewRectifyEndTime UTF8String];
    sEndTime += " 23:59:59";
    
    helpParam.add(sNodeId);
    helpParam.add(sStartTime);
    helpParam.add(sEndTime);
    strParam = helpParam.get();
    
    int iResult = _g_db->selectCmd("", sqlcode, strParam, help, strError);

    return iResult;
}

- (int)getReviewRectifySingle:(CSelectHelp &)help error:(string &)strError
{
    string strParam="";
    string sqlcode="get_br_review_reform";
    SelectHelpParam helpParam;
    
    string sId = [bridge.nsReviewRectify_BreakRuleIdSelected UTF8String];
    
    int iResult;
    iResult = _g_db->selectCmd("", sqlcode, sId, help, strError);
    return iResult;
}

- (int)getRectifySingle:(CSelectHelp &)help breakRuleId:(NSString *)nsId error:(string &)strError
{
    string strParam="";
    string sqlcode="get_br_rectify_info";
    SelectHelpParam helpParam;
    
    string sId = [nsId UTF8String];
    
    int iResult;
    
    iResult = _g_db->selectCmd("", sqlcode, sId, help, strError);
    return iResult;
}

- (bool)putRectifyReview:(NSString *)nsContent grade:(string)sGrade nextNodeId:(string)sNextNodeId rectifyId:(string)sRectifyId error:(string &)strError
{
    string strParam="";
    string sqlcode="put_br_review";
    
    string sReviewId = [self getId:SEQ_review_id];
    
    string sBreakRuleId = [bridge.nsReviewRectify_BreakRuleIdSelected UTF8String];
    string sUserId = [bridge.nsUserId UTF8String];
    string sContent = [SingletonIce NSStringToGBstring:nsContent];
    
    SelectHelpParam helpParam;
    helpParam.add(sReviewId);
    helpParam.add(sBreakRuleId);
    helpParam.add(sUserId);
    helpParam.add(sContent);
    helpParam.add(sGrade);
    helpParam.add(sRectifyId);
    strParam = helpParam.get();
    
    int iResult = 0;
    CSelectHelp	help;
    iResult = _g_db->execCmd("", sqlcode, strParam, help, strError);
    if( iResult<0 )
    {
        return false;
    }
    
    iResult = [self updateFlowNode:sNextNodeId breakRuleId:sBreakRuleId error:strError];
    if( iResult<0 )
    {
        return false;
    }
    return true;
}
- (int)getAllBR:(CSelectHelp &)help error:(string &)strError
{
    string strParam="";
    string sqlcode="get_all_break_view";
    SelectHelpParam helpParam;
    
    if ([bridge.nsRuleTypeForQuery isEqualToString:@"全部"])
    {
        sqlcode = "get_all_break_view_all";
    }
    else
    {
        string sRuleType = [SingletonBridge getBreakRuleTypeByName:bridge.nsRuleTypeForQuery];
        helpParam.add(sRuleType);
    }
    
    if (bridge.nsQueryStartTime == nil || bridge.nsQueryEndTime == nil)
    {
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate *  endDate=[NSDate date];
        bridge.nsQueryEndTime=[dateformatter stringFromDate:endDate];
        
        NSDate* startDate = [[NSDate alloc] init];
        startDate = [endDate dateByAddingTimeInterval:-60*3600*24];
        bridge.nsQueryStartTime =[dateformatter stringFromDate:startDate];
    }
    
    string sStartTime, sEndTime;
    sStartTime = [bridge.nsQueryStartTime UTF8String];
    sEndTime = [bridge.nsQueryEndTime UTF8String];
    sEndTime += " 23:59:59";
    
    helpParam.add(sStartTime);
    helpParam.add(sEndTime);
    strParam = helpParam.get();

    int iResult = _g_db->selectCmd("", sqlcode, strParam, help, strError);
    return iResult;
}

@end