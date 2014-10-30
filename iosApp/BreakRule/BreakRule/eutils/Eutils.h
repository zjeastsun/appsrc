/* 项目名称
 *             __  __    _    ____
 *             |  \/  |  / \  / ___|  ___ _ ____   _____ _ __
 *             | |\/| | / _ \ \___ \ / _ \ '__\ \ / / _ \ '__|
 *             | |  | |/ ___ \ ___) |  __/ |   \ V /  __/ |
 *             |_|  |_/_/   \_\____/ \___|_|    \_/ \___|_|
 *
 *
 * Copyright (C) 2007 - 2009, 谷伟年 [Eric Goo] , <guwncn@gmail.com>.
 * 文件修改记录:
 *          2010-01-05 新建   重构了之前的eutils.h交其全部转化为头文件
 *		   2010-01-06 增加连接池功能
 *		   2010-01-11 将数据库CDBUtil也转移至头文件，同时将程序中的CICEDBUtil转为DLL实现，方便客户端调用
 *		   2010-01-20 增加了类sort方法,主要用于排序CSelectHelp,可以按指定的列来排序，增加了lookup方法查找子集
 如果记录集较大又有唯一主键，先通过CSortHelp::sort()排序，然后lookup会使用二分查找
 *		   2010-01-20 CSelectHelp增加了别名功能 addField(field,alias),getAlias
 *		   2010-01-20 增加了ODBC创建工具，位于CSystemUtil工具类中
 *          2010-01-23 增加了CZipUtil 可以用于系统的压缩和解压缩
 *		   2010-01-30 增加CSQLiteUtil 用于本地配置数据库
 *		   2010-07-20 增加用户会话管理功能，可以限制用户连接服务器的数量
 
 配置说明:
 本文件主要用于ICE远程数据库访问，同时支持一些辅助的功能主要类为:
 1.CSystemUtil 系统常用工具类
 2.CMD5      MD5
 3.CERegex   正则表达式
 4.CChineseCodeLib Uncode,UTF-8,GB2312相互之间的转化[仅适用于Windows平台]
 5.CConfigMgr 配置文件读取类，支持保存功能
 6.CArgvParse 命令行参数分析类
 7.CSelectHelp 数据库表的结果集合，类似于RecordSet
 8.CWindowsService Windows上服务访问与控制类[权适用于Windows平台]
 9.CSQLBuilder,CSQLBuilderV,CSQLBuilderProc 数据库脚本封装类
 10.CICEDBUtil  ICE的远程数据库访问类
 11.CHttpUtil   用户访问远程的http类
 12.CDiskObject 用于文件Copy,Delete,查询目录等功能
 13.CZipUtil   用于Zip的文件压缩和解压缩
 14.CSQLiteUtil 用于访问SQLite数据库的实用类,无需dll支持
 14.CEUtilsTest 是一个工具集的测试类
 
 #define USE_ICE   //代表使用ICE类库,会Line ICE相关类库
 ***************************************************************************/
//#import <UIKit/UIKit.h>

#include <vector>
#include <string>

#define USE_ICE

using std::string;
using std::vector;
//extern string getID();

#ifndef byte
typedef unsigned char byte;
#endif

//定义Unix与Windows的port
#if defined(PLATFORM_WINDOWS)
#define gstrnicmp	_strnicmp
#define gstricmp_gu	_stricmp
#else
#define gstrnicmp	strncasecmp
#define gstricmp_gu	strcasecmp
#define _vsnprintf  vsnprintf
#endif

//常量定义区
const char* const CONST_EUTILS_VERSION = "1.1";
//字段间的分隔符
const char  CONST_SEP_FIELD[] = {0x01,'\0'};
//行间的分隔符
const char  CONST_SEP_LINE[] = {0x02,'\0'};
//行行分隔符
const char  CONST_SEP_LINE_LINE[] = {0x03,'\0'};

const char  CONST_FULL_SRING[] = "-------";

//类型定义区
enum __LogType
{
    LOG_NULL,
    LOG_CONSOLE,
    LOG_FILE,
    LOG_DB,
    LOG_FULL
};
enum __LogLevel
{
    LOG_LEVEL_FULL=0,
    LOG_LEVEL_DEBUG=1,
    LOG_LEVEL_INFO=2,
    LOG_LEVEL_WARN=3,
    LOG_LEVEL_ERROR=4
};

enum COMM_IF_TYPE   //通信服务接口类型
{
	COMM_IF_addOrder = 0,
	COMM_IF_updateOrder,
	COMM_IF_sendAttemperNotice,
	COMM_IF_SendSynCmd,
	COMM_IF_sendEvent,
	COMM_IF_setTerminal,
	COMM_IF_getTerminalSetting,
	COMM_IF_UpgradeTerminal,
	COMM_IF_UpgradeQuery,
	COMM_IF_QueryPortState,
	COMM_IF_QueryLogState,
	COMM_IF_SetLogState
};

typedef enum __LogLevel LogLevel;
typedef enum __LogType  LogType;

class  CEDateTime
{
public:
    CEDateTime();
    void reset();
    void dump();
    
    int	m_iYear;
    int m_iMonth;
    int m_iDay;
    int m_iHour;
    int m_iMinute;
    int m_iSecond;
    int m_iMicroSecond;
};



//!  CSystemUtil 类，通用工具类.
/*!
 包括大部分经常用到的工具集，例如获取可执行文件路径、系统时间等等
 */
class  CSystemUtil
{
public:
    CSystemUtil();
    
//    static int CodeChange( char *p_inBuf, char *p_OutBuf, int *p_OutSize, const char  *p_inCode, const char *p_OutCode);
    static string getID();
    
    static void setLogType( LogType type);
    static void setLogLevel( LogLevel lvl);
    
	//小数转字符串
	static string& toString(string& out,double fv);
	static string& toString(string& out,int fv);
    
	static int encodeBase64(const unsigned char* pSrc, char* pDst, int nSrcLen, int nMaxLineLen=8000);
	static int decodeBase64(const char* pSrc, unsigned char* pDst, int nSrcLen);
    
	/** 注意是专用版本，有字符串替换,非请务用 */
	static std::string toBase64(const std::string &sql,int type=0);
	static std::string fromBase64(const std::string &sql,int type=0); //如果为0代表需要替换=
    
    /*!去掉右边的指定字符*/
    static  std::string& trim_right (std::string & s, const std::string & t=" \t");
    /*!去掉左边的指定字符*/
    static std::string& trim_left (std::string & s, const std::string & t=" \t") ;
    /*!去掉两边的指定字符*/
    static  std::string& trim (std::string & s, const std::string & t=" \t");
    
    /*! newvalue替换字符串中所有old_value的值 */
    static std::string&  replace_all(std::string&   str,
                                     const std::string&   old_value,const   std::string&   new_value)   ;
    
    /** 字符串分隔*/
    static int   splitString(
                             const std::string& src,
                             std::vector<std::string>& vs,
                             const std::string tok=" ,\t\n",
                             bool trim=false,
                             std::string null_subst="");
    
    
	//一次性写入大文件
	static int write2File(void* pValues,int iSize,const string& sFile);
    
    
    /*!返回指定长度的随机字符串*/
    static std::string& getRandString(int len,std::string& out);
    static std::string&	getRandID(std::string& out);
	static std::string& getFillString(const string& src,unsigned int iLen,std::string& sDest,bool bRight=true,char cFill=' ');
    
    
	static std::string& getFileName(const string& sInPath,string& sFile);
	static std::string& getFilePath(const string& sFile,string& sOutPath);
    
    
    /*! 输助输出vector<string> */
    static void dumpVectorString(std::vector<std::string> & v);
    static std::string& string_format(std::string& str, const char * sFormat, ...);
    /** 去掉字符串开始与结束的特定字符
     *  @param[in] 输入源char*字符串
     *  @param[in] 去掉的字符,如'|',默认为' '
     *  @return 没有返回值
     */
    static void allTrim(char *src,char sep=' ');
    
    /** 去掉字符串开始与结束的特定字符
     *  @param[in] 输入string源字符串
     *  @param[in] 去掉的字符,如'|'默认为' '
     *  @return 没有返回值
     */
    static char* upper(char *src);
    static std::string& upper(std::string& src);
    
    /** 字符串转成小写
     *  @param[in] char 输入字符串
     *  @param[out] buffer 用于存放读取的文件内容
     *  @param[in] len 需要读取的文件长度
     *  @return 返回传入的字符串地址
     */
    static char* lower(char *src);
    static std::string& lower(std::string& src);
    
    
    static std::string& left(const std::string& str,int size,string& out);
    static std::string& right(const std::string& str,int size,string& out);
    
	/** 判断是否是整数 */
	static	bool isNumeric(const string string);
    
	/** 判断是否是IP地址 */
	static bool isIp(const char* ip);
    
    
    /*从路径中获取文件名*/
    static std::string& getFileNameFromDir(const std::string& dir,
                                           std::string& file);
    
    
	///*从文件名中获取路经*/
	//static std::string& getPathFromFile(const std::string& sFile,
	//	std::string& sPath);
    
    
    /** 系统时间获取
     *  @return 格式形如"2006-09-10 12:12:21" 字符串
     */
    static std::string& getSys14Time(std::string& out);
    
    /** 系统时间获取
     *  @return 格式形如"20060910121221" 字符串
     */
    static std::string& getSys14Time2(std::string& out);
    /** 系统时间获取
     *  @return 格式形如"2006-09-10" 字符串
     */
    static std::string& getSys8Time(std::string& out);
    
    /** 将字符串分解成整数
     *  格式形如"20060910121221 或 2006-09-10 12:12:21 " 字符串
     */
    static bool parseDate(char *sTime,CEDateTime &dt);
    static bool parseDate(char *sTime,int &year,int &month,int &day,int &hour,int &minute,int &second);
    
    /** 从源字符串src中取指定长度的字符串，如果src不够长使用spec进行填充
     *  @param[in]  	得到0代表可执行文件的路径,1代表含exe文件的路径,2代表只返回可执行文件名,3代表如test.exe中的test
     *  @return string字符对象
     */
    
