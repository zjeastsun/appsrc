#import <Foundation/Foundation.h>
#import"eutils.h"

#define BRIDGE SingletonBridge *bridge; bridge = [SingletonBridge sharedInstance];

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

@property (strong, nonatomic) NSString *nsBreakRuleIdSelected;//当前选中的违规信息id号

@property (strong, nonatomic) NSString *nsReviewState;//审核状态

+ (SingletonBridge *)sharedInstance;
- (void)unInit;

@end