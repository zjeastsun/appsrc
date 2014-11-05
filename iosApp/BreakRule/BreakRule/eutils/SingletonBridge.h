//全局共享数据单例
#import <Foundation/Foundation.h>
#import"eutils.h"

#define BRIDGE SingletonBridge *bridge; bridge = [SingletonBridge sharedInstance];

//-----------------------------------------------------------
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

// SEQUENCE值
const string SEQ_break_rule_id = "break_rule_id";
const string SEQ_rectify_id = "rectify_id";
const string SEQ_review_id = "review_id";
const string SEQ_pic_id = "pic_id";
//---------------------------------------------------------------------
// 视图上移/下移动画名称
#define kAnimationResizeForKeyboard @"ResizeForKeyboard"
// 键盘展开/收起动画时间
#define kAnimationDuration          0.3
// 主屏幕Bounds
#define kBoundsOfMainScreen         [[UIScreen mainScreen] bounds]
// 主屏幕Size
#define kSizeOfMainScreen           [[UIScreen mainScreen] bounds].size
// 主屏幕宽度
#define kWidthOfMainScreen          [[UIScreen mainScreen] bounds].size.width
// 主屏幕高度
#define kHeightOfMainScreen         [[UIScreen mainScreen] bounds].size.height
// TextView控件之间的垂直间距
#define kTextViewPadding           10

//------------------------------------------------------------------------

@interface SingletonBridge: NSObject

@property (strong, nonatomic) NSString *nsUserId;
@property (strong, nonatomic) NSString *nsLoginName;

@property (strong, nonatomic) NSString *nsOrgId;
@property (strong, nonatomic) NSString *nsOrgIdSelected;
@property (strong, nonatomic) NSString *nsOrgNameSelected;

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
@property (strong, nonatomic) NSString *nsQuery_PicNameSelected;

//查询条件
@property (strong, nonatomic) NSString *nsRuleTypeForQuery;//条件选择中的判定性质
@property (strong, nonatomic) NSString *nsQueryStartTime;//查询时间
@property (strong, nonatomic) NSString *nsQueryEndTime;

//---------------------------------------------------------------------------------------------
+ (SingletonBridge *)sharedInstance;
- (void)unInit;

+ (NSString *)getReviewTypeName:(int)iType;
+ (int)getReviewTypeId:(NSString *)nsName;
+ (string)getBreakRuleTypeByName:(NSString *)name;

+ (void)MessageBox:(NSString *)msg;
+ (void)MessageBox:(string)msgs withTitle:(string)sTitle;



@end