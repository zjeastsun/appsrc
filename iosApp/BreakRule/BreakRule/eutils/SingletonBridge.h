//全局共享数据单例
#import <Foundation/Foundation.h>
#import"eutils.h"

#define BRIDGE SingletonBridge *bridge; bridge = [SingletonBridge sharedInstance];

/////////////////////////////////////////////////////////////
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

const int REVIEW_PASS = 0;// 审核通过
const int REVIEW_NOT_NEED_RECTIFY = 1;// 无需整改
const int REVIEW_CANNOT_JUDGE = 2;// 无法判定
const int REVIEW_NO_PASS = 3;// 审核不通过

//////////////////////////////////////////////////////////////

@interface SingletonBridge: NSObject

@property (strong, nonatomic) NSString *nsUserId;
@property (strong, nonatomic) NSString *nsLoginName;

@property (strong, nonatomic) NSString *nsOrgId;
@property (strong, nonatomic) NSString *nsOrgIdSelected;
@property (strong, nonatomic) NSString *nsOrgNameSelected;

@property (nonatomic) CSelectHelp helpRight;

@property (strong, nonatomic) NSString *nsRuleType;
@property (strong, nonatomic) NSString *nsRuleOption;
@property (strong, nonatomic) NSString *nsContent;//违规内容、整改内容、批阅内容等

@property (strong, nonatomic) NSString *nsSafetySubItemId;//安全分项
@property (strong, nonatomic) NSString *nsSafetySubItemName;

@property (strong, nonatomic) NSString *nsProjectType;
@property (strong, nonatomic) NSString *nsProjectTypeName;

@property (strong, nonatomic) NSString *nsCheckItemId;
@property (strong, nonatomic) NSString *nsCheckItemName;

@property (strong, nonatomic) NSString *nsHazardTypeId;
@property (strong, nonatomic) NSString *nsHazardTypeName;

@property (strong, nonatomic) NSString *nsReviewStartTime;//批阅违规查询时间
@property (strong, nonatomic) NSString *nsReviewEndTime;

@property (strong, nonatomic) NSString *nsRuleTypeForCondition;//条件选择中的判定性质

@property (strong, nonatomic) NSString *nsWhoUseRuleTypeViewController;//谁在使用判定性质选择页
@property (strong, nonatomic) NSString *nsWhoUseReviewStateViewController;//谁在使用审核状态选择页

//当前选中的违规信息
@property (strong, nonatomic) NSString *nsReviewBR_BreakRuleIdSelected;//id号
@property (strong, nonatomic) NSString *nsReviewBR_OrgNameSelected;
@property (strong, nonatomic) NSString *nsReviewBR_BreakRuleTypeSelected;
@property (strong, nonatomic) NSString *nsReviewBR_TimeSelected;
@property (strong, nonatomic) NSString *nsReviewBR_BreakRuleContentSelected;
@property (strong, nonatomic) NSString *nsReviewBR_CurFlowNodeIdSelected;
@property (strong, nonatomic) NSString *nsReviewBR_PicNameSelected;


@property (strong, nonatomic) NSString *nsReviewState;//审核状态

+ (SingletonBridge *)sharedInstance;
- (void)unInit;

+ (NSString *)getReviewTypeName:(int)iType;
+ (int)getReviewTypeId:(NSString *)nsName;

@end