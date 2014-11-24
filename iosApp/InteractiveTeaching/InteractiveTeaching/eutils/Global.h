//全局定义
//"Global.h"
#include <string>
using std::string;

//服务器相关--------------------------------------------------
const string CENT_ADDRESS = "www.myxui.com";//服务器地址
const int CENT_PORT = 8840;//iec服务器端口
const string REMOTE_PIC_PATH = "";//服务器保存照片的相对路径文件夹
const int CACHE_SIZE = 40960;//文件下载和上传每次上传数据包大小
const int RETRRY_TIMES = 3;//文件下载和上传重试次数

//本地数据库-------------------------------------------
#define LOCALDBNAME "break_law_init";//本地数据库文件名


//业务、流程定义----------------------------------------
const int FLOW_NODE_FINISH = 0;         // 流程结束
const int FLOW_NODE_BR_TAKEPHOTO = 1;   // 违规视频抓拍
const int FLOW_NODE_BR_REVIEW_1 = 2;    // 违规初级批阅
const int FLOW_NODE_BR_REVIEW_2 = 3;    // 违规中级批阅
const int FLOW_NODE_BR_REVIEW_3 = 4;    // 违规高级批阅
const int FLOW_NODE_BR_REVIEW_4 = 5;    // 违规最高级批阅

const int FLOW_NODE_RECTIFY_TAKEPHOTO = 6;// 整改视频抓拍
const int FLOW_NODE_RECTIFY_REVIEW_1 = 7; // 整改初级批阅
const int FLOW_NODE_RECTIFY_REVIEW_2 = 8; // 整改中级批阅
const int FLOW_NODE_RECTIFY_REVIEW_3 = 9; // 整改高级批阅
const int FLOW_NODE_RECTIFY_REVIEW_4 = 10;// 整改最高级批阅

//权限定义------------------------------------------------
const string RIGHT_BREAK_RULE = "1052";//违规抓拍权限
const string RIGHT_REVIEW_BREAK_RULE = "1063";//批阅违规权限
const string RIGHT_RECTIFY = "1057";//整改抓拍权限
const string RIGHT_REVIEW_RECTIFY = "1065";//批阅整改权限
const string RIGHT_QUERY = "1044";//查询权限

const string RIGHT_BR_REVIEW_1 = "1147";//违规初级批阅权限
const string RIGHT_BR_REVIEW_2 = "1148";//违规中级批阅权限
const string RIGHT_BR_REVIEW_3 = "1149";//违规高级批阅权限
const string RIGHT_BR_REVIEW_4 = "1150";//违规最高级批阅权限

const string RIGHT_RECTIFY_REVIEW_1 = "1147";//整改初级批阅权限
const string RIGHT_RECTIFY_REVIEW_2 = "1148";//整改中级批阅权限
const string RIGHT_RECTIFY_REVIEW_3 = "1149";//整改高级批阅权限
const string RIGHT_RECTIFY_REVIEW_4 = "1150";//整改最高级批阅权限

// SEQUENCE值-------------------------------------
const string SEQ_break_rule_id = "break_rule_id";
const string SEQ_rectify_id = "rectify_id";
const string SEQ_review_id = "review_id";
const string SEQ_pic_id = "pic_id";

const int REVIEW_PASS = 0;// 审核通过
const int REVIEW_NOT_NEED_RECTIFY = 1;// 无需整改
const int REVIEW_CANNOT_JUDGE = 2;// 无法判定
const int REVIEW_NO_PASS = 3;// 审核不通过

typedef struct tagPHOTOINFO
{
	string sTime;
    string sLatitude;
    string sLongitude;
    
} PHOTOINFO;

//摄像头相片拍摄像素
const int PHOTO_WIDTH = 800;
const int PHOTO_HEIGHT = 600;

//ios定义---------------------------------------------------------------------
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