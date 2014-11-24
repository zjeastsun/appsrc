//ice访问单例

#import <Foundation/Foundation.h>
#import"Eutils.h"
#import "SingletonBridge.h"

#define ONEICE SingletonIce *oneIce; oneIce = [SingletonIce sharedInstance];

@interface SingletonIce : NSObject
{
    SingletonBridge *bridge;
}

@property (nonatomic) CICEDBUtil *g_db;

+ (SingletonIce *)sharedInstance;
- (void)unInit;

#pragma mark -
#pragma mark 字符串转换

/**从help中获取本地可使用字串，GB_18030_2000－>utf8*/
+ (NSString *)valueNSString:(CSelectHelp)help rowForHelp:(NSInteger)row KeyForHelp:(std::string)key;
/**utf8->GB_18030_2000string*/
+ (string)NSStringToGBstring:(NSString *)nsString;

#pragma mark -
#pragma mark 文件处理

/**获取temp目录全路径文件名*/
+ (NSString *)getFullTempPathName:(NSString *)nsFileName;
/**判断temp目录是否存在文件*/
+ (bool)fileExistsInTemp:(NSString *)nsFileName;

/**从服务器下载文件*/
- (bool)downloadFile:(NSString *)nsFileName Callback:(ProgressFileCallback)pF DoneCallback:(ProgressFileDoneCallback)pFinished setBreakSignal:(setBreakTransmitSignalCallback)pSignal;

#pragma mark -
#pragma mark 数据库查询函数

//数据库查询函数---------------------------------------------------
/**登录检查*/
- (bool)loginCheck:(NSString *)nsUser passWord:(NSString *)nsPwd error:(string &)strError;
/**获取用户信息*/
- (bool)getUserInfo:(CSelectHelp &)help user:(NSString *)nsUser error:(string &)strError;
/**获取用户权限*/
- (bool)getRight:(CSelectHelp &)help user:(NSString *)nsUser error:(string &)strError;
/**获取项目信息*/
- (int)getProject:(CSelectHelp &)help user:(NSString *)nsUser error:(string &)strError;
/**获取唯一id号，用于违规ID、整改id、批阅id、照片名称的获取*/
- (string)getId:(string)sIdSeq;
/**增加违规抓拍信息*/
- (bool)putBreakRuleInfo:(NSString *)nsContent picName:(string)sPicName picInfo:(PHOTOINFO )stInfo error:(string &)strError;
/**获取待批阅违规信息列表*/
- (int)getPreReviewBreakRule:(CSelectHelp &)help error:(string &)strError;
/**获取单条违规批阅信息*/
- (int)getReviewBreakRuleSingle:(CSelectHelp &)help error:(string &)strError;
/**增加批阅违规*/
- (bool)putBRReview:(NSString *)nsContent grade:(string)sGrade nextNodeId:(string)sNextNodeId error:(string &)strError;
/**更新违规表中的流程id*/
- (int)updateFlowNode:(string)sNodeId breakRuleId:(string)sBreakRuleId error:(string &)strError;
/**获取待整改抓拍信息列表*/
- (int)getPreRectify:(CSelectHelp &)help error:(string &)strError;
/**增加整改抓拍信息*/
- (bool)putRectifyInfo:(NSString *)nsContent picName:(string)sPicName picInfo:(PHOTOINFO )stInfo error:(string &)strError;
/**获取待批阅整改信息列表*/
- (int)getPreReviewRectify:(CSelectHelp &)help error:(string &)strError;
/**获取单条整改批阅信息*/
- (int)getReviewRectifySingle:(CSelectHelp &)help error:(string &)strError;
/**获取单条整改信息*/
- (int)getRectifySingle:(CSelectHelp &)help breakRuleId:(NSString *)nsId error:(string &)strError;
/**增加批阅整改*/
- (bool)putRectifyReview:(NSString *)nsContent grade:(string)sGrade nextNodeId:(string)sNextNodeId rectifyId:(string)sRectifyId error:(string &)strError;
/**获取综合查询列表*/
- (int)getAllBR:(CSelectHelp &)help error:(string &)strError;
@end