    static std::string& getExePath(std::string& out,int type=0,char const *argv0="testname");
    static char *dirname(char *buf, char *name, int bufsize);
    /** 读取指定的文件一行文本
     *  @param[in]  	文件名柄FILE*
     *  @param[out]  	返回的字符串
     *  @param[in]  	每行最大字符数量
     *  @return 返回当前读的字符数
     */
    static int  fgetline(FILE *fp, char *buffer, int maxlen=8000);
    
    
    /** 读取指定的文件所有文本内容至字符串中
     *  @param[in]  	文件名*
     *  @return 返回字符串
     */
    static std::string&  readFileAsString(char *file,std::string& out,int maxLine=8000);
    /** 获取文件大小 */
    static int	fileSize(char* file);
    
    /** 文件是否存在 */
    static bool isFileExist(char* file);
    
    /** 是否是闰年*/
    static bool  isLeapYear(int   iYear);
    
    /** 取得某个月份的天数。*/
    static int   daysPerMonth(int  iYear,int  iMonth);
    
    /*按当前时间下idx个月，如果idx>0则代表后idx月,以后建议统一使用下列两个函数*/
    static void nextMonth(int year,int month,int idx,int &yearOut,int &monthOut);
    /*按当前时间下idx个日，如果idx>0则代表后idx日 */
    static bool nextDay(int year,int month,int day,int idx,int &yearOut,int &monthOut,int &dayOut);
    
    /*按当前时间下idx个小时，如果idx>0则代表后idx小时 */
    static bool nextHour(int year,int month,int day,int hour,
                         int &yearOut,int &monthOut,int &dayOut,int &hourOut);
    
    /** Log 辅助功能,通过默认文件
     *  @param[in]  	文件名柄(FILE*)
     *  @param[in]  	格式串
     *  @param[in]  	...
     *  @return 没有返回值
     */
    static void writelog(const char* msg,...);
    
    
    //系统等待指定毫秒
    static void Sleep(int millSec);
    
#ifdef PLATFORM_WINDOWS
    
    
    static bool CheckDSN(const std::string& strDBName);
    
    static int GetDSN(std::vector<std::string> &vs);
    
    static void RemoveMdbDsn(const std::string& sDB);
    static void RemoveDSN(const string& sDB,const string& sDriver="");
    
    static bool CreateMdbDsn(const string& sDSN,const string& sPath,const string& sDesc);
    static bool CreateSQLServerDsn(const string& sDSN,const string& sDesc,const string& sIP,const string& sDB);
    static bool CreateOracleDsn(const string& sDSN,const string& sDesc,
                                const string& sIP,const string& user,const string& pass);
    
    static bool CheckExistODBCDriver(const char* driver);
    static int GetODBCDrivers(std::vector<std::string> &vs);
    
    
    static void unicode2Ansi(WCHAR* lpString,char *szAnsi);
    static void ansi2Unicode(LPCSTR lpString,WCHAR * lpUni);
    static void preDay(int offset,int &yearOut,int &month,int &day);
#endif
    
private:
    /** 这一些函数将来将不使用*/
    
    static bool nextDay(int year,int month,int day,
                        int &yearOut,int &monthOut,int &dayOut);
    static void nextMonth(int year,int month,int &yearOut,int &monthOut);
    static void preMonth(int year,int month,int &yearOut,int &monthOut);
    static void preDay(int year,int month,int day,int &yearOut,int &monthOut,int &dayOut);
	/** 内部判断使用 */
	static	bool isNatural(const string str);
    
    
};


typedef  CSystemUtil util;
#define wlog  CSystemUtil::writelog

//!  CMD5类，用于MD5加密算法的实现.
/*!
 
 */

#ifndef uint8
#define uint8  unsigned char
#endif

#ifndef uint32
#define uint32 unsigned long int
#endif

typedef struct
{
    uint32 total[2];
    uint32 state[4];
    uint8 buffer[64];
}
md5_context;


class  CMD5 {
protected:
    char m_szMD5[33];
public:
    CMD5();
    CMD5(std::string& sText);
    CMD5(const char* sText);
    CMD5(const char* szText, uint32 nTextLen);
    virtual ~CMD5();
    operator std::string() const;
    
    operator char*() const;
    char*	get();
    char* MakeHash(const char* szText, uint32 nTextLen);
    
protected:
    void md5_starts( md5_context *ctx ) const;
    void md5_update( md5_context *ctx, uint8 *input, uint32 length ) const;
    void md5_finish( md5_context *ctx, uint8 digest[16] ) const;
    
private:
    void md5_process( md5_context *ctx, uint8 data[64] ) const;
};


/** 表行定义结构,用于存储表中的一行数据 */

typedef std::vector<std::string> table_line;

//!  CSelectHelp 用于查询数据库时，返回的数据集合辅助类.
/*!
 采用标准C++ string做为存储工具，信息内容全部被转化为字符串存储
 CSelectHelp 主要是一个表的数据集对象，当然也可以存储有key,value类似特性的对象
 为了使用方便，这个类不是DLL类
 */

class  CSelectHelp
{
public:
    
    int size()
    {
        return _count;
    }
    /* 从CSelectHelp copy */
    
    
    //生成调试数据，仅仅用于调试
    void GenDebugData()
    {
        reset();
        addField("name","运营商");
        addField("age","年纪");
        addField("use_id","编号");
        
        table_line line;
        line.push_back("中国电信");
        line.push_back("10");
        line.push_back("10000");
        addValue(line);
        line.clear();
        
        line.push_back("中国移动");
        line.push_back("12");
        line.push_back("10086");
        addValue(line);
        line.clear();
        
        line.push_back("中国联通");
        line.push_back("11");
        line.push_back("9090");
        addValue(line);
        line.clear();
        
    }
	void  unionHelp(CSelectHelp& s)
	{
		if ( s._fields.size() != this->_fields.size() )
		{
            
            unsigned int i;
			this->_fields.clear();
			this->_values.clear();
			this->_count =0;
            
			for(i=0; i<s._fields.size(); i++)
			{
				(*this).addField(s._fields[i]);
			}
		}
		int iCount = this->_count;
		unsigned int i;
        for(i=0; i<s._values.size(); i++)
        {
            table_line line;
            for(unsigned int j=0; j<s._fields.size(); j++)
            {
                line.push_back(s.valueString(i,j));
            }
            (*this).addValue(line);
            line.clear();
        }
        
        this->_count = s._count+iCount;
	}
    void copy(CSelectHelp& s)
    {
        unsigned int i;
        this->_fields.clear();
        this->_values.clear();
        this->_count =0;
        
        for(i=0; i<s._fields.size(); i++)
        {
            (*this).addField(s._fields[i]);
        }
        
        for(i=0; i<s._values.size(); i++)
        {
            table_line line;
            for(unsigned int j=0; j<s._fields.size(); j++)
            {
                line.push_back(s.valueString(i,j));
            }
            (*this).addValue(line);
            line.clear();
        }
        
        this->_count = s._count;
    }
    void copyStruct(CSelectHelp& s)
    {
        unsigned int i;
        this->_fields.clear();
        this->_values.clear();
        this->_count =0;
        
        for(i=0; i<s._fields.size(); i++)
        {
            (*this).addField(s._fields[i]);
        }
        this->_count = 0;
    }
    
    const CSelectHelp& operator =(CSelectHelp& s)
    {
        for(unsigned int i=0; i<s._fields.size(); i++)
        {
            (*this).addField(s._fields[i]);
        }
        
        return *this;
    }
    CSelectHelp()
    {
        reset();
        util::string_format(_sSep , "%s",CONST_SEP_FIELD);
        util::string_format(_sLineSep , "%s",CONST_SEP_LINE);
    }
    ~CSelectHelp()
    {
        reset();
    }
    
    
    
    /* 通过字符串转化为CSelectHelp,返回值代表处理的条数 */
    int fromString(const char* s,
                   const char* sSep,const char* sLineSep,bool bHaveHeader=true)
    {
        if ( strlen(sSep) <= 0 ||  strlen(sLineSep) <= 0 ) return -1;
        
        //设置分隔符
        setSplit(sSep[0],sLineSep[0]);
        
        reset();
        
        std::string src = s;
        
        unsigned int i=0;
        _count = 0;
        
        std::vector<std::string> vsAll;
        if ( util::splitString(src.c_str(),vsAll,sLineSep) <= 0 )
        {
            return -1;
        }
        
        std::vector<std::string> vsLine;
        
        //处理头
        if ( util::splitString(vsAll[0].c_str(),vsLine,sSep) <= 0 )
        {
            return -1;
        }
        
        //增加字段
        for(i=0; i<vsLine.size(); i++)
        {
            if ( bHaveHeader )
            {
                
                addField(vsLine[i].c_str());
            }
            else
            {
                char buf[200]= {0};
                sprintf(buf,"f%03d",i);
                addField(buf);
            }
        }
        if ( vsAll.size() <= 1 )
        {
            /*只有头没有数据*/
            return 0;
        }
        
		int ikk = 1;
		if ( bHaveHeader == false )
		{
            
			ikk = 0;
            
		}
        for(i=ikk; i<vsAll.size(); i++)
        {
            vsLine.clear();
            table_line line;
            if ( util::splitString(vsAll[i].c_str(),vsLine,sSep) < (int)_fields.size() )
            {
                if ( vsLine.size() < _fields.size() )
                {
					//修正完全空字符串问题
					if ( vsAll[i].length() <= 0 && _fields.size() == 1 )
					{
						if ( _fields.size() > 1 )
						{
							line.push_back("");
							_values.push_back(line);
							_count++;
						}
						continue;
					}
                    
                    continue;
                }
            }
            
            
            for(unsigned int j=0; j<vsLine.size(); j++)
            {
                line.push_back(vsLine[j].c_str());
            }
            _values.push_back(line);
            _count++;
        }
        return _count;
        
    }
    int fromString(const char* src)
    {
        return fromString(src,_sSep.c_str(),_sLineSep.c_str(),true);
    }
    int fromStringNoField(const char* src,const char* sSep,const char* sLineSep)
    {
        return fromString(src,_sSep.c_str(),_sLineSep.c_str(),false);
    }
    
