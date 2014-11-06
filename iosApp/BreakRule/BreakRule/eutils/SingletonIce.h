//ice访问单例
#import <Foundation/Foundation.h>
#import"Eutils.h"
#import "SingletonBridge.h"

#define ONEICE SingletonIce *oneIce; oneIce = [SingletonIce sharedInstance];

const string REMOTE_PIC_PATH = "";//服务器保存照片的相对路径文件夹
const int CENT_PORT = 8840;//iec服务器端口

//流程定义-----------------------------------------------------------
const int FLOW_NODE_FINISH = 0;// 流程结束
const int FLOW_NODE_BR_TAKEPHOTO = 1;// 违规视频抓拍
const int FLOW_NODE_BR_REVIEW_1 = 2;// 违规初级批阅
const int FLOW_NODE_BR_REVIEW_2 = 3;// 违规中级批阅
const int FLOW_NODE_BR_REVIEW_3 = 4;// 违规高级批阅
const int FLOW_NODE_BR_REVIEW_4 = 5;// 违规最高级批阅

const int FLOW_NODE_RECTIFY_TAKEPHOTO = 6;// 整改视频抓拍
const int FLOW_NODE_RECTIFY_REVIEW_1 = 7;// 整改初级批阅
const int FLOW_NODE_RECTIFY_REVIEW_2 = 8;// 整改中级批阅
const int FLOW_NODE_RECTIFY_REVIEW_3 = 9;// 整改高级批阅
const int FLOW_NODE_RECTIFY_REVIEW_4 = 10;// 整改最高级批阅

// SEQUENCE值
const string SEQ_break_rule_id = "break_rule_id";
const string SEQ_rectify_id = "rectify_id";
const string SEQ_review_id = "review_id";
const string SEQ_pic_id = "pic_id";

@interface SingletonIce : NSObject

@property (nonatomic) CICEDBUtil *g_db;

+ (SingletonIce *)sharedInstance;
- (void)unInit;

/**从help中获取本地可使用字串，GB_18030_2000－>utf8*/
+ (NSString *)valueNSString:(CSelectHelp)help rowForHelp:(NSInteger)row KeyForHelp:(std::string)key;
/**utf8->GB_18030_2000string*/
+ (string)NSStringToGBstring:(NSString *)nsString;

/**获取temp目录全路径文件名*/
+ (NSString *)getFullTempPathName:(NSString *)nsFileName;
/**判断temp目录是否存在文件*/
+ (bool)fileExistsInTemp:(NSString *)nsFileName;

/**从服务器下载文件*/
- (bool)downloadFile:(NSString *)nsFileName Callback:(ProgressFileCallback)pF DoneCallback:(ProgressFileDoneCallback)pFinished;

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
- (bool)putBreakRuleInfo:(NSString *)nsContent picName:(string)sPicName picTime:(NSString *)nsPicTime error:(string &)strError;
/**获取待批阅违规信息列表*/
- (int)getReviewBreakRule:(CSelectHelp &)help error:(string &)strError;
/**获取单条违规信息*/
- (int)getBreakRule:(CSelectHelp &)help error:(string &)strError;
/**增加批阅违规*/
- (bool)putBRReview:(NSString *)nsContent grade:(string)sGrade nextNodeId:(string)sNextNodeId error:(string &)strError;
/**更新违规表中的流程id*/
- (int)updateFlowNode:(string)sNodeId breakRuleId:(string)sBreakRuleId error:(string &)strError;
/**获取待整改抓拍信息列表*/
- (int)getRectify:(CSelectHelp &)help error:(string &)strError;
/**增加整改抓拍信息*/
- (bool)putRectifyInfo:(NSString *)nsContent picName:(string)sPicName picTime:(NSString *)nsPicTime error:(string &)strError;

@end