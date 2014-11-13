//全局共享数据单例
//包含部分重复使用的函数
//部分全局定义

#import <Foundation/Foundation.h>
#import"eutils.h"
#import"Global.h"

#define BRIDGE SingletonBridge *bridge; bridge = [SingletonBridge sharedInstance];

@interface SingletonBridge: NSObject

@property (strong, nonatomic) NSString *nsUserId;
@property (strong, nonatomic) NSString *nsLoginName;

@property (strong, nonatomic) NSString *nsOrgId;//用户所在部门id
@property (strong, nonatomic) NSString *nsOrgIdSelected;//当前选择的项目id
@property (strong, nonatomic) NSString *nsOrgNameSelected;//当前选择的项目名称

//权限信息------------------------------------------------------------------------------
@property (nonatomic) CSelectHelp helpRight;

//违规抓拍--------------------------------------------------------------------------------
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

//谁在使用选择页--------------------------------------------------------------------------------
@property (strong, nonatomic) NSString *nsWhoUseRuleTypeViewController;//谁在使用判定性质选择页
@property (strong, nonatomic) NSString *nsWhoUseReviewStateViewController;//谁在使用审核状态选择页
@property (strong, nonatomic) NSString *nsWhoUseConditionViewController;//谁在使用条件选择页

//批阅违规信息--------------------------------------------------------------------------
//当前选中的批阅违规信息
@property (strong, nonatomic) NSString *nsReviewBR_BreakRuleIdSelected;//id号
@property (strong, nonatomic) NSString *nsReviewBR_OrgNameSelected;
@property (strong, nonatomic) NSString *nsReviewBR_BreakRuleTypeSelected;
@property (strong, nonatomic) NSString *nsReviewBR_TimeSelected;
@property (strong, nonatomic) NSString *nsReviewBR_BreakRuleContentSelected;
@property (strong, nonatomic) NSString *nsReviewBR_CurFlowNodeIdSelected;
@property (strong, nonatomic) NSString *nsReviewBR_PicNameSelected;
//条件
@property (strong, nonatomic) NSString *nsReviewStateBR;//审核状态
//查询条件
@property (strong, nonatomic) NSString *nsRuleTypeForReviewBR;//条件选择中的判定性质
@property (strong, nonatomic) NSString *nsReviewStartTime;//批阅违规查询时间
@property (strong, nonatomic) NSString *nsReviewEndTime;

//待整改拍照信息-------------------------------------------------------------------------
//当前选中的待整改拍照信息
@property (strong, nonatomic) NSString *nsRectify_BreakRuleIdSelected;//id号
@property (strong, nonatomic) NSString *nsRectify_OrgNameSelected;
@property (strong, nonatomic) NSString *nsRectify_BreakRuleTypeSelected;
@property (strong, nonatomic) NSString *nsRectify_TimeSelected;
@property (strong, nonatomic) NSString *nsRectify_BreakRuleContentSelected;
@property (strong, nonatomic) NSString *nsRectify_PicNameSelected;
//查询条件
@property (strong, nonatomic) NSString *nsRuleTypeForRectify;//条件选择中的判定性质
@property (strong, nonatomic) NSString *nsRectifyStartTime;//待整改拍照查询时间
@property (strong, nonatomic) NSString *nsRectifyEndTime;

//批阅整改信息--------------------------------------------------------------------------
//当前选中的批阅整改信息
@property (strong, nonatomic) NSString *nsReviewRectify_BreakRuleIdSelected;//id号
@property (strong, nonatomic) NSString *nsReviewRectify_OrgNameSelected;
@property (strong, nonatomic) NSString *nsReviewRectify_BreakRuleTypeSelected;
@property (strong, nonatomic) NSString *nsReviewRectify_TimeSelected;
@property (strong, nonatomic) NSString *nsReviewRectify_BreakRuleContentSelected;
@property (strong, nonatomic) NSString *nsReviewRectify_CurFlowNodeIdSelected;
@property (strong, nonatomic) NSString *nsReviewRectify_PicNameSelected;
//条件
@property (strong, nonatomic) NSString *nsReviewStateRectify;//审核状态
//查询条件
@property (strong, nonatomic) NSString *nsRuleTypeForReviewRectify;//条件选择中的判定性质
@property (strong, nonatomic) NSString *nsReviewRectifyStartTime;//查询时间
@property (strong, nonatomic) NSString *nsReviewRectifyEndTime;

//综合查询--------------------------------------------------------------------------
//当前选中信息
@property (strong, nonatomic) NSString *nsQuery_BreakRuleIdSelected;//id号
@property (strong, nonatomic) NSString *nsQuery_OrgNameSelected;
@property (strong, nonatomic) NSString *nsQuery_BreakRuleTypeSelected;
@property (strong, nonatomic) NSString *nsQuery_TimeSelected;
@property (strong, nonatomic) NSString *nsQuery_BreakRuleContentSelected;
@property (strong, nonatomic) NSString *nsQuery_CurFlowNodeIdSelected;
@property (strong, nonatomic) NSString *nsQuery_CurFlowNodeNameSelected;
@property (strong, nonatomic) NSString *nsQuery_PicNameSelected;

//查询条件
@property (strong, nonatomic) NSString *nsRuleTypeForQuery;//条件选择中的判定性质
@property (strong, nonatomic) NSString *nsQueryStartTime;//查询时间
@property (strong, nonatomic) NSString *nsQueryEndTime;

//---------------------------------------------------------------------------------------------
+ (SingletonBridge *)sharedInstance;
- (void)unInit;

/**批阅类型互查*/
+ (NSString *)getReviewTypeName:(int)iType;
+ (int)getReviewTypeId:(NSString *)nsName;

/**违规类型互查*/
+ (string)getBreakRuleTypeByName:(NSString *)name;
+(NSString *)getBreakRuleTypeNameById:(NSString *)nsId;

/**是否有权限*/
- (bool)hasRight:(string)sRightId;





@end