    bool existField(const char* src)
    {
        for(unsigned int i=0; i<_fields.size(); i++)
        {
            if ( gstricmp_gu(_fields[i].c_str(),src) == 0 )
            {
                return true;
            }
        }
        
        return false;
    }
    std::string toString()
    {
        std::string sout;
        unsigned int i= 0 ;
        for (i=0; i<_fields.size(); i++)
        {
            sout += _fields[i];
			if ( i != _fields.size() -1 )
				sout += _sSep;
        }
        sout += _sLineSep;
        
        int iRow = 0;
        for (iRow=0; iRow<_count; iRow++)
        {
            
            for (i=0; i<_fields.size(); i++)
            {
                sout +=  valueString(iRow,i);
                sout += _sSep;
            }
            
            if ( iRow != _count-1 )
                sout += _sLineSep;
            
        }
        return sout;
    }
    
    
    /** 通过key,value查找另外的key,value
     *  @param[in] 输入的key
     *  @param[in] key对应的值
     *  @param[in] 目标key
     *  @return 找到的字符串
     */
    std::string search(const std::string& key,const std::string& value,const std::string& destKey)
    {
        int idx = getIndexByName(key);
        
        if ( idx >= (int)_fields.size() || idx<0 )
        {
            return "";
        }
        
        for(unsigned int row=0; row<_values.size(); row++)
        {
            if (  gstricmp_gu(_values[row][idx].c_str(),value.c_str() ) == 0 )
            {
                int idx2 = getIndexByName(destKey);
                
                if (  idx2 >= 0 )
                    return _values[row][idx2];
                else
                    return "";
                
            }
        }
        
        return "";
    }
    /** 通过key,value查找另外的key,value
     *  @param[in] 输入的key
     *  @param[in] key对应的值
     *  @param[in] 目标key
     *  @return 找到的字符串
     */
    unsigned long search(const std::string& key,const std::string& value,std::vector<int>& vs)
    {
        vs.clear();
        int idx = getIndexByName(key);
        
        if ( idx >= (int)_fields.size() || idx<0 )
        {
            return -1;
        }
        
        for(unsigned int row=0; row<_values.size(); row++)
        {
            if (  gstricmp_gu(_values[row][idx].c_str(),value.c_str() ) == 0 )
            {
                vs.push_back(row);
            }
        }
        
        return vs.size();
    }
    
    
    /** 获取指定行的指定列的数据,以字符串方式返回
     *  @param[in] 行号
     *  @param[in] key
     @param[in] 是否去掉左右的空格和tab
     *  @return 找到的字符串
     */
    std::string valueString(int row,std::string key,bool trim=false)
    {
        if ( row <0 ) return "";
        if ( row >= _count ) return "";
        
        int idx = getIndexByName(key);
        
        if ( idx >= (int)_fields.size() || idx<0 )
        {
            std::string sTmp;
            util::string_format(sTmp,"字段 \"%s\" 不正确",key.c_str());
            return sTmp;
        }
        
        if ( trim )
        {
            std::string sTmp;
            sTmp = _values[row][idx];
            
            util::trim(sTmp);
            
            return sTmp;
            
        }
        
        return _values[row][idx];
    }
    
    /** 获取指定行的指定列的数据,以字符串方式返回
     *  @param[in] 行号
     *  @param[in] 列号
     *  @return 找到的字符串
     */
    std::string valueString(int row,int col,bool trim=false)
    {
        if ( row <0 ) return "";
        if ( col >= (int)_fields.size() || col <0 )
        {
            return "字段序号不正确";
        }
        
        
        if ( trim )
        {
            std::string sTmp;
            sTmp = util::trim(_values[row][col]);
            
            return sTmp;
            
        }
        
        return _values[row][col];
    }
    
    
    /** 获取指定行的指定列的数据,以整数方式返回
     *  @param[in] 行号
     *  @param[in] 列号
     *  @return 找到的字符串
     */
    long valueInt(int row,int col,int def=-999)
    {
        if (  row<0 ) return 0;
        
        if ( col >=(int) _fields.size() || col<0 ) return def;
        
        return  atol(_values[row][col].c_str());
        
    }
    
    /** 获取指定行的指定列的数据,以整数方式返回
     *  @param[in] 行号
     *  @param[in] 列号
     *  @return 找到的字符串
     */
    long valueInt(int row,std::string key,int def=-999)
    {
        if (  row<0 ) return 0;
        
        int idx = getIndexByName(key);
        if ( idx >= (int)_fields.size() || idx<0 ) return def;
        
        
        return  atol(_values[row][idx].c_str());
    }
    
    /** 获取指定行的指定列的数据,以浮点数方式返回
     *  @param[in] 行号
     *  @param[in] 列号
     *  @return 找到的字符串
     */
    double valuedouble(int row,int col,double def=-999.0)
    {
        if (  row<0 ) return 0;
        
        if ( col >= (int)_fields.size() || col<0 ) return def;
        
        return atof(_values[row][col].c_str());
    }
    
    /** 获取指定行的指定列的数据,以浮点数方式返回
     *  @param[in] 行号
     *  @param[in] 列号
     *  @return 找到的字符串
     */
    double valuedouble(int row,std::string key,double def=-999.0)
    {
        if (  row<0 ) return 0;
        
        int idx = getIndexByName(key);
        if ( idx >= (int)_fields.size() || idx<0 ) return def;
        return atof(_values[row][idx].c_str());
    }
    
    
    /** 重新初始化帮助类	*/
    void reset()
    {
        _alias.clear();
        _count = 0 ;
        _fields.clear();
        _values.clear();
        
        _sSortField = "";
        _bUniqueSort = false;
    }
    
    
    //修改字段的别名
    bool setFieldInfo(const string& field,const string& name,const string& alias="")
    {
        for(unsigned int i=0; i<_fields.size(); i++)
        {
            if ( gstricmp_gu(_fields[i].c_str(),field.c_str()) == 0 )
            {
                _fields[i] = name;
                _alias[i] = alias;
                return true;
            }
        }
        return false;
    }
    //修改字段的别名
    bool setFieldInfo(int idx,const string& name,const string& alias="")
    {
        
        if ( idx >= (int)_fields.size() || idx<0 ) return false;  //没有找到字段则返回
        
        
        _fields[idx] = name;
        _alias[idx] = alias;
        return true;
    }
    
    /** 显示当前表查询表结构的信息	*/
    void dumpSelectStruct()
    {
        
    }
    
    /*
     将数据按指定字段排序,快速度查找,需要先使用CSortHelp进行排序
     采用已排序方式,采用二分查找，可以大大提高效率,但只能返回一条记录
     */
	int lookup(const char* field,const char* value)
	{
        
		int idx = getIndexByName(field);
		if ( idx >= (int)_fields.size() || idx<0 ) return -1;  //没有找到字段则返回
        
		if ( !_bUniqueSort || _sSortField.length()<=0 )
		{
			//没有排序过则返回
			//复制结构
            
			for(int i=0; i<_count; i++)
			{
				if ( strcmp( valueString(i,idx).c_str(),value) == 0 )
				{
					return i;
				}
			}
		}
        
        
		//std::binary_search(
		int   low=0,high=_count-1,mid;   //置当前查找区间上、下界的初值
		while( low <= high )
		{   //当前查找区间R[low..high]非空
			mid=(low+high)/2;
			int ic = gstricmp_gu(valueString(mid,idx).c_str(),value );
			if(   ic   ==  0   )
			{
                
				return mid;
			}
			if(	ic > 0)
				high=mid-1;   //继续在R[low..mid-1]中查找
			else
				low=mid+1;   //继续在R[mid+1..high]中查找
		}
		return   -1;   //当low>high时表示查找区间为空，查找失败
	}
    bool lookup(const char* field,const char* value,CSelectHelp& help)
    {
        
        
        help.reset();
        
        int idx = getIndexByName(field);
        if ( idx >= (int)_fields.size() || idx<0 ) return false;  //没有找到字段则返回
        
        
        help.copyStruct(*this);
        
        if ( !_bUniqueSort || _sSortField.length()<=0 )
        {
            //没有排序过则返回
            //复制结构
            
            
            for(int i=0; i<_count; i++)
            {
                if ( strcmp( valueString(i,idx).c_str(),value) == 0 )
                {
                    //找到则将此行加入help;
                    
                    table_line line;
                    for(unsigned int j=0; j<_fields.size(); j++)
                    {
                        line.push_back(valueString(i,j));
                    }
                    help.addValue(line);
                }
            }
            return true;
        }
        
        
        //std::binary_search(
        int   low=0,high=_count-1,mid;   //置当前查找区间上、下界的初值
        while( low <= high )
        {   //当前查找区间R[low..high]非空
            mid=(low+high)/2;
            int ic = gstricmp_gu(valueString(mid,idx).c_str(),value );
            if(   ic   ==  0   )
            {
                table_line line;
                for(unsigned int j=0; j<_fields.size(); j++)
                {
                    string stmp = valueString(mid,j);
                    
                    line.push_back(stmp);
                    //wlog("%s\n",stmp.c_str());
                }
                help.addValue(line);
                
                //area = valueString(mid,2).c_str();
                //desc = valueString(mid,3).c_str();
                return true;
            }
            if(	ic > 0)
                high=mid-1;   //继续在R[low..mid-1]中查找
            else
                low=mid+1;   //继续在R[mid+1..high]中查找
        }
        return   false;   //当low>high时表示查找区间为空，查找失败
    }
	/*
     将数据按指定字段排序,快速度查找,需要先使用CSortHelp进行排序
     采用已排序方式,采用二分查找，可以大大提高效率,但只能返回一条记录
     */
	bool lookupOne(const string& field,const string& value,const string& sField,string& sDestValue)
	{
        
        
		//help.reset();
        
		int idx = getIndexByName(field);
		if ( idx >= (int)_fields.size() || idx<0 ) return false;  //没有找到字段则返回
        
        
		//help.copyStruct(*this);
        
		if ( !_bUniqueSort || _sSortField.length()<=0 )
		{
			//没有排序过则返回
			//复制结构
            
            
			for(int i=0; i<_count; i++)
			{
				if ( gstricmp_gu( valueString(i,idx).c_str(),value.c_str()) == 0 )
				{
					//找到则将此行加入help;
					
					sDestValue = valueString(i,sField);
					return true;
				}
			}
			
		}
        
        
		//std::binary_search(
		int   low=0,high=_count-1,mid;   //置当前查找区间上、下界的初值
		while( low <= high )
		{   //当前查找区间R[low..high]非空
			mid=(low+high)/2;
			int ic = gstricmp_gu(valueString(mid,idx).c_str(),value.c_str() );
			if(   ic   ==  0   )
			{
				
				sDestValue = valueString(mid,sField);
				return true;
			}
			if(	ic > 0)
				high=mid-1;   //继续在R[low..mid-1]中查找
			else
				low=mid+1;   //继续在R[mid+1..high]中查找
		}
		return   false;   //当low>high时表示查找区间为空，查找失败
	}
    
    /** 显示当前列表中的数据	*/
    void dump(const char* sep="\t")
    {
        for(unsigned int k=0; k<_fields.size(); k++)
        {
            if ( _alias[k].length() <= 0 )
            {
                wlog("%s",_fields[k].c_str());
            }
            else
            {
                wlog("%s",_alias[k].c_str());
            }
            if ( k <= (_fields.size() -2) )
                wlog("%s",sep);
        }
        wlog("\n");
        
        for(unsigned int i=0; i<_values.size(); i++)
        {
            for(unsigned int j=0; j<_fields.size(); j++)
            {
                
                wlog("%s",valueString(i,_fields[j]).c_str());
                if ( j <= (_fields.size() -2) )
                    wlog("%s",sep);
            }
            wlog("\n");
        }
    }
    
    /** 增加table_line
     *  @param[in] table_line
     *  @return 如是ture代表成功
     */
    bool addValue(table_line value)
    {
        if ( value.size() < _fields.size() ) return false;
        
        _values.push_back(value);
        _count++;
        
        return true;
    }
    
    
    /** 增加字段名
     *  @param[in] 字段名
     *  @return 没有返回值
     */
    void addField(const std::string& value,const std::string& alias="")
    {
        _alias.push_back(alias);
        _fields.push_back(value);
    }
    
    /** 增加字段名,（在有数据的情况下，相当于此字段行的数据都为空）
     *  @param[in] 字段名
     *  @return 没有返回值
     */
	void addFieldWithData(const std::string& value,const std::string& alias="")
	{
		_alias.push_back(alias);
		_fields.push_back(value);
        
		for(unsigned int i=0;i<_values.size();i++)
		{
			_values[i].push_back("");
		}
        
	}
    
    
    
    /*获取字段的别名*/
    std::string getAlias(int col)
    {
        if ( col >= (int)_fields.size() || col<0 ) return "";
        
        if ( _alias[col].length() > 0  )
        {
            return _alias[col];
        }
        
        return  _fields[col];
    }
    
    std::string getAlias(const string& field)
    {
        
        for(unsigned int k=0; k<_fields.size(); k++)
        {
            if ( gstricmp_gu(field.c_str(),_fields[k].c_str()) == 0 )
            {
                if ( _alias[k].length() <= 0 )
                {
                    return _fields[k];
                }
                return _alias[k];
            }
        }
        return "";
    }
    
    //用于更新help内容
    
    /** 在返回的结果集中，修改结果集中的整数值
     *  @param[in] 行号
     *  @param[in] 列号
     *  @param[in] 修改的值
     *  @return 是否修改成功
     */
    bool setValueInt(int row,int col,int value)
    {
        if (  row<0 ) return false;
        
        if ( col >= (int)_fields.size() || col<0 ) return false;
        
        
        _values[row][col]= value;
        
        return false;
    }
    
    /** 在返回的结果集中，修改结果集中的整数值
     *  @param[in] 行号
     *  @param[in] 字段名
     *  @param[in] 修改的值
     *  @return 是否修改成功
     */
    bool setValueInt(int row,std::string key,int value)
    {
        if (  row<0 ) return false;
        
        int idx = getIndexByName(key);
        if ( idx >= (int)_fields.size() || idx<0 ) return false;
        
        
        
        _values[row][idx] = value;
        
        return true;
    }
    
    
    
    bool setI(int row,int col,int value)
    {
        
		return setValueInt(row,col,value);
    }
    
    /** 在返回的结果集中，修改结果集中的整数值
     *  @param[in] 行号
     *  @param[in] 字段名
     *  @param[in] 修改的值
     *  @return 是否修改成功
     */
    bool setI(int row,std::string key,int value)
    {
        return setValueInt(row,key,value);
    }
    
    
    /** 在返回的结果集中，修改结果集中的浮点数的值
     *  @param[in] 行号
     *  @param[in] 列号
     *  @param[in] 修改的值
     *  @return 是否修改成功
     */
    bool setValuedouble(int row,int col,double value)
    {
        if (  row<0 ) return false;
        
        if ( col >= (int)_fields.size() || col<0 ) return false;
        
        char buf[40]= {0};
        sprintf(buf,"%f",value);
        
        _values[row][col] = buf ;
        return false;
    }
    
    /** 在返回的结果集中，修改结果集中的浮点数的值
     *  @param[in] 行号
     *  @param[in] 字段名
     *  @param[in] 修改的值
     *  @return 是否修改成功
     */
    bool setValuedouble(int row,std::string key,double value)
    {
        if (  row<0 ) return false;
        
        int idx = getIndexByName(key);
        if ( idx >= (int)_fields.size() || idx<0 ) return false;
        
        char buf[40]= {0};
        sprintf(buf,"%f",value);
        _values[row][idx] = buf ;
        
        return true;
    }
    bool setF(int row,int col,double value)
    {
		return setValuedouble(row,col,value);
    }
    
    /** 在返回的结果集中，修改结果集中的浮点数的值
     *  @param[in] 行号
     *  @param[in] 字段名
     *  @param[in] 修改的值
     *  @return 是否修改成功
     */
    bool setF(int row,std::string key,double value)
    {
        
		return setValuedouble(row,key,value);
    }
    
    
    /** 在返回的结果集中，修改结果集中的字符串的值
     *  @param[in] 行号
     *  @param[in] 列号
     *  @param[in] 修改的值
     *  @return 是否修改成功
     */
    bool setValueString(int row,int col,std::string value)
    {
        if (  row<0 ) return false;
        
        if ( col >= (int)_fields.size() || col<0 ) return false;
        
        
        _values[row][col] = value;
        
        return false;
    }
    
    /** 在返回的结果集中，修改结果集中的浮点数的值
     *  @param[in] 行号
     *  @param[in] 字段名
     *  @param[in] 修改的值
     *  @return 是否修改成功
     */
    bool setValueString(int row,std::string key,std::string value)
    {
        if (  row<0 ) return false;
        
        int idx = getIndexByName(key);
        if ( idx >= (int)_fields.size() || idx<0 ) return false;
        
        
        
        _values[row][idx] = value;
        
        return true;
    }
	bool setS(int row,std::string key,std::string value)
	{
        
		return setValueString(row,key,value);
	}
	bool setS(int row,int col,std::string value)
	{
		return setValueString(row,col,value);
	}
    
    
    
    void setSplit(char sep,char lineSep)
    {
        CSystemUtil::string_format(_sSep,"%c",sep);
        CSystemUtil::string_format(_sLineSep,"%c",lineSep);
        
    }
    
    //将CSelectHelp进行排序
    //排序可以按string,float,int三种方式进行排序
    bool sort(const char* field,
              const char* type="string",
              bool bAsc=true)
    {
        //先将原有对象进行Copy保存原有值
        
        //判断是否存在此字段名
        if ( !existField(field)  ) return false;
        
        CSelectHelp nHelp;
        nHelp.copy(*this);
        
        reset();
        copyStruct(nHelp);
        
        
        
        int i=0;
        std::vector<std::string> vs;  //临时对象
        for(i=0; i<nHelp.size(); i++)
        {
            //增加时要保证是唯一的
            
            vs.push_back(nHelp.valueString(i,field));
        }
        
        
        std::vector<std::string>::iterator it =  std::unique(vs.begin(), vs.end());
        vs.erase(it, vs.end());
        
        
        //vector<string>::iterator new_end = std::unique(vs.begin(), vs.end());
        // wlog("%d\n",vs.size());
        
        help_sort(vs,type,bAsc);
        
        
        //copy(vs.begin(),vs.end(),ostream_iterator<std::string>(cout,"\n"));
        
        
        //if ( nHelp.size() !=  vs.size() )
        //{
        //	reset();
        //	copy(nHelp);
        //	wlog("Error:size not equal\n");
        //	return false;
        //}
        
        _bUniqueSort = true;
        
        for(i=0; i<(int)vs.size(); i++)
        {
            
            std::vector<int> vint;
            
            if ( nHelp.search(field,vs[i],vint) <= 0 )
            {
                wlog("出错了，没有找到,可能是数据类型不一致\n");
                reset();
                copy(nHelp);
                _bUniqueSort = false;
                return false;
            }
            
            if ( vint.size() >1 )
            {
                _bUniqueSort = false;
            }
            
            //copy(vint.begin(),vint.end(),ostream_iterator<int>(cout,"\n"));
            
            for(unsigned int j=0; j<vint.size(); j++)
            {
                if ( j%100 == 0 )
                {
                    //wlog("%d\n",j);
                }
                table_line iline;
                for(unsigned int k=0; k<nHelp._fields.size(); k++)
                {
                    
                    iline.push_back(nHelp.valueString(vint[j],k));
                }
                
                addValue(iline);
            }
            
            
        }
        
        _sSortField = field;
        
        return (_count == nHelp._count);
    }
    
    
    //for lua only
    
    bool toFile(string file)
    {
        FILE* fp = fopen(file.c_str(),"w");
        
        if ( fp == NULL ) return false;
        
        
        string s = toString();
        
        fwrite(s.c_str(),sizeof(char),s.length(),fp);
        
        fclose(fp);
        
        return true;
        
    }
    bool fromFile(string file)
    {
        string out;
        util::readFileAsString((char*)file.c_str(),out,80000);
        
        fromString(out.c_str());
        
        return true;
    }
    
    std::string	vsi(int row,int col)
    {
        
        
        return valueString(row,col);
    }
    std::string vs(int row,string  field)
    {
        return valueString(row,field);
    }
    
    long	vii(int row,int col)
    {
        
        return valueInt(row,col);
    }
    long vi(int row,string field)
    {
        return valueInt(row,field);
    }
    
    double	vfi(int row,int col)
    {
        
        
        return valuedouble(row,col);
    }
    double vf(int row,string field)
    {
        return valuedouble(row,field);
    }
    
    int	cols()
    {
        return (int)_fields.size();
    }
    int	rows()
    {
        return _count;
    }
    std::string getColName(int col)
    {
        if ( col >= cols() ) return "";
        
        return _fields[col];
    }
    
    
public:
    
    bool			_bUniqueSort;
    std::string		_sSortField;
    std::string		_sSep;
    std::string		_sLineSep;
    /** 返回的记录条数 */
    int _count;
    
    /** 存储数据库返回的各行信息 */
    std::vector<table_line> _values;
    
    /** 返回的字段名数组 */
    std::vector<std::string>   _fields;
    
    /** 返回的字段名数组 */
    std::vector<std::string>   _alias;  //字段的别名
    
    /** 通过名称查询相应的索引号 */
    int getIndexByName(std::string key)
    {
        for(unsigned int i=0; i<_fields.size(); i++)
        {
            
            if ( gstricmp_gu(key.c_str(), _fields[i].c_str()) == 0 )
                return i;
        }
        return -1;
    }
private:
    
    
    static int comp_int_asc(const int& a,const int& b)
    {
        return a < b;
    }
    static int comp_int_dsc(const int& a,const int& b)
    {
        return a > b;
    }
    static int comp_float_asc(const double& a,const double& b)
    {
        return a < b;
    }
    static int comp_float_dsc(const double& a,const double& b)
    {
        return a > b;
    }
    
    static int comp_string_asc(const string& a,const string& b)
    {
        return ( strcmp(a.c_str(),b.c_str()) < 0 );
    }
    static int comp_string_dsc(const string& a,const string& b)
    {
        return ( strcmp(a.c_str(),b.c_str()) > 0 );
    }
    
    static void help_sort(std::vector<std::string> &vs,
                          const char* type="string",bool bAsc=true)
    {
        
        //按字符串排序
        if ( gstricmp_gu(type,"string") ==  0)
        {
            
            if ( bAsc )
                std::sort(vs.begin(), vs.end(),comp_string_asc);
            else
                std::sort(vs.begin(), vs.end(),comp_string_dsc);
            
            return;
        }
        
        if ( gstricmp_gu(type,"int") ==  0)
        {
            //如果是整数，则需要建临时对象再排序
            std::vector<int> vsTmp;
            
            for(unsigned int i=0; i<vs.size(); i++)
            {
                
                vsTmp.push_back( atoi(vs[i].c_str()) );
            }
            
            if ( bAsc )
                std::sort(vsTmp.begin(), vsTmp.end(),comp_int_asc);
            else
                std::sort(vsTmp.begin(), vsTmp.end(),comp_int_dsc);
            
            //将数据再copy回vs
            vs.clear();
            for(unsigned int i=0; i<vsTmp.size(); i++)
            {
                string stmp;
                util::string_format(stmp,"%d",vsTmp[i]);
                vs.push_back( stmp);
            }
            return;
        }
        if ( gstricmp_gu(type,"float") ==  0)
        {
            //如果是整数，则需要建临时对象再排序
            std::vector<double> vsTmp;
            
            for(unsigned int i=0; i<vs.size(); i++)
            {
                vsTmp.push_back( atof(vs[i].c_str()) );
            }
            if ( bAsc )
            {
                std::sort(vsTmp.begin(), vsTmp.end(),comp_float_asc);
            }
            else
            {
                std::sort(vsTmp.begin(), vsTmp.end(),comp_float_dsc);
            }
            
            //将数据再copy回vs
            vs.clear();
            for(unsigned int i=0; i<vsTmp.size(); i++)
            {
                string stmp;
                util::string_format(stmp,"%.8f",vsTmp[i]);
                util::trim_right(stmp,"0");
                util::trim_right(stmp,".");
                
                vs.push_back( stmp);
            }
            return;
        }
    }
    
};

/** 数据库字段类型,用于CSQLBuilder使用 */
enum _my_db_datatype
{
    DB_INT,
    DB_LONG,
    DB_STRING,
    DB_DATE,
    DB_FLOAT,
    DB_CLOB
};



enum DBUtilOption
{
    DBOP_MAX_COUNT=1,   /** 最大返回行数 */
    DBOP_COMMIT_TYPE=2, /** 数据据自动提交类型,0代表非自动,1代表自动 */
    DBOP_DATE_FORMAT=3, /** 0=yyyy-mm-dd hh:mi:ss,1=yyyymmddhh24miss */
    DBOP_TRIM_SPACE=4,  /** 是否去掉取到的空格 */
    DBOP_FETCH_COUNT=5, /** 如果分批取数据时，指定每次取数据的条数 */
    DBOP_FIELD_SEP=6,   /** 查询结果值的分隔符 */
    DBOP_QUERY_TIMEOUT=7, /** 查询语句至现在为止的超时时间,以秒为单位 */
    DBOP_LINE_SEP=8,	/** 查询结果集的分行符号 */
    DBOP_FETCH_HEADER=9, /** 查询集中是否返回字段的头信息 */
    DBOP_MAX_DBUTIL_OPTION=99
};

typedef enum _my_db_datatype my_db_datatype;

class parameter_info
{
public:
    /** 参数的数据类型 */
    my_db_datatype	m_type;
    std::string		m_sVar;  //变量的全称,例如 :vv<int>,:v1<char[20],out] 等
    int				m_fType; //OTL 对应的数据库型
    
    bool			m_bNull;  //是否为空
    std::string		m_sValue; //字段对应值
    std::string		m_sName;  //字段名称
    std::string		m_sCType; //C++里面对应的类型
    
    //0 - IN variable, 1 - OUT variable, 2 - INOUT variable
    int				m_iParamType;
    
    //如果是字符串还需要知道字符串的长度
    int				m_iSize;
    
    parameter_info();
};



//////////////////////////////////////////////////////////////////////////

#ifdef USE_ICE

#include <Ice/BuiltinSequences.h>
typedef void(*ProgressFileCallback)(string path, double iProgress);
typedef void(*ProgressFileDoneCallback)(string path, int iResult, const string& sError);

class CICEBaseDBUtil
{
public:
    CICEBaseDBUtil();
    
    ~CICEBaseDBUtil();
    //用户名和密码只在使用认证方式时使用,如果UDP端口设置为0代表与TCPPort相同
    void setServer(const char* server,int iTcpPort,int iUdpPort=0,int iSSLPort=0);
    std::string& getVersion(string& out);
    bool login();
    bool isLogin();
    bool logout();
    
    bool loginUser(const char* username,const char* pass,string& error);
    
    string& getConfigure(char* segment,char* key,string& out);
    
    string& getTime(std::string& out);
    int command(const string& cmd,const string& param,string& out);
    
    int plugin(const string& pname,const string& cmd,const string& param,string& out);
    
    void sendOneway(const char* msg);
    
    bool send(const char* msg);
    
    
    //设置ICE接收的最大容量,以KB为单位
    void setMaxRecvSize(int iMax);
    
    
    int select(const string& sql,string &out,string &sError);
    int select(const string& sql,const string& param,string& out,string &sError);
    
	//提供基于分页的数据查询,iStart代表开始行记录，iCount代表取多少条记录,最大每次限制1W条
	int selectPage(const string& sql ,const string& param,
                   string& out,string &sError,int iStart=1,int iCount=0);
	int selectPage(const string& sql,
                   string& out,string &sError,int iStart=1,int iCount=0);
    
    
    int selectSync(const string& sql,string &out,string &sError);
    int selectSync(const string& sql,const string& param,string& out,string &sError);
    
//    bool execSQL(CSQLBuilder& builder,string &sError);
    bool execSQL(const string& sql,const string& param,string &sError);
    bool execSQLBatch(const string& sql,string &sError);
    
//    bool execProc(CSQLBuilder &bd,string& out,string &sError);
    bool execProc(const string& sql,const string& param,string& out,string &sError);
    
    void setTimeOut(int iMSeconds=30000);
	void setConnectTimeOut(int iMSeconds=5000);
    
    
	//增加selectCmd和ExecCmd命令
	int selectCmd(const std::string & cmd, const std::string & sqlcode, const ::std::string& param,
                  string& set, string& error);
    
	int execCmd(const std::string & cmd, const std::string & sqlcode, const ::std::string& param,
                string& set, string& error);
    
    /************************************************************************/
    /*         此函数将提交至后台执行，不管是否成功，都返回true             */
    /************************************************************************/
    bool writeBusiLog(const string& personid,const string&  ip,const string& busiType,const string& comment);
    
    std::string& getMsg(std::string& out);
    
    static std::string& getUUID(std::string& out);
    
    void getServerInfo(string& ip,int& port,string& user,string& pass);
    
    
    //用于获取流水号,如果返回-1，代表执行失败
    int getMaxID(const string& sSeqName,int count,int& start);
    
    
    
	//分页查询，保持连接不变
	//bool selectPrepare(const string& sql, string& sID, string& error);
	//int selectNext(const string& sID, string& help);
	//bool selectFinish(const string& sID);
	//数据库类型包括
	//Oracle,SQL Server,Access,MySQL
    
    //用于文件服务
	//新增加用于文件服务
	virtual  bool getFileInfo(const string& sFilePath, string& sHelpInfo) const;    //用于查询一个文件的信息
	virtual  bool getFileInfoSeq(const string& sFilePath, string& sHelpInfo) const; //用于查询目录下所有文件的信息
    
    
    
	//pos开始位置,num代表读取的大小,sFile代表文件名称，相对于文件服务的根目录下的目录
	int getFileCompressed(const ::std::string& sFile, int pos, int num, Ice::ByteSeq& bytes) const;
    
	//下载文件
	bool downloadFile(const string& sFile, const string& sDestPath, ProgressFileCallback pF = NULL, ProgressFileDoneCallback pFinished = NULL);
    
    
	//上传文件
	/*
     *  sFile 本地文件
     *  sRemotePath 远程目录
     */
	int upload(const string& sFile, const string& sRemotePath, ProgressFileCallback pF = NULL, ProgressFileDoneCallback pFinished = NULL);
    
	//上传文件
	int uploadFileCompressed(const ::std::string& sSrcFile, ::Ice::Int pos,int num,const ::Ice::ByteSeq& fileContent);
    
    
    
	int getFileRetryTimes()
	{
		return m_iFileRetryTimes;
	}
	void setFileRetryTimes(int iCount)
	{
		m_iFileRetryTimes = iCount;
	}
    
	int getFileCache()
	{
		return m_iCacheSize;
	}
	void setFileCache(int iCacheSize)
	{
		m_iCacheSize = iCacheSize;
	}
    
private:
    int					 m_iFileRetryTimes; //文件下载和上传重试次数
	int					 m_iCacheSize; //文件下载和上传每次上传数据包大小
    
	int					m_iConnectTimeOut; //连接超时时间
	string				m_sLastQueryID;
    
    int					 m_iMaxRecvSize;
    int					 m_iSleepSlip;
    string				 m_sServer;//服务器地址
    int					 m_iTCPPort; //TCP 端口号
    int					 m_iUDPPort; //UDP端口号
    int					 m_iSSLPort; //SSL端口号
    
    bool				 m_bICEInited; //是否已经初始化ICE
    
    int					 m_iTimeOut;   //连接超时时间
    
    bool				 m_bConnected;	//是否已经连接
    
    
    string				 m_sSep; //字段间分隔
    string				 m_sLineSep; //行间分隔
    
    std::string			 m_sError;
    
    int					 m_id; //ice对应的编号
};



/** 主要是为了CSelectHelp 在DLL和main不能交换，故简单分解*/
/*   关于如何进行新版本的登录
 
 1.和之前一样通过setServer设置服务器信息
 2.通过login登录
 3.loginUser验证用户名和密码
 4.通过getRight 获取权限ID列表,CUniqueArray& ua 中存储的就是列表
 
 例子:
 
 bool testLogin()
 {
 CICEDBUtil db;
 db.setServer("localhost",8840);
 if ( !db.login() ) return false;
 
 string error;
 if ( !db.loginUser("ad","1",error) )
 {
 wlog("%s\n",error.c_str());
 return false;
 }
 
 
 CUniqueArray ua;
 if ( !db.getRight("ad",1107,ua) )
 return false;
 
 
 string sright ;
 ua.getAsString(sright);
 
 //AfxMessageBox(sright.c_str());
 
 return true;
 }
 
 
 */
//!  CUniqueArray类，用于建立唯一性数组.
/*!
 
 */


//template class EUTILS_DLL_API std::allocator<std::string>;
//template class EUTILS_DLL_API std::vector<std::string, std::allocator<std::string> >;


class CUniqueArray
{
public:
    CUniqueArray();
    void add(const char* v);
    
    std::string& getAsString(std::string& out,const char* sep=",");
    
    int	 size();
    void clear();
    std::string& get(int idx,std::string& out);
    
    void dump();
private:
    std::vector<std::string> _vs;
};

class  CICEDBUtil
{
public:
    CICEDBUtil()
    {
        m_bUTF8 = false;
    }
	void setDBType(const char* dbType)
	{
		m_dbType = dbType;
	}
	string getDBType()
	{
		return m_dbType;
	}
	/*bool selectPrepare(const string& sql, string& sID, string& error)
     {
     return m_db.selectPrepare(sql,sID,error);
     }
     int selectNext(const string& sID, string& help)
     {
     return m_db.selectNext(sID,help);
     }
     int selectNext(const string& sID, CSelectHelp& help)
     {
     string sSet="";
     int ic = m_db.selectNext(sID,sSet);
     help.fromString(sSet.c_str());
     return help._count;
     }*/
	//bool selectFinish(const string& sID)
	//{
	//	return m_db.selectFinish(sID);
	//}
	void setMaxRecvSize(int iMax)
	{
		m_db.setMaxRecvSize(iMax);
	}
    void setServer(const char* server,int iTcpPort,int iUdpPort=0,int iSSLPort=0)
    {
        m_db.setServer(server,iTcpPort,iUdpPort,iSSLPort);
    }
    std::string& getVersion(string& out)
    {
        return m_db.getVersion(out);
    }
    bool login()
    {
        return m_db.login();
        
    }
    bool isLogin()
    {
        return m_db.isLogin();
    }
    bool logout()
    {
        return m_db.logout();
    }
    
    string& getConfigure(char* segment,char* key,string& out)
    {
        return m_db.getConfigure(segment,key,out);
    }
    
    string& getTime(std::string& out)
    {
        return m_db.getTime(out);
    }
    int command(const string& cmd,const string& param,string& out)
    {
        out = "";
        return m_db.command(cmd,param,out);
    }
    
    //用于文件相关服务////////////////////////
	//用于文件服务
	//新增加用于文件服务
    bool getFileInfo(const string& sFilePath, string& sHelpInfo)
	{
        return m_db.getFileInfo(sFilePath, sHelpInfo);
	}
    bool getFileInfoSeq(const string& sFilePath, string& sHelpInfo)
    {
        return m_db.getFileInfoSeq(sFilePath, sHelpInfo);
    }
    
	//pos开始位置,num代表读取的大小,sFile代表文件名称，相对于文件服务的根目录下的目录
    int getFileCompressed(const ::std::string& sFile, int pos, int num, Ice::ByteSeq& bytes)
    {
        return m_db.getFileCompressed(sFile, pos, num, bytes);
    }
    
    bool downloadFile(const string& sFile, const string& sDestPath, ProgressFileCallback pF = NULL, ProgressFileDoneCallback pFinished = NULL)
    {
        return m_db.downloadFile(sFile, sDestPath, pF, pFinished);
    }
    
    //上传文件
    int uploadFileCompressed(const ::std::string& sSrcFile, ::Ice::Int pos, int num,
                             const ::Ice::ByteSeq& fileContent)
    {
        return m_db.uploadFileCompressed(sSrcFile, pos,num, fileContent);
    }
    
    int upload(const string& sFile, const string& sRemotePath, ProgressFileCallback pF = NULL, ProgressFileDoneCallback pFinished = NULL)
    {
        return m_db.upload(sFile, sRemotePath, pF,pFinished);
    }
    
    void setFileCache(int iCacheSize)
	{
		m_db.setFileCache(iCacheSize);
	}
///////////////////////////////////////////////
    
    int plugin(const string& pname,const string& cmd,const string& param,string& out)
    {
        out = "";
        return m_db.plugin(pname,cmd,param,out);
    }
    
    void sendOneway(const char* msg)
    {
        m_db.sendOneway(msg);
    }
    
    bool send(const char* msg)
    {
        return m_db.send(msg);
    }
    int selectSync(const string& sql,string &out,string &sError)
    {
        out = "";
        return m_db.selectSync(sql,out,sError);
    }
    int selectSync(const string& sql,const string& param,string& out,string &sError)
    {
        out = "";
        return m_db.selectSync(sql,param,out,sError);
    }
    int selectSync(const string& sql,CSelectHelp &sSet,string &sError)
    {
        string out;
        sSet.reset();
        //        int ic = m_db.selectSync(sql,"",out,sError);
        m_db.selectSync(sql,"",out,sError);
        
        
        sSet.fromString(out.c_str());
        return sSet._count;
    }
    int select(const string& sql,string &out,string &sError)
    {
        out = "";
        return m_db.select(sql,out,sError);
    }
    int select(const string& sql,const string& param,string& out,string &sError)
    {
        out = "";
        return m_db.select(sql,param,out,sError);
    }
	int selectCount(const string& sql)
	{
		string error;
		string out;
        //        int ic = m_db.select(sql,"",out,error);
        m_db.select(sql,"",out,error);
        
        CSelectHelp help;
        help.fromString(out.c_str());
        
		if ( help._count <= 0 ) return 0;
        
		return static_cast<int>(help.valueInt(0,0));
	}
	//增加selectCmd和ExecCmd命令
	int selectCmd(const std::string & cmd, const std::string & sqlcode, const ::std::string& param,
                  CSelectHelp& set, string& error)
	{
		string out;
		set.reset();
		int ic = m_db.selectCmd(cmd,sqlcode,param,out,error);
        
        
		set.fromString(out.c_str());
		return ic;
	}
    
	int execCmd(const std::string & cmd, const std::string & sqlcode, const ::std::string& param,
                CSelectHelp& set, string& error)
	{
		string out;
		set.reset();
		int ic = m_db.execCmd(cmd, sqlcode, param, out, error);
        
        
		set.fromString(out.c_str());
		return ic;
	}
    
	bool desc(const string& s,CSelectHelp& help,const string &sInsertSQL)
	{
		return true;
	}
    int select(const string& sql,CSelectHelp &sSet,string &sError)
    {
        string out;
        sSet.reset();
        int ic = m_db.select(sql,"",out,sError);
        
        /*	if ( isUTF8() )
         {
         string snewout;
         CChineseCodeLib::UTF_8ToGB2312(snewout,out);
         sSet.fromString(snewout.c_str());
         }
         else*/
        sSet.fromString(out.c_str());
        return ic;
    }
//	int selectPage(CSQLBuilder& builder,CSelectHelp &sSet,string &sError,int iStart=1,int iCount=0)
//    {
//        
//        string out;
//        sSet.reset();
//        
//        string ss;
//        string sp;
//        int ic = m_db.selectPage(builder.getSQL(ss),builder.toParamString(sp),out,sError,iStart,iCount);
//        
//        
//        if ( ic > 0 )
//        {
//            /*	if ( isUTF8() )
//             {
//             string snewout;
//             CChineseCodeLib::UTF_8ToGB2312(snewout,out);
//             sSet.fromString(snewout.c_str());
//             }
//             else*/
//            sSet.fromString(out.c_str());
//        }
//        return ic;
//    }
//	int selectPage(CSQLBuilder& builder,string &sSet,string &sError,int iStart=1,int iCount=0)
//    {
//        
//        string out;
//        sSet= "";
//        
//        string ss;
//        string sp;
//        int ic = m_db.selectPage(builder.getSQL(ss),builder.toParamString(sp),sSet,sError,iStart,iCount);
//        return ic;
//    }
//	int selectPage(const string& sql,CSelectHelp &help,string &sError,int iStart=1,int iCount=0)
//    {
//        
//        string ss;
//        string sSet;
//        int ic = m_db.selectPage(sql,"",sSet,sError,iStart,iCount);
//		help.fromString(sSet.c_str());
//        return ic;
//    }
//    
//    int select(CSQLBuilder& builder,CSelectHelp &sSet,string &sError)
//    {
//        
//        string out;
//        sSet.reset();
//        
//        string ss;
//        string sp;
//        int ic = m_db.select(builder.getSQL(ss),builder.toParamString(sp),out,sError);
//        
//        
//        if ( ic >= 0 )
//        {
//            /*	if ( isUTF8() )
//             {
//             string snewout;
//             CChineseCodeLib::UTF_8ToGB2312(snewout,out);
//             sSet.fromString(snewout.c_str());
//             }
//             else*/
//            sSet.fromString(out.c_str());
//        }
//        return ic;
//    }
    int getMaxID(const string& sSeqName,int count,int& start)
    {
        
        int iCurID = 0;
        start = -1;
        
        
        string sql;
        util::string_format(sql,"select seq_value from t_cfg_seq where seq_name='%s' ",
                            sSeqName.c_str());
        
        
        string out;
        string sError;
        
        if ( select(sql,out,sError) <= 0 )
        {
            return -1;
        }
        
        CSelectHelp help;
        help.fromString(out.c_str());
        
        if ( help._count <= 0 ) return -1;
        
        iCurID = static_cast<int>(help.valueInt(0,0));
        
        start  = iCurID;
        
        
        util::string_format(sql,"update  t_cfg_seq set seq_value=%d  where seq_name='%s' ",
                            iCurID+count,sSeqName.c_str());
        
        if ( !execSQL(sql,"",sError) )
        {
            return -1;
        }
        
        return count;
    }
    void getServerInfo(string& ip,int& port,string& user,string& pass)
    {
        m_db.getServerInfo(ip,port,user,pass);
    }
    
//    bool execSQL(CSQLBuilder& builder,string &sError)
//    {
//        string ss,sp;
//        return m_db.execSQL(builder.getSQL(ss),builder.toParamString(sp),sError);
//    }
    
    //用于与服务器保持会话连接
    bool healthCheck()
    {
        //register sn
        if ( !isLogin() ) return false;
        
        string hid = CSystemUtil::getID();
        
        string outmsg;
        command("health_check",hid,outmsg);
        
        return true;
    }
    
    bool loginUser(const char* username,const char* pass,string& error)
    {
        return m_db.loginUser(username,pass,error);
        //string sql;
        //util::string_format(sql,"select user_id,user_name,user_passwd from uums_user where user_name='%s'  and user_passwd='%s'",
        //	username,pass);
        //CSelectHelp help;
        //help.reset();
        
        //if ( select(sql.c_str(),help,error) < 0  )
        //{
        //	return false;
        //}
        //if ( help._count <=  0 )
        //{
        //	error = "用户名和密码不正确或者用户不存在";
        //	return false;
        //}
        ////register sn
        ////string hid = getID();
        ////if ( command("register_sn",hid,error) < 0 ) return false;
        //return true;
    }
    bool Get_CN_Name(const char * username,string & cn_name,string & sReturn)
    {
        sReturn = "";
        cn_name = "";
        string sql,error;
        util::string_format(sql,"select USER_CN_NAME from UUMS_USER where USER_NAME='%s' ",username);
        CSelectHelp helpUserCNName;
        if(select(sql.c_str(),helpUserCNName,error) < 0)
        {
            return false;
        }
        if(helpUserCNName._count > 0)
        {
            cn_name = helpUserCNName.valueString(0,0);
            return true;
        }
        else
        {
            sReturn = "该用户不存在！";
            return false;
        }
        return false;
        
    }
    bool UpdatePassword(const char * username,const char * oldPwd,const char * newPwd,string & sReturn)
    {
        string sql,error;
        sReturn = "";
        util::string_format(sql,"select USER_PASSWD from UUMS_USER where USER_NAME='%s' ",username);
        CSelectHelp helpUserPwd;
        if(select(sql.c_str(),helpUserPwd,error) < 0)
        {
            return false;
        }
        string userPwd;
        if(helpUserPwd._count > 0)
        {
            userPwd = helpUserPwd.valueString(0,0);
            if(!gstricmp_gu(userPwd.c_str(),oldPwd))
            {
                util::string_format(sql,"update UUMS_USER set USER_PASSWD='%s' where USER_NAME='%s' ",newPwd,username);
                if(execSQL(sql,"",error))
                {
                    sReturn = "修改密码成功！";
                    return true;
                }
                else
                {
                    sReturn = "修改密码失败！";
                    return false;
                }
            }
            else
            {
                sReturn = "原密码输入不正确！";
                return false;
            }
        }
        else
        {
            sReturn = "该用户不存在！";
            return false;
        }
        return false;
    }
    
    
    bool getRight(const char* username,int sysid,CUniqueArray& ua)
    {
        ua.clear();
        
        string sql,error;
        
        util::string_format(sql,"select user_id,1  from uums_user  where USER_name='%s' ",
                            username);
        
        CSelectHelp helpUserID;
        
        if ( select(sql.c_str(),helpUserID,error) < 0 )
        {
            return false;
        }
        int userid = -1;
        
        if ( helpUserID._count > 0 )
        {
            userid = static_cast<int>(helpUserID.valueInt(0,0));
        }
        
        util::string_format(sql,"select RIGHT_ID  from UUMS_USER_RIGHT  where USER_ID=%d and sys_id=%d order by right_id",
                            userid,sysid);
        
        
        CSelectHelp help;
        int i=0;
        
        int ic = select(sql,help,error);
        
        if ( ic  < 0 ) return false;
        for(i=0; i<help._count; i++)
        {
            ua.add(help.valueString(i,0).c_str());
        }
        
        CSelectHelp helpRight;
        util::string_format(sql,"select right_id from UUMS_ROLE_RIGHT where  ROLE_ID in(select distinct role_id from UUMS_USER_ROLE  where USER_ID=%d) and sys_id=%d",
                            userid,sysid);
        select(sql,helpRight,error);
        for(i=0; i<helpRight._count; i++)
        {
            ua.add(helpRight.valueString(i,0).c_str());
        }
        
        return true;
    }
    
    bool execSQL(const string& sql,const string& param,string &sError)
    {
        /*	if ( isUTF8() )
         {
         string snew_sql,snew_param;
         CChineseCodeLib::GB2312ToUTF_8(snew_sql,sql);
         CChineseCodeLib::GB2312ToUTF_8(snew_param,param);
         return m_db.execSQL(snew_sql,snew_param,sError);
         }*/
        
        return m_db.execSQL(sql,param,sError);
    }
    bool execSQL(const string& sql,string &sError)
    {
        
        return m_db.execSQL(sql,"",sError);
    }
    
    bool execSQLBatch(const string& sql,string &sError)
    {
        return m_db.execSQLBatch(sql,sError);
    }
    bool execSQLBatch(const char* sql,const char* sID,CSelectHelp &help)
    {
        string sError;
        help.reset();
        
        help.addField("id");
        help.addField("bok");
        help.addField("sql");
        help.addField("outinfo");
        
        
        bool bOK =  execSQLBatch(sql,sError);
        
        table_line line;
        string stmp;
        util::string_format(stmp,"%d",bOK);
        
        line.push_back("1");
        line.push_back(stmp);
        line.push_back("sql");
        line.push_back(sError);
        
        help.addValue(line);
        return bOK;
    }
    
    
//    bool execProc(CSQLBuilder &builder,CSelectHelp& help,string &sError)
//    {
//        
//        string sql,param,out;
//        bool  bok = m_db.execProc(builder.getSQL(sql),builder.toParamString(param),out,sError);
//        
//        //if ( isUTF8() )
//        //{
//        //	string snewout;
//        //	CChineseCodeLib::UTF_8ToGB2312(snewout,out);
//        //	help.fromString(snewout.c_str());
//        //}
//        //else
//        help.fromString(out.c_str());
//        
//        
//        return bok;
//    }
    bool execProc(const string& sql,const string& param,CSelectHelp& help,string &sError)
    {
        string out;
        bool bok = m_db.execProc(sql,param,out,sError);
        
        
        //if ( isUTF8() )
        //{
        //	string snewout;
        //	CChineseCodeLib::UTF_8ToGB2312(snewout,out);
        //	help.fromString(snewout.c_str());
        //}
        //else
        {
            help.fromString(out.c_str());
        }
        
        return bok;
    }
    
    void setTimeOut(int iMSeconds=8000)
    {
        m_db.setTimeOut(iMSeconds);
    }
    void setConnectTimeOut(int iMSeconds=8000)
    {
        m_db.setConnectTimeOut(iMSeconds);
    }
    /************************************************************************/
    /*         此函数将提交至后台执行，不管是否成功，都返回true             */
    /************************************************************************/
    bool writeBusiLog(const string& personid,const string&  ip,const string& busiType,const string& comment)
    {
        return m_db.writeBusiLog(personid,ip,busiType,comment);
    }
    
    std::string& getMsg(std::string& out)
    {
        return m_db.getMsg(out);
    }
    static std::string& getUUID(std::string& out)
    {
        return CICEBaseDBUtil::getUUID(out);
    }
    
    bool isUTF8()
    {
        return m_bUTF8;
    }
    void setIsUTF8(bool bUTF8)
    {
        m_bUTF8 = bUTF8;
    }
	/////////////////通讯接口//////////////////
	int addOrder(string orderNo, string& strErr)
	{
		string if_type;
		string out;
		CSelectHelp help;
		help.addField("orderNo");
		table_line line;
		line.push_back(orderNo);
		help.addValue(line);
		util::string_format(if_type,"%d",COMM_IF_addOrder);
		return m_db.select(if_type,help.toString(),out,strErr);
	}
	int updateOrder(string orderNo, string& strErr)
	{
		string if_type;
		string out;
		CSelectHelp help;
		help.addField("orderNo");
		table_line line;
		line.push_back(orderNo);
		help.addValue(line);
		util::string_format(if_type,"%d",COMM_IF_updateOrder);
		return m_db.select(if_type,help.toString(),out,strErr);
	}
	int sendAttemperNotice(int equipmentid, string orderNo,	int attemperCode, string& strErr)
	{
		string if_type;
		string out,tmp;
		CSelectHelp help;
		help.addField("equipmentid");
		help.addField("orderNo");
		help.addField("attemperCode");
		table_line line;
		util::string_format(tmp,"%d",equipmentid);
		line.push_back(tmp);
		line.push_back(orderNo);
		util::string_format(tmp,"%d",attemperCode);
		line.push_back(tmp);
		help.addValue(line);
		util::string_format(if_type,"%d",COMM_IF_sendAttemperNotice);
		return m_db.select(if_type,help.toString(),out,strErr);
	}
	int UpgradeQuery(int equipmentid,int querytype,string& strErr)
	{
		string if_type;
		string out,tmp;
		CSelectHelp help;
		help.addField("equipmentid");
		help.addField("querytype");
		table_line line;
		util::string_format(tmp,"%d",equipmentid);
		line.push_back(tmp);
		util::string_format(tmp,"%d",querytype);
		line.push_back(tmp);
		help.addValue(line);
		util::string_format(if_type,"%d",COMM_IF_UpgradeQuery);
		return m_db.command(if_type,help.toString(),out);
	}
	int GetTerminalSetting(int equipmentid, int seq, vector<int>& vSetRet, string& strErr )
	{
		string if_type;
		string out,tmp;
		int ret;
		CSelectHelp help;
		help.addField("equipmentid");
		help.addField("seq");
		table_line line;
		util::string_format(tmp,"%d",equipmentid);
		line.push_back(tmp);
		util::string_format(tmp,"%d",seq);
		line.push_back(tmp);
		help.addValue(line);
		util::string_format(if_type,"%d",COMM_IF_getTerminalSetting);
		ret =  m_db.select(if_type,help.toString(),out,strErr);
		if(!ret)
		{
			help.reset();
			help.fromString(out.c_str());
			int count = help._count;
			for(int i=0;i<count;i++)
			{
				vSetRet.push_back(static_cast<int>(help.valueInt(i,0)));
			}
		}
		return ret;
	}
	int sendEvent(int equipmentid, string& happentime,
                  int eventtype, int reasoncode, const string& reporter,
                  const string& reporttime, const string& checker, const string& checktime,
                  const string& manager, const string& managetime, const string& closer,
                  const string& closetime,int ischeck, int ismanage,
                  int isclose, string& strErr)
	{
		string if_type;
		string out,tmp;
		CSelectHelp help;
		help.addField("equipmentid");
		help.addField("happentime");
		help.addField("eventtype");
		help.addField("reasoncode");
		help.addField("reporter");
		help.addField("reporttime");
		help.addField("checker");
		help.addField("checktime");
		help.addField("manager");
		help.addField("managetime");
		help.addField("closer");
		help.addField("closetime");
		help.addField("ischeck");
		help.addField("ismanage");
		help.addField("isclose");
		table_line line;
		util::string_format(tmp,"%d",equipmentid);
		line.push_back(tmp);
		line.push_back(happentime);
		util::string_format(tmp,"%d",eventtype);
		line.push_back(tmp);
		util::string_format(tmp,"%d",reasoncode);
		line.push_back(tmp);
		line.push_back(reporter);
		line.push_back(reporttime);
		line.push_back(checker);
		line.push_back(checktime);
		line.push_back(manager);
		line.push_back(managetime);
		line.push_back(closer);
		line.push_back(closetime);
		util::string_format(tmp,"%d",ischeck);
		line.push_back(tmp);
		util::string_format(tmp,"%d",ismanage);
		line.push_back(tmp);
		util::string_format(tmp,"%d",isclose);
		line.push_back(tmp);
		help.addValue(line);
        
		util::string_format(if_type,"%d",COMM_IF_sendEvent);
		return m_db.select(if_type,help.toString(),out,strErr);
	}
	int SetTerminal(int equipmentid, int setseq, int setcontent,string& strErr)
	{
		string if_type;
		string out,tmp;
		CSelectHelp help;
		help.addField("equipmentid");
		help.addField("setseq");
		help.addField("setcontent");
		table_line line;
		util::string_format(tmp,"%d",equipmentid);
		line.push_back(tmp);
		util::string_format(tmp,"%d",setseq);
		line.push_back(tmp);
		util::string_format(tmp,"%d",setcontent);
		line.push_back(tmp);
		help.addValue(line);
		util::string_format(if_type,"%d",COMM_IF_setTerminal);
		return m_db.select(if_type,help.toString(),out,strErr);
	}
	int SendSynCmd(int equipmentid, vector<byte> &SendBuf, int iTimeOut, vector<byte>& RecvBuf, string& strErr)
	{
		string if_type;
		string out,tmp;
		CSelectHelp help;
		help.addField("equipmentid");
		help.addField("SendBuf");
		help.addField("iTimeOut");
		table_line line;
		for(unsigned int i=0;i<SendBuf.size();i++)
		{
			line.clear();
			util::string_format(tmp,"%d",equipmentid);
			line.push_back(tmp);
			util::string_format(tmp,"%d",SendBuf[i]);
			line.push_back(tmp);
			util::string_format(tmp,"%d",iTimeOut);
			line.push_back(tmp);
			help.addValue(line);
		}
		util::string_format(if_type,"%d",COMM_IF_SendSynCmd);
		int ret =  m_db.select(if_type,help.toString(),out,strErr);
		if(!ret)
		{
			help.reset();
			help.fromString(out.c_str());
			int count = help._count;
			for(int i=0;i<count;i++)
			{
				RecvBuf.push_back(help.valueInt(i,0));
			}
		}
		return ret;
	}
    bool UpgradeTerminal(vector<int> locationid,string& sBufer, string& strErr)
    {
        
        string out,tmp;
        CSelectHelp help,help_date;
        help.addField("locationid");
        for(unsigned int i=0;i<locationid.size();i++)
        {
            table_line line;
            util::string_format(tmp,"%d",locationid[i]);
            line.push_back(tmp);
            help.addValue(line);
        }
        help_date.addField("UpgradeFileBuf");
        table_line line;
        line.push_back(sBufer);
        help_date.addValue(line);
        return m_db.execProc(help.toString(),help_date.toString(),out,strErr);
    }
    
    
    //增加SelectPrepare,SelectNext,SelectFinish 用于超大数据集的全集查询
    //2012-03-13
    
private:
    CICEBaseDBUtil m_db;
    bool		   m_bUTF8;
	string				m_dbType;
    
};

#endif //END of USE_ICE

//操作SQLite 数据库，同一个程序不要有多个SQLite实例
class  CSQLiteUtil
{
public:
    CSQLiteUtil();
    
    ~CSQLiteUtil();
    
    bool login(const std::string& file);
    void logout();
    
    bool isLogin();
    
    int select(const string& sql,CSelectHelp& help,string& error);
    int select(const string& sql,string& out,string& error);
    
    bool execSQL(const string& sql,string& error);
    
	//插入一个二进制流数据
	/*db.insertBlob("insert into  ab values(11,:bindata)","c:\\a.bmp",error);
     *MString file = db.readBinary("select image from  ab where id=11");
     *用法请看上面的例子
     */
	bool updateBlob(const string& sql,const string& sFile,string& error);
	bool insertBlob(const string& sql,const string& sFile,string& error);
	bool insertBlob(const string& sql,byte* pContent,int filesize,string& error);
    
    
	int getBlob(const string& sql,const string& sField,byte* pContent);
	
	//将blob文件存到文件中
	int getBlob(const string& sql,const string& sField,const string& sFieldFileName,const string& sDir);
    
    
    //事务功能
    bool begin();
    bool commit();
    bool rollback();
    std::string& getMsg(string& error);
    
    
private:
    std::string _sDBFile;
    std::string _sError;
    bool		_bconnected;
};

/*
 *用于发送参数至中心，便于组装
 */
class SelectHelpParam
{
public:
    SelectHelpParam()
    {
        
    }
    void add(string src)
    {
        m_vs.push_back(src);
    }
    string get()
    {
        char c = 0x01;
        string sDest;
        for( int i=0; i<m_vs.size(); ++i)
        {
            sDest += m_vs[i];
            if( i!=m_vs.size() -1 )
                sDest += c;
        }
        
        return sDest;
    }
private:
    vector<string> m_vs;
};
