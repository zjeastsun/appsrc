#import"eutils.h"
#include <pthread.h>
#include <IceUtil/UUID.h>
#include<Ice/Initialize.h>
//#include <iconv.h>
#include "StringConverterI.h"

LogLevel g_mLogLevel = LOG_LEVEL_FULL;
LogType  g_mLogType = LOG_FULL;

class Scope_Mutex_C
{
private:
	pthread_mutex_t& mMutex;
	//Scope_Mutex_C(const Scope_Mutex_C&);
	//Scope_Mutex_C& operator=(const Scope_Mutex_C&);
    
public:
	// 构造时对互斥量进行加锁
	explicit Scope_Mutex_C(pthread_mutex_t& m) : mMutex(m)
	{
		pthread_mutex_lock( &mMutex );
	}
	// 析构时对互斥量进行解锁
	~Scope_Mutex_C()
	{
		pthread_mutex_unlock( &mMutex );
	}
};

CEDateTime::CEDateTime()
{
    reset();
}

void CEDateTime::reset()
{
    m_iYear = 0;
    m_iMonth = 0;
    m_iDay = 0;
    m_iHour = 0;
    m_iMinute = 0;
    m_iSecond = 0;
}

void CEDateTime::dump()
{
    wlog("m_iYear=%d,m_iMonth=%d,m_iDay =%d,m_iHour=%d,m_iMinute=%d,m_iSecond=%d\n",
         m_iYear,
         m_iMonth,
         m_iDay,
         m_iHour,
         m_iMinute,
         m_iSecond);
}

//int CSystemUtil::CodeChange(char *p_inBuf, char *p_OutBuf, int *p_OutSize, const char  *p_inCode, const char *p_OutCode)
//{
//    iconv_t cd;
//    int inLen;
//    
//    inLen = strlen(p_inBuf);
//    
//    if ((cd = iconv_open(p_OutCode, p_inCode)) == (iconv_t) -1)
//    {
//        return  - 1;
//    }
//    
//    if (iconv(cd, &p_inBuf, (size_t*) &inLen, &p_OutBuf, (size_t*)p_OutSize) ==  (size_t) -1)
//    {
//        iconv_close(cd);
//        return  - 1;
//    }
//    
//    iconv_close(cd);
//    
//    return 0;
//}

string CSystemUtil::getID()
{
    
	string sReturn ="";
    
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    sReturn = [identifierStr UTF8String];
    
	if ( sReturn.length() <= 0 )
	{
		sReturn = "192821387";
	}
    
	
	util::trim(sReturn);
    
    CMD5 md5(sReturn.c_str());
    string sInfo =  md5.get();
	util::upper(sInfo);
	return sInfo;
    
}

void CSystemUtil::setLogType( LogType type)
{
    g_mLogType = type;
}

void CSystemUtil::setLogLevel( LogLevel lvl)
{
    g_mLogLevel = lvl;
}
string& CSystemUtil::toString(string& out,double fv)
{
    
	util::string_format(out,"%.2f",fv);
    
	return out;
}
string& CSystemUtil::toString(string& out,int fv)
{
    
	util::string_format(out,"%d",fv);
	return out;
}

bool CSystemUtil::isIp(const  char*   sp)
{
	char   fst;
	int   sum,num;
	sum=0;
	num=0;
	if   ((fst=*sp)=='.')
		return   0;
    
	while (*sp!='\0')
	{
		if (*sp=='.')
		{
			if   (fst=='0'   &&   sum>0)
				return   0;
			if   (++num>3)
				return   0;
			sum=0;
			if   ((fst=*(sp+1))=='.')
				return   0;
			++sp;
			continue;
		}
		else if(*sp<'0' || *sp>'9')
		{
			return   0;
		}
        
		sum=sum*10+*sp-'0';
		if   (sum>255)
			return   0;
		++sp;
	}
	if   (num!=3 || (fst=='0' && sum>0))
		return   0;
	return   1;
}

//----------------ffffffff

#ifdef PLATFORM_WINDOWS

#include <odbcinst.h>
#include <sqlext.h>


bool CSystemUtil::CheckDSN(const string& strDBName)
{
    
    UWORD fDirection=SQL_FETCH_FIRST;
    SQLCHAR szDSN[SQL_MAX_DSN_LENGTH+1];
    SQLCHAR szDescription[100];
    SQLRETURN retcode;
    SQLHENV henv;
    retcode=SQLAllocHandle(SQL_HANDLE_ENV,SQL_NULL_HANDLE,&henv);
    if(retcode!=SQL_SUCCESS)
        return false;
    retcode=SQLSetEnvAttr(henv,SQL_ATTR_ODBC_VERSION,(SQLPOINTER)SQL_OV_ODBC3,SQL_IS_INTEGER);
    while(retcode==SQL_SUCCESS||retcode==SQL_SUCCESS_WITH_INFO)
    {
        retcode=SQLDataSources(henv,fDirection,(UCHAR*)szDSN,
                               sizeof(szDSN),NULL,(UCHAR*)szDescription,
                               sizeof(szDescription),NULL);
        fDirection=SQL_FETCH_NEXT;
        //if(retcode!=SQL_SUCCESS_WITH_INFO&&retcode!=SQL_SUCCESS)
        {
            //wlog("SQLData Sources retuns:%d",retcode);
            
        }
        //else
        {
            
            
            if ( gstricmp_gu(strDBName.c_str(),(char*)szDSN ) == 0  )
            {
                //wlog("DSN:[%s];Desc:[%s]\r\n",szDSN,strDBName.c_str(),szDescription); ////szDSN即为数据源名称,szDescription为数据源描述
                return true;
            }
        }
        
    }
    
    SQLFreeHandle(SQL_HANDLE_ENV,henv);
    return false;
    
}


/*********************************** Code *************************************/
/*
 Base64是MIME邮件中常用的编码方式之一。它的主要思想是将输入的字符串或数据编码成只含有{'A'-'Z', 'a'-'z', '0'-'9', '+', '/'}
 这64个可打印字符的串，故称为“Base64”。
 
 Base64编码的方法是，将输入数据流每次取6 bit，用此6 bit的值(0-63)作为索引去查表，
 输出相应字符。这样，每3个字节将编码为4个字符(3×8 → 4×6)；不满4个字符的以'='填充。
 */

const char EnBase64Tab[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

int CSystemUtil::encodeBase64(const unsigned char* pSrc, char* pDst, int nSrcLen, int nMaxLineLen)
{
	unsigned char c1, c2, c3; // 输入缓冲区读出3个字节
	int nDstLen = 0; // 输出的字符计数
	int nLineLen = 0; // 输出的行长度计数
	int nDiv = nSrcLen / 3; // 输入数据长度除以3得到的倍数
	int nMod = nSrcLen % 3; // 输入数据长度除以3得到的余数
	char spec = '_';
    
	// 每次取3个字节，编码成4个字符
	for (int i = 0; i < nDiv; i ++)
	{
		// 取3个字节
		c1 = *pSrc++;
		c2 = *pSrc++;
		c3 = *pSrc++;
        
		// 编码成4个字符
		*pDst++ = EnBase64Tab[c1 >> 2];
		*pDst++ = EnBase64Tab[((c1 << 4) | (c2 >> 4)) & 0x3f];
		*pDst++ = EnBase64Tab[((c2 << 2) | (c3 >> 6)) & 0x3f];
		*pDst++ = EnBase64Tab[c3 & 0x3f];
		nLineLen += 4;
		nDstLen += 4;
        
		// 输出换行？
		if (nLineLen > nMaxLineLen - 4)
		{
			*pDst++ = '\r';
			*pDst++ = '\n';
			nLineLen = 0;
			nDstLen += 2;
		}
	}
    
	// 编码余下的字节
	if (nMod == 1)
	{
		c1 = *pSrc++;
		*pDst++ = EnBase64Tab[(c1 & 0xfc) >> 2];
		*pDst++ = EnBase64Tab[((c1 & 0x03) << 4)];
		*pDst++ = spec;
		*pDst++ = spec;
		nLineLen += 4;
		nDstLen += 4;
	}
	else if (nMod == 2)
	{
		c1 = *pSrc++;
		c2 = *pSrc++;
		*pDst++ = EnBase64Tab[(c1 & 0xfc) >> 2];
		*pDst++ = EnBase64Tab[((c1 & 0x03) << 4) | ((c2 & 0xf0) >> 4)];
		*pDst++ = EnBase64Tab[((c2 & 0x0f) << 2)];
		*pDst++ = spec;
		nDstLen += 4;
	}
    
	// 输出加个结束符
	*pDst = '\0';
    
	return nDstLen;
}


/*
 Base64解码方法中，最简单的也是查表法：将64个可打印字符的值作为索引，
 查表得到的值（范围为0-63）依次连起来，
 拼凑成字节形式输出，就得到解码结果。
 */

const char deBase64Tab[] =
{
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	62, // '+'
	0, 0, 0,
	63, // '/'
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, // '0'-'9'
	0, 0, 0, 0, 0, 0, 0,
	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
	13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, // 'A'-'Z'
	0, 0, 0, 0, 0, 0,
	26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
	39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, // 'a'-'z'
};

int CSystemUtil::decodeBase64(const char* pSrc, unsigned char* pDst, int nSrcLen)
{
	int nDstLen; // 输出的字符计数
	int nValue; // 解码用到的长整数
	int i;
	char spec = '_';
    
	i = 0;
	nDstLen = 0;
    
	// 取4个字符，解码到一个长整数，再经过移位得到3个字节
	while (i < nSrcLen)
	{
		if (*pSrc != '\r' && *pSrc!='\n')
		{
			nValue = deBase64Tab[*pSrc++] << 18;
			nValue += deBase64Tab[*pSrc++] << 12;
			*pDst++ = (nValue & 0x00ff0000) >> 16;
			nDstLen++;
            
			if (*pSrc != spec)
			{
				nValue += deBase64Tab[*pSrc++] << 6;
				*pDst++ = (nValue & 0x0000ff00) >> 8;
				nDstLen++;
                
				if (*pSrc != spec)
				{
					nValue += deBase64Tab[*pSrc++];
					*pDst++ =nValue & 0x000000ff;
					nDstLen++;
				}
			}
            
			i += 4;
		}
		else // 回车换行，跳过
		{
			pSrc++;
			i++;
		}
	}
    
	// 输出加个结束符
	*pDst = '\0';
    
	return nDstLen;
}



string CSystemUtil::fromBase64(const string &sql,int type)
{
	string sReturn="";
	if ( sql.length() > 8000 )
	{
		return "";
	}
    
	char buf[10001]={0};
    
	if ( type== 0 )
	{
		string sTmp = sql.c_str();
		util::replace_all(sTmp,"_","=");
		//sTmp.Replace("|","+");
        
		util::replace_all(sTmp,"|","+");
        
        
		util::decodeBase64(sTmp.c_str(),(unsigned char*)buf,(int)sTmp.length());
		//util::DeCode2((char*)sql.c_str(),buf);
	}
	else
	{
		util::decodeBase64(sql.c_str(),(unsigned char*)buf,(int)sql.length());
		//util::DeCode2((char*)sql.c_str(),buf);
	}
    
    
    
	return string(buf);
    
}




string CSystemUtil::toBase64(const string &sql,int type)
{
    
	string sReturn="";
    
    
	char *buf = NULL;
	int size = (int)(sql.length()*(1.6)+80);
    
	buf = new char[size];
	memset(buf,0x00,size);
    
	util::encodeBase64((const unsigned char*)sql.c_str(),buf,(int)sql.length());
    
	//生成压缩
	//util::Encode2((char*)sql.c_str(),buf);
    
    
	string sTmp = buf;
    
	if ( type== 0 )
	{
		util::replace_all(sTmp,"=","_");
		util::replace_all(sTmp,"+","|");
		//sTmp.Replace("=","_");
		//sTmp.Replace("+","|");
	}
    
    
	delete []  buf;
    
	return string(sTmp.c_str());
    
}
bool CSystemUtil::isNatural(const string str)
{
	for(unsigned int i = 0; i < str.length(); i++)
	{
		if ( str[i] == '.' ) continue;
        
		if( str[i] < '0' || str[i] > '9' )
			return false;
	}
	return true;
}
bool CSystemUtil::isNumeric(const string src)
{
	string WithoutSeparator = src;
	//	WithoutSeparator.Replace(".", "");
    
	util::replace_all(WithoutSeparator,".","");
    
    
	// If this number were natural, test it
	// If it is not even a natural number, then it can't be valid
	if( isNatural(WithoutSeparator) == false )
		return false; // Return Invalid Number
    
	// Set a counter to 0 to counter the number of decimal separators
	int NumberOfSeparators = 0;
    
	// Check each charcter in the original string
	for(unsigned int i = 0; i < src.length(); i++)
	{
		// If you find a decimal separator, count it
		if( src[i] == '.' )
			NumberOfSeparators++;
	}
    
	// After checking the string and counting the decimal separators
	// If there is more than one decimal separator,
	// then this cannot be a valid number
	if( NumberOfSeparators > 1 )
		return false; // Return Invalid Number
	else // Otherwise, this appears to be a valid decimal number
		return true;
}

int CSystemUtil::GetODBCDrivers(vector<string> &vs)
{
    vs.clear();
    
    
    char szBuf[2001];
    WORD cbBufMax = 2000;
    WORD cbBufOut;
    char *pszBuf = szBuf;
    //string sDriver;
    
    // 获取已安装驱动的名称(涵数在odbcinst.h里)
    if (!SQLGetInstalledDrivers(szBuf, cbBufMax, &cbBufOut))
        return -1;
    
    // 检索已安装的驱动是否有Excel...
    do
    {
        //if (strstr(pszBuf, "Excel") != 0)
        {
            //发现 !
            //sDriver = pszBuf;
            vs.push_back(pszBuf);
            //break;
        }
        pszBuf = strchr(pszBuf, '\0') + 1;
    }
    while (pszBuf[1] != '\0');
    
    return vs.size();
}


bool CSystemUtil::CheckExistODBCDriver(const char* driver)
{
    
    char szBuf[2001];
    WORD cbBufMax = 2000;
    WORD cbBufOut;
    char *pszBuf = szBuf;
    //string sDriver;
    
    // 获取已安装驱动的名称(涵数在odbcinst.h里)
    if (!SQLGetInstalledDrivers(szBuf, cbBufMax, &cbBufOut))
        return false;
    
    // 检索已安装的驱动是否有Excel...
    do
    {
        if (strstr(pszBuf, driver) != 0)
        {
            
            return true;
            break;
        }
        pszBuf = strchr(pszBuf, '\0') + 1;
    }
    while (pszBuf[1] != '\0');
    
    return false;
}


void CSystemUtil::RemoveDSN(const string& sDB,const string& sDriver)
{
    // TODO: Add your control notification handler code here
    
    
    string szDSN ;
    util::string_format(szDSN,"DSN=%s\0\0",sDB.c_str());
    //::MessageBox(NULL,szDSN.c_str(),"",MB_OK);
    
    SQLRemoveDSNFromIni(sDB.c_str());
    
    // 	BOOL bOK = SQLConfigDataSource(NULL,ODBC_REMOVE_SYS_DSN, sDriver.c_str(),
    // 		szDSN.c_str());
    //
    // 	SQLConfigDataSource(NULL,ODBC_REMOVE_DSN, sDriver.c_str(),
    // 		szDSN.c_str());
    
}

void CSystemUtil::RemoveMdbDsn(const string& sDB)
{
    // TODO: Add your control notification handler code here
    
    
    string szDSN ;
    util::string_format(szDSN,"DSN=%s",sDB.c_str());
    
    SQLConfigDataSource(NULL,ODBC_REMOVE_SYS_DSN, "Microsoft Access Driver (*.mdb)",
                        szDSN.c_str());
    SQLConfigDataSource(NULL,ODBC_REMOVE_DSN, "Microsoft Access Driver (*.mdb)",
                        szDSN.c_str());
    
}

bool CSystemUtil::CreateOracleDsn(const string& sDSN,
                                  const string& sDesc,
                                  const string& sIP,const string& user,const string& pass)
{
    BOOL fResult = FALSE;
    
    // Drop and re-create a Msorcl10.dll (version 1.0) data source.
    if ( CheckDSN(sDSN.c_str()))
    {
        return false;
    }
    
    char szDesc[1024];
    
    
    
    sprintf(szDesc,"DSN=%s?"
            "ConnectString=%s?"
            "Description=%s?"
            "UID=%s?"
            "PWD=%s?",
            sDSN.c_str(),
            sIP.c_str(),
            sDesc.c_str(),
            user.c_str(),pass.c_str());
    
    int mlen;
    mlen = strlen(szDesc);
    
    for (int i=0; i<mlen; i++)
    {
        if (szDesc[i] == '?')
            szDesc[i] = '\0';
    }
    
    if (false == SQLConfigDataSource(NULL,ODBC_ADD_SYS_DSN,"Microsoft ODBC for Oracle",
                                     (LPCSTR)szDesc))
    {
        
        LPVOID lpMsgBuf;
        FormatMessage(
                      FORMAT_MESSAGE_ALLOCATE_BUFFER |
                      FORMAT_MESSAGE_FROM_SYSTEM |
                      FORMAT_MESSAGE_IGNORE_INSERTS,
                      NULL,
                      GetLastError(),
                      MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
                      (LPTSTR) &lpMsgBuf,
                      0,
                      NULL
                      );
        // Process any inserts in lpMsgBuf.
        // ...
        // Display the string.
        //MessageBox( NULL, (LPCTSTR)lpMsgBuf, "Error", MB_OK | MB_ICONINFORMATION );
        // Free the buffer.
        
        
        wlog("SQLData Sources retuns FAILED:%s\n",(LPCTSTR)lpMsgBuf);
        
        LocalFree( lpMsgBuf );
        return false;
        
    }
    
    return true;
    
}


bool CSystemUtil::CreateSQLServerDsn(const string& sDSN,const string& sDesc,const string& sIP,const string& sDB)
{
    char szDesc[1024];
    
    if ( CheckDSN(sDSN.c_str()))
    {
        return false;
    }
    sprintf(szDesc,"DSN=%s?Description=%s?SERVER=%s?DATABASE=%s??",
            sDSN.c_str(),
            sDesc.c_str(),
            sIP.c_str(),
            sDB.c_str());
    
    //wlog("%s\n",szDesc);
    int mlen;
    mlen = strlen(szDesc);
    
    for (int i=0; i<mlen; i++)
    {
        if (szDesc[i] == '?')
            szDesc[i] = '\0';
    }
    
    if (false == SQLConfigDataSource(NULL,ODBC_ADD_SYS_DSN,"SQL Server",
                                     (LPCSTR)szDesc))
    {
        
        LPVOID lpMsgBuf;
        FormatMessage(
                      FORMAT_MESSAGE_ALLOCATE_BUFFER |
                      FORMAT_MESSAGE_FROM_SYSTEM |
                      FORMAT_MESSAGE_IGNORE_INSERTS,
                      NULL,
                      GetLastError(),
                      MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
                      (LPTSTR) &lpMsgBuf,
                      0,
                      NULL
                      );
        // Process any inserts in lpMsgBuf.
        // ...
        // Display the string.
        //MessageBox( NULL, (LPCTSTR)lpMsgBuf, "Error", MB_OK | MB_ICONINFORMATION );
        // Free the buffer.
        
        
        wlog("SQLData Sources retuns FAILED:%s\n",(LPCTSTR)lpMsgBuf);
        
        LocalFree( lpMsgBuf );
        return false;
        
    }
    
    return true;
    
}

bool CSystemUtil::CreateMdbDsn(const string& sDSN,const string& sPath,const string& sDesc)
{
    // TODO: Add your control notification handler code here
    
    char szDesc[512];
    
    if ( CheckDSN(sDSN.c_str()))
    {
        return false;
    }
    
    sprintf(szDesc,"DSN=%s?DBQ=%s?DESCRIPTION=%s?",sDSN.c_str(),sPath.c_str(),sDesc.c_str());
    
    int mlen;
    mlen = strlen(szDesc);
    
    for (int i=0; i<mlen; i++)
    {
        if (szDesc[i] == '?')
            szDesc[i] = '\0';
    }
    
    if (false == SQLConfigDataSource(NULL,ODBC_ADD_SYS_DSN,"Microsoft Access Driver (*.mdb)\0",
                                     (LPCSTR)szDesc))
    {
        return false;
        
    }
    return true;
}



int CSystemUtil::GetDSN(vector<string> &vs)
{
    
    //MStringArray v_s;
    UWORD fDirection=SQL_FETCH_FIRST;
    SQLCHAR szDSN[SQL_MAX_DSN_LENGTH+1];
    SQLCHAR szDescription[100];
    SQLRETURN retcode;
    SQLHENV henv;
    retcode=SQLAllocHandle(SQL_HANDLE_ENV,SQL_NULL_HANDLE,&henv);
    if(retcode!=SQL_SUCCESS)
        return false;
    retcode=SQLSetEnvAttr(henv,SQL_ATTR_ODBC_VERSION,(SQLPOINTER)SQL_OV_ODBC3,SQL_IS_INTEGER);
    while(retcode==SQL_SUCCESS || retcode==SQL_SUCCESS_WITH_INFO)
    {
        retcode=SQLDataSources(henv,fDirection,(UCHAR*)szDSN,
                               sizeof(szDSN),NULL,(UCHAR*)szDescription,
                               sizeof(szDescription),NULL);
        fDirection=SQL_FETCH_NEXT;
        
        {
            //TRACE("DSN:[%s]Desc:[%s]\r\n",szDSN,szDescription); ////szDSN即为数据源名称,szDescription为数据源描述
            
            
            //check exis
            BOOL bFind = FALSE;
            for(unsigned int i=0; i<vs.size(); i++)
            {
                if ( gstricmp_gu(vs[i].c_str(),(char*)szDSN) == 0 )
                {
                    bFind = TRUE;
                    break;
                }
                
            }
            if ( !bFind )
                vs.push_back((char*)szDSN);
        }
        
    }
    
    SQLFreeHandle(SQL_HANDLE_ENV,henv);
    return vs.size();
    
}



#endif //USE_ODBC_CREATE


std::string& CSystemUtil::getFileNameFromDir(const std::string& inFile,
                                             std::string& sSaveFile)
{
    //确定文件名入口文件的文件名
    sSaveFile = inFile;
    if ( inFile.length() <= 0 ) return sSaveFile;
    
    if ( (inFile.find("\\") != std::string::npos) ||
        (inFile.find("/") != std::string::npos) )
    {
        std::vector<std::string> vs;
        util::splitString(inFile,vs,"\\/");
        
        
        if ( vs.size() >=2 )
        {
            sSaveFile = vs[vs.size()-1];
        }
        else
        {
            sSaveFile = inFile;
        }
        if ( sSaveFile.length() <=0  )
        {
            return sSaveFile;
        }
        return sSaveFile;
        
    }
    
    sSaveFile = inFile;
    return sSaveFile;
}

CSystemUtil::CSystemUtil()
{
    
    
}



/*!去掉右边的指定字符*/
std::string& CSystemUtil::trim_right (std::string & s, const std::string & t)
{
    std::string::size_type i (s.find_last_not_of (t));
    if (i == std::string::npos)
        return s;
    else
        return s.erase (s.find_last_not_of (t) + 1) ;
}  // end of trim_right

/*!去掉左边的指定字符*/
std::string& CSystemUtil::trim_left (std::string & s, const std::string & t)
{
    return s.erase (0, s.find_first_not_of (t)) ;
}  // end of trim_left

/*!去掉两边的指定字符*/
std::string& CSystemUtil::trim (std::string & s, const std::string & t)
{
    return trim_left (trim_right (s, t), t) ;
}  // end of trim

/*! newvalue替换字符串中所有old_value的值 */
std::string&  CSystemUtil::replace_all(std::string&   str,const   std::string&   old_value,const   std::string&   new_value)
{
    while(true)
    {
        std::string::size_type   pos(0);
        if(   (pos=str.find(old_value))!=std::string::npos   )
            str.replace(pos,old_value.length(),new_value);
        else   break;
    }
    return   str;
}
int CSystemUtil::write2File(void* pValues,int iSize,const string& sFile)
{
	FILE * fp = fopen(sFile.c_str(),"wb");
    
	if ( fp == NULL ) return -1;
    
	unsigned long iz = fwrite(pValues,sizeof(char),iSize,fp);
    
	fclose(fp);
    
	return static_cast<int>(iz);
    
    
}
string& CSystemUtil::getFilePath(const string& sFile,string& sOutPath)
{
    
	sOutPath = "";
    
	if ( sFile.length() <= 1 ) return sOutPath;
    
    
	vector<string> vs;
	util::splitString(sFile,vs,"/\\");
    
    
    
	if ( vs.size() >= 1 )
	{
		if ( vs[vs.size()-1].length() <= 0 ) return sOutPath;
        
		string s =  vs[vs.size()-1];
        
		sOutPath =  sFile.substr(0,sFile.length()-s.length());
        
	}
	return sOutPath;
}

string& CSystemUtil::getFileName(const string& sInFile,string& sFile)
{
    
	sFile = "";
    
	if ( sInFile.length() <= 1 ) return sFile;
    
    
	vector<string> vs;
	util::splitString(sInFile,vs,"/\\");
    
    
    
	if ( vs.size() >= 1 )
	{
		if ( vs[vs.size()-1].length() <= 0 ) return sFile;
        
		sFile =  vs[vs.size()-1];
	}
	return sFile;
}
/** 字符串分隔*/
int   CSystemUtil::splitString(
                               const std::string& src,
                               std::vector<std::string>& vs,
                               const std::string tok,
                               bool trim,
                               std::string null_subst)
{
    
    if( src.empty() || tok.empty() )
    {
        return 0;
    }
    std::basic_string<char>::size_type pre_index = 0, index = 0, len = 0;
    while( (index = src.find_first_of(tok, pre_index)) !=  -1 )
    {
        if( (len = index-pre_index)!=0 )
        {
            vs.push_back(src.substr(pre_index, len));
        }
        else if(trim==false)
            vs.push_back(null_subst);
        pre_index = index+1;
    }
    std::string endstr = src.substr(pre_index);
    if( trim==false )
        vs.push_back( endstr.empty()? null_subst:endstr);
    else if( !endstr.empty() )
        vs.push_back(endstr);
    return (int)vs.size();
}
/******************************************************************************/

std::string& CSystemUtil::left(const std::string& str,int size,string& out)
{
    if ( size <= 0 )
    {
        out="";
        return out;
    }
    
    
    if ( str.length() <= (unsigned int) size )
    {
        out = str;
    }
    else
    {
        out  = str.substr(0,size);
    }
    return out;
}

std::string& CSystemUtil::right(const std::string& str,int size,string& out)
{
    if ( size <= 0 )
    {
        out="";
        return out;
    }
    
    
    if ( str.length() <= (unsigned int)size )
    {
        out = str;
    }
    else
    {
        out  = str.substr(str.length()-size,str.length());
    }
    return out;
}
std::string& CSystemUtil::getFillString(const string& src,unsigned int iLen,string& sDest,bool bRight,char cFill)
{
    
    
	
    
	if ( bRight )
	{
		sDest = src;
		for (unsigned long i = src.length(); i <iLen ; ++i)
		{
			sDest += cFill;
		}
	}
	else
	{
		sDest = "";
		for (unsigned int i = 0; i < iLen-src.length() ; ++i)
		{
			sDest += cFill;
		}
		sDest += src;
	}
	return sDest;
    
}
/*!返回指定长度的随机字符串*/
std::string& CSystemUtil::getRandString(int len,std::string& out)
{
    
    static int g_seq_cur=0;
    char CCH[] = "_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";
    srand((unsigned)time(NULL));
    
    
    char ch[100] = {0};
    
    for (int i = 0; i < len; ++i)
    {
		int x = ::rand() % (sizeof(CCH) - 1);
        
        ch[i] = CCH[x];
    }
    
    
    //std::string sReturn ="";
    string_format(out,"%s%06d",ch,g_seq_cur);
    
    
    
    g_seq_cur++;
    
    if ( g_seq_cur >=  999999 )
        g_seq_cur = 0;
    
    return out;
    
}

#define  MYLONG64  long long

string&	CSystemUtil::getRandID(std::string& out)
{
    //static const	short len = 21;
    char cTemp[400];
    static char	seed[]="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    
    MYLONG64 v;
    
    time_t tm;
    time(&tm);
    v = tm;
    
    for(int i=7; i>0; i--)
    {
        cTemp[i] =seed[(int)(v%36)];
        v = v/36;
    }
    cTemp[0] = seed[(int)(v%26) + 10]; //确保第一个随机字符是"字母", 以符合一般编程的标识符定义
    
    string sUUID;
#ifdef USE_ICE
    CICEBaseDBUtil::getUUID(sUUID);
    util::replace_all(sUUID,"-","");
#else
    util::getRandString(32, sUUID);
#endif
    
    char u[40]= {0};
    strcpy(u,sUUID.c_str());
    //UUID *u=new UUID;
    //UuidCreate(u);
    char pl[8];
    char pm[8];
    char temp[16];
    memset(pl,0,8);
    memset(pm,0,8);
    memset(temp,0,16);
    
    memcpy(temp,u,16);
    memcpy(pm,temp,8);
    memcpy(pl,(char*)sUUID.substr(16,8).c_str(),8);
    for (int i=0; i<8; i++)
    {
        pl[i]=pl[i]^pm[i];
    }
    MYLONG64 *a;
    a=(MYLONG64 *)pl;
    v=*a;
    if (v<0)
    {
        v=-v;
    }
    for(int i=8; i<20; i++)
    {
        cTemp[i] = seed[(int)(v%36)];
        v= v/36;
    }
    cTemp[20]='\0';
    
    
    out = cTemp;
    
    return out;
}

/*! 输助输出vector<string> */
void CSystemUtil::dumpVectorString(std::vector<std::string> & v)
{
    for (unsigned int i=0; i<v.size(); i++)
    {
        wlog("%s\n",v[i].c_str());
    }
}
std::string& CSystemUtil::string_format(std::string& str, const char * sFormat, ...)
{
    
    va_list arglist;
    va_start(arglist, sFormat);
    int size = _vsnprintf(NULL, 0, sFormat, arglist)+2;
    
    char * s = new char[size];
    
    size = _vsnprintf(s, size, sFormat, arglist);
    
    va_end(arglist);
    
    str = s;
    
    delete [] s;
    s = NULL;
    
    return str;
}
/** 去掉字符串开始与结束的特定字符
 *  @param[in] 输入源char*字符串
 *  @param[in] 去掉的字符,如'|',默认为' '
 *  @return 没有返回值
 */
void CSystemUtil::allTrim(char *src,char sep)
{
    int i, iFirschar_t, iEndPos, iFirstPos;
    
    if ( src == NULL ) return ;
    
    iEndPos = iFirschar_t = iFirstPos = 0;
    for (i = 0 ; src[i] != '\0'; i++)
    {
        if( iFirschar_t == 0 )
        {
            if( src[i] != sep )
            {
                src[0] = src[i];
                iFirschar_t = 1;
                iEndPos = iFirstPos;
            }
            else
                iFirstPos++;
        }
        else
        {
            if( src[i] != sep)
                iEndPos = i;
            src[i-iFirstPos] = src[i];
        }
    }
    if( iFirschar_t == 0 )
        src[0] = '\0';
    else
        src[iEndPos-iFirstPos+1]='\0';
}

/** 去掉字符串开始与结束的特定字符
 *  @param[in] 输入string源字符串
 *  @param[in] 去掉的字符,如'|'默认为' '
 *  @return 没有返回值
 */

char* CSystemUtil::upper(char *src)
{
    if ( src == NULL ) return src;
    
    int i  ;
    unsigned long iLen = strlen(src);
    char *cTemp = new char[iLen+1];
    strcpy(cTemp,src);
    for (i = 0 ; cTemp[i] != '\0'; i++)
    {
        if( cTemp[i] >= 'a' && cTemp[i] <= 'z'  )	{
            cTemp[i] = ( (int)cTemp[i] - 32 );
            
        }
    }
    strcpy(src,cTemp);
    
    delete [] cTemp;
    
    return src;
    
}
std::string& CSystemUtil::upper(std::string& src)
{
    transform (src.begin (), src.end (), src.begin (), (int(*)(int)) toupper);
    //boost::to_upper(src);
    return src;
}

/** 字符串转成小写
 *  @param[in] char 输入字符串
 *  @param[out] buffer 用于存放读取的文件内容
 *  @param[in] len 需要读取的文件长度
 *  @return 返回传入的字符串地址
 */
char* CSystemUtil::lower(char *src)
{
    if ( src == NULL ) return src;
    
    int i  ;
    unsigned long iLen = strlen(src);
    
    char *cTemp = new char[iLen+1];
    memset(cTemp,0x00,iLen+1);
    
    strcpy(cTemp,src);
    for (i = 0 ; cTemp[i] != '\0'; i++)
    {
        if( cTemp[i] >= 'A' && cTemp[i] <= 'Z'  )	{
            cTemp[i] = ( (int)cTemp[i] + 32 );
            
        }
    }
    strcpy(src,cTemp);
    
    delete [] cTemp;
    return src;
    
}
std::string& CSystemUtil::lower(std::string& src)
{
    
    transform (src.begin (), src.end (), src.begin (), (int(*)(int)) tolower);
    //boost::to_lower(src);
    return src;
}


void CSystemUtil::Sleep(int millSec)
{
#ifdef PLATFORM_WINDOWS
    ::Sleep(millSec);
#else
    struct timeval timeout ;
    
    timeout.tv_sec = 0; /*连接超时15秒*/
    timeout.tv_usec =millSec*1000;
    select(0, 0, 0, 0, &timeout);
#endif
    
    return;
}




/** 系统时间获取
 *  @return 格式形如"2006-09-10 12:12:21" 字符串
 */
std::string& CSystemUtil::getSys14Time(std::string& out)
{
    char ResultStr[40];
    
    time_t	Now;
    struct	tm   *sNow;
    
    Now=time(NULL);
    sNow=localtime(&Now);
    sprintf(ResultStr,"%04d-%02d-%02d %02d:%02d:%02d",
            sNow->tm_year+1900,sNow->tm_mon+1,sNow->tm_mday,
            sNow->tm_hour,sNow->tm_min,sNow->tm_sec);
    
    out =  ResultStr;
    
    return out;
}

/** 系统时间获取
 *  @return 格式形如"20060910121221" 字符串
 */
std::string& CSystemUtil::getSys14Time2(std::string& out)
{
    char ResultStr[40];
    
    time_t	Now;
    struct	tm   *sNow;
    
    Now=time(NULL);
    sNow=localtime(&Now);
    sprintf(ResultStr,"%04d%02d%02d%02d%02d%02d",
            sNow->tm_year+1900,sNow->tm_mon+1,sNow->tm_mday,
            sNow->tm_hour,sNow->tm_min,sNow->tm_sec);
    
    out = ResultStr;
    return out;
}
/** 系统时间获取
 *  @return 格式形如"2006-09-10" 字符串
 */
std::string& CSystemUtil::getSys8Time(std::string& out)
{
    char ResultStr[40];
    
    time_t	Now;
    struct	tm   *sNow;
    
    Now=time(NULL);
    sNow=localtime(&Now);
    sprintf(ResultStr,"%04d-%02d-%02d",
            sNow->tm_year+1900,sNow->tm_mon+1,sNow->tm_mday);
    
    out = ResultStr;
    
    return out;
}

string& CSystemUtil::getExePath(std::string& out,int type, const char *argv0)
{
    
    
    out = "";
    return out;
    
}

char *CSystemUtil::dirname(char *buf, char *name, int bufsize)
{
    char *cp;
    int		len;
    
    
#if (defined (WIN) || defined (NW))
    if ((cp = strrchr(name, '/')) == NULL &&
        (cp = strrchr(name, '\\')) == NULL)
#else
        if ((cp = strrchr(name, '/')) == NULL)
#endif
        {
            strcpy(buf, ".");
            return buf;
        }
    
    if ((*(cp + 1) == '\0' && cp == name)) {
        strncpy(buf, ".", (sizeof(bufsize) / sizeof(char)));
        strcpy(buf, ".");
        return buf;
    }
    
    len = (int)(cp - name);
    
    if (len < bufsize) {
        strncpy(buf, name, len);
        buf[len] = '\0';
    } else {
        strncpy(buf, name, (sizeof(bufsize) / sizeof(char)));
        buf[bufsize - 1] = '\0';
    }
    
    return buf;
}


/** 将字符串分解成整数
 *  格式形如"20060910121221 或 2006-09-10 12:12:21 " 字符串
 */
bool CSystemUtil::parseDate(char *sTime,CEDateTime &dt)
{
    int year,month,day,minute,second,hour;
    
    if ( !parseDate(sTime,year,month,day,hour,minute,second) ) return false;
    
    dt.m_iYear = year;
    dt.m_iMonth = month;
    dt.m_iDay = day;
    dt.m_iHour = hour;
    dt.m_iMinute = minute;
    dt.m_iSecond = second;
    
    
    return true;
    
}
bool CSystemUtil::parseDate(char *sTime,int &year,int &month,int &day,int &hour,int &minute,int &second)
{
    if ( sTime == NULL ) return false;
    
    size_t iLen = strlen(sTime) ;
    
    if ( iLen <= 0 ) return false;
    
    /** 0=yyyy-mm-dd hh:mi:ss,1=yyyymmddhh24miss */
    
    if ( strstr(sTime,"-") == NULL )
    {
        
        year=month=day=hour=minute=0;
        if ( iLen == 4)  //mean 2006
        {
            year = atoi(sTime);
            month = 1;
            day = 1;
            
            return true;
        }
        
        if ( iLen == 6 ) //mean 200605
        {
            sscanf(sTime,"%04d%02d",&year,&month);
            day = 1;
            return true;
        }
        
        if ( iLen == 8 ) //mean 20060501
        {
            sscanf(sTime,"%04d%02d%02d",&year,&month,&day);
            return true;
        }
        if ( iLen == 10 ) //mean 2006050103
        {
            sscanf(sTime,"%04d%02d%02d%02d",&year,&month,&day,&hour);
            return true;
        }
        if ( iLen == 12 ) //mean 2006050103
        {
            sscanf(sTime,"%04d%02d%02d%02d%02d",&year,&month,&day,&hour,&minute);
            return true;
        }
        if ( iLen == 14 ) //mean 200605010309
        {
            sscanf(sTime,"%04d%02d%02d%02d%02d%02d",&year,&month,&day,&hour,&minute,&second);
            return true;
        }
    }
    
    if ( strstr(sTime,"-") != NULL )
    {
        
        year=month=day=hour=minute=0;
        if ( iLen == 4)  //mean 2006
        {
            year = atoi(sTime);
            month = 1;
            day = 1;
            return true;
        }
        
        if ( iLen == 7 ) //mean 2006-05
        {
            sscanf(sTime,"%04d-%02d",&year,&month);
            day = 1;
            return true;
        }
        
        if ( iLen == 10 ) //mean 2006-05-01
        {
            sscanf(sTime,"%04d-%02d-%02d",&year,&month,&day);
            return true;
        }
        if ( iLen == 13 ) //mean 2006-05-01 03
        {
            sscanf(sTime,"%04d-%02d-%02d %02d",&year,&month,&day,&hour);
            return true;
        }
        if ( iLen == 16 ) //mean 2006-05-01 03:01
        {
            sscanf(sTime,"%04d-%02d-%02d %02d:%02d",&year,&month,&day,&hour,&minute);
            return true;
        }
        if ( iLen == 19 ) //mean 2006-05-01 03:01:01
        {
            sscanf(sTime,"%04d-%02d-%02d %02d:%02d:%02d",&year,&month,&day,&hour,&minute,&second);
            return true;
        }
        
    }
    
    return false;
}




/** 读取指定的文件一行文本
 *  @param[in]  	文件名柄FILE*
 *  @param[out]  	返回的字符串
 *  @param[in]  	每行最大字符数量
 *  @return 返回当前读的字符数
 */
int  CSystemUtil::fgetline(FILE *fp, char *buffer, int maxlen)
{
    int  i, j;
    char ch1;
    
    for(i = 0, j = 0; i < maxlen; j++)
    {
        if(fread(&ch1, sizeof(char), 1, fp) != 1)
        {
            if(feof(fp) != 0)
            {
                if(j == 0) return -1;               /* EOF */
                else break;
            }
            if(ferror(fp) != 0) return -2;        /* error */
            return -2;
        }
        else
        {
            if(ch1 == '\n' || ch1 == 0x00 )
                break; /* end of line */
            if(ch1 == '\f' || ch1 == 0x1A)        /* '\f': Form Feed */
            {
                buffer[i++] = ch1;
                break;
            }
            if(ch1 != '\r') buffer[i++] = ch1;    /* ignore CR */
        }
    }
    buffer[i] = '\0';
    return i;
    
}


/** 读取指定的文件所有文本内容至字符串中
 *  @param[in]  	文件名*
 *  @return 返回字符串
 */
std::string&  CSystemUtil::readFileAsString(char *file,std::string& sReturn,int maxLine)
{
    //std::string sReturn;
    sReturn = "";
    char buf[8001];
    int icnt = 0;
    
    FILE *fp = fopen(file,"r");
    memset(buf,0x00,8001);
    
    if ( fp == NULL )
    {
        return  sReturn;
    }
    
    while ( fgetline(fp,buf,8000) != EOF )
    {
        sReturn += buf;
        sReturn += "\n";
        
        icnt++;
        
        if ( icnt >= maxLine ) break;
        
    }
    if ( fp != NULL )
        fclose(fp);
    return sReturn;
    
}
/** 获取文件大小 */
int	CSystemUtil::fileSize(char* file)
{
    FILE *fp = fopen(file,"r");
    
    if ( fp == NULL )
    {
        return -1;
    }
    
    fseek(fp, 0L, SEEK_END);
    //定位在文件开头处
    long size = ftell(fp);
    
    if ( fp != NULL )
    {
        fclose(fp);
    }
    
    return static_cast<int>(size);
}
/** 文件是否存在 */
bool CSystemUtil::isFileExist(char* file)
{
    FILE *fp = fopen(file,"r");
    
    if ( fp == NULL ) return false;
    
    fclose(fp);
    
    return true;
}

/** 是否是闰年*/
bool  CSystemUtil::isLeapYear(int   iYear)
{
    return   ((iYear % 4)  == 0) && (((iYear   %   100) != 0) || ((iYear   %   400)   ==   0));
}

/** 取得某个月份的天数。*/
int   CSystemUtil::daysPerMonth(int  iYear,int  iMonth)
{
    int   DaysInMonth[12]=  {31, 28,31,30,31,30,31,31,30, 31,30,31};
    int   iDays;
    
    if ((iMonth == 2)  &&  isLeapYear(iYear))    /*闰年的2月有29天*/
        iDays = 29;
    else
        iDays = DaysInMonth[iMonth   -   1];
    
    return   iDays;
}

/*按当前时间下idx个月，如果idx>0则代表后idx月,以后建议统一使用下列两个函数*/
void CSystemUtil::nextMonth(int year,int month,int idx,int &yearOut,int &monthOut)
{
    if ( idx == 0 )
    {
        yearOut = year;
        monthOut = month;
        return;
    }
    
    //    int icurIdx = idx;
    int yearIn = year;
    int monthIn = month;
    
    bool bNext = false;
    
    if ( idx >= 0  )
        bNext = true;
    
    for (int i=0; i<abs(idx); i++)
    {
        if ( bNext )
        {
            nextMonth(yearIn,monthIn,yearIn,monthIn);
        }
        else
        {
            preMonth(yearIn,monthIn,yearIn,monthIn);
        }
        
    }
    
    yearOut = yearIn;
    monthOut = monthIn;
}

/*按当前时间下idx个日，如果idx>0则代表后idx日 */
bool CSystemUtil::nextDay(int year,int month,int day,int idx,int &yearOut,int &monthOut,int &dayOut)
{
    if ( idx == 0 )
    {
        yearOut = year;
        monthOut = month;
        dayOut = day;
        return false;
    }
    
    //    int icurIdx = idx;
    int yearIn = year;
    int monthIn = month;
    int dayIn = day;
    
    bool bNext = false;
    
    if ( idx >= 0  )
        bNext = true;
    
    for (int i=0; i<abs(idx); i++)
    {
        if ( bNext )
        {
            nextDay(yearIn,monthIn,dayIn,yearIn,monthIn,dayIn);
        }
        else
        {
            preDay(yearIn,monthIn,dayIn,yearIn,monthIn,dayIn);
        }
        
    }
    
    yearOut = yearIn;
    monthOut = monthIn;
    dayOut = dayIn;
    
    return true;
}


/*按当前时间下idx个小时，如果idx>0则代表后idx小时 */
bool CSystemUtil::nextHour(int year,int month,int day,int hour,
                           int &yearOut,int &monthOut,int &dayOut,int &hourOut)
{
    
    yearOut = year;
    monthOut = month;
    dayOut = day;
    hourOut = hour;
    
    
    int iCurMonDays = daysPerMonth(year,month);
    
    if ( ( year <= 100 ) || month> 12 || month <= 0 || day > 31 || day<=0 )
        return false;
    
    if ( iCurMonDays < day ) return false;
    
    
    if ( hour > 23 )
    {
        hour = 23;
    }
    if ( hour == 23 )
    {
        nextDay(year,month,day,yearOut,monthOut,dayOut);
        hourOut = 0;
    }
    else
    {
        hourOut = hour+1;
    }
    
    return true;
}
//void setLogType(LogType type)
//{
//	m_mLogType = type;
//}
////bool setLogFile(char* sFile)
////{
////	m_sLogFile = sFile;
////}
//void setLogLevel(LogLevel level)
//{
//	m_mLogLevel = level;
//}
/** Log 辅助功能,通过默认文件
 *  @param[in]  	文件名柄(FILE*)
 *  @param[in]  	格式串
 *  @param[in]  	...
 *  @return 没有返回值
 */
void CSystemUtil::writelog(const char* msg,...)
{
    //if ( m_mLogType == LOG_NULL ) return;
    
    static FILE*	m_fLogfp;
    
    va_list arg_ptr;
    
    
    
    va_start(arg_ptr, msg);
    
    //log  file
    if ( m_fLogfp == NULL)
    {
        std::string sExePath,sExeName;
        char sPath[256]= {0};
        
        
        sprintf(sPath,"%s\\%s.log",getExePath(sExePath).c_str(),getExePath(sExeName,3).c_str());
        m_fLogfp = fopen(sPath,"a+");
    }
    
    if ( g_mLogType == LOG_FILE || g_mLogType == LOG_FULL)
    {
        if ( m_fLogfp != NULL)
        {
            
            vfprintf(m_fLogfp, msg, arg_ptr);
            fflush(m_fLogfp);
        }
    }
    
    
    if ( g_mLogType == LOG_CONSOLE || g_mLogType == LOG_FULL )
    {
        vfprintf(stdout, msg, arg_ptr);
        va_end(arg_ptr);
    }
}


/** 这一些函数将来将不使用*/
bool CSystemUtil::nextDay(int year,int month,int day,
                          int &yearOut,int &monthOut,int &dayOut)
{
    
    int tmpYear = year;
    int tmpMonth = month;
    int tmpDay = day;
    
    yearOut = tmpYear;
    monthOut = tmpMonth;
    dayOut = tmpDay;
    
    int iCurMonDays = daysPerMonth(tmpYear,tmpMonth);
    
    if ( ( tmpYear <= 100 ) || tmpMonth> 12 || tmpMonth <= 0 || tmpDay > 31 || tmpDay<=0 )
        return false;
    
    if ( iCurMonDays < tmpDay ) return false;
    
    if ( iCurMonDays  == tmpDay )
    {
        nextMonth(tmpYear,tmpMonth,yearOut,monthOut);
        dayOut = 1;
    }
    else
    {
        
        yearOut = tmpYear;
        monthOut = tmpMonth;
        dayOut = tmpDay+1;
        
    }
    return true;
}
void CSystemUtil::nextMonth(int year,int month,int &yearOut,int &monthOut)
{
    int tmpYear = year;
    int tmpMonth = month;
    
    yearOut = tmpYear;
    monthOut = tmpMonth;
    monthOut++;
    if (monthOut > 12)
    {
        yearOut++;
        monthOut = 1;
    }
}
void CSystemUtil::preMonth(int year,int month,int &yearOut,int &monthOut)
{
    int tmpYear = year;
    int tmpMonth = month;
    
    
    yearOut = tmpYear;
    monthOut = tmpMonth;
    
    monthOut--;
    if (monthOut == 0)
    {
        yearOut--;
        monthOut = 12;
    }
}

void CSystemUtil::preDay(int year,int month,int day,int &yearOut,int &monthOut,int &dayOut)
{
    int tmpYear = year;
    int tmpMonth = month;
    int tmpDay = day;
    
    yearOut = tmpYear;
    monthOut = tmpMonth;
    dayOut = tmpDay;
    
    int iCurMonDays = daysPerMonth(tmpYear,tmpMonth);
    
    if ( ( tmpYear <= 100 ) || tmpMonth> 12 || tmpMonth <= 0 || tmpDay > 31 || tmpDay<=0 )
        return ;
    
    if ( iCurMonDays < tmpDay ) return ;
    
    if ( tmpDay  == 1 )
    {
        preMonth(tmpYear,tmpMonth,yearOut,monthOut);
        
        dayOut = daysPerMonth(yearOut,monthOut);
    }
    else
    {
        
        yearOut = tmpYear;
        monthOut = tmpMonth;
        dayOut = tmpDay-1;
        
    }
    return ;
}

/*** iCE PART START*/


/*ICE Part */

#ifdef USE_ICE


#include <Ice/Ice.h>
#include <mq_interface.h>

class CAsyncSelect : public MQServerModule::AMI_MQInterface_select
{
public:
    CAsyncSelect()
    {
        //m_vLock = PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
        //m_condition = PTHREAD_COND_INITIALIZER;
        //m_event = CreateEvent (0, TRUE, FALSE, 0);
        m_bFinished = false;
        
		m_bTimeoutFromClient = false;
        m_pCond = NULL;
    }
    
    virtual void ice_response(int ic,const string& outinfo,const string& error)
    {
        
		if ( m_bTimeoutFromClient ) return;
        
        if (  m_pErrror )
        {
            
            if ( m_pOutInfo )
            {
                (*m_ic) = ic;
                (*m_pErrror) = error;
                (*m_pOutInfo) = outinfo;
            }
        }
        
        
        //Sleep(3000);
        m_bFinished  = true;
        //std::cout << "in----wait finished" << std::endl;
        pthread_cond_signal(m_pCond); /*等待*/
        
        //SetEvent(m_event);
    }
    virtual void ice_exception()
    {
		if ( m_bTimeoutFromClient ) return;
        
        util::string_format((*m_pErrror), "查询出现未知网络异常");
        if ( m_pOutInfo )
        {
            (*m_ic) = -1;
            //(*m_pErrror) = "CAsyncSelect AMI call failed";
            (*m_pOutInfo) = "";
        }
        m_bFinished  = true;
        pthread_cond_signal(m_pCond); /*等待*/
        
    }
    
    virtual void ice_exception(const Ice::Exception& ex)
    {
		if ( m_bTimeoutFromClient ) return;
        
        util::string_format((*m_pErrror), "查询出现未知网络失败:%s",ex.what());
        if ( m_pOutInfo )
        {
            (*m_ic) = -1;
            //(*m_pErrror) = "CAsyncSelect AMI call failed";
            (*m_pOutInfo) = "";
        }
        m_bFinished  = true;
        pthread_cond_signal(m_pCond); /*等待*/
        
        
    }
    
    void setReturnP(pthread_cond_t* pCond,int* ic,string* outinfo,string* error)
    {
        m_ic = ic;
        m_pOutInfo = outinfo;
        m_pErrror = error;
        m_pCond = pCond;
    }
    bool isFinished()
    {
        
        return m_bFinished;
    }
	bool m_bTimeoutFromClient; //如果是客户端超时走了
    
    //HANDLE m_event;
private:
    
	
    
    pthread_cond_t *m_pCond;
    
    bool m_bFinished;
    int* m_ic;
    string* m_pOutInfo;
    string* m_pErrror;
    
};


class CAsyncExecCmd : public MQServerModule::AMI_MQInterface_execCmd
{
public:
	CAsyncExecCmd()
	{
		//m_vLock = PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
		//m_condition = PTHREAD_COND_INITIALIZER;
		//m_event = CreateEvent (0, TRUE, FALSE, 0);
		m_bFinished = false;
        
		m_bTimeoutFromClient = false;
		m_pCond = NULL;
	}
    
	virtual void ice_response(int ic, const string& outinfo, const string& error)
	{
        
		if (m_bTimeoutFromClient) return;
        
		if (m_pErrror)
		{
            
			if (m_pOutInfo)
			{
				(*m_ic) = ic;
				(*m_pErrror) = error;
				(*m_pOutInfo) = outinfo;
			}
		}
        
        
		//Sleep(3000);
		m_bFinished = true;
		//std::cout << "in----wait finished" << std::endl;
		pthread_cond_signal(m_pCond); /*等待*/
        
		//SetEvent(m_event);
	}
	virtual void ice_exception()
	{
		if (m_bTimeoutFromClient) return;
        
		util::string_format((*m_pErrror), "execCmd出现未知网络异常");
		if (m_pOutInfo)
		{
			(*m_ic) = -1;
			//(*m_pErrror) = "CAsyncSelect AMI call failed";
			(*m_pOutInfo) = "";
		}
		m_bFinished = true;
		pthread_cond_signal(m_pCond); /*等待*/
        
	}
    
	virtual void ice_exception(const Ice::Exception& ex)
	{
		if (m_bTimeoutFromClient) return;
        
		util::string_format((*m_pErrror), "execCmd出现未知网络失败:%s", ex.what());
		if (m_pOutInfo)
		{
			(*m_ic) = -1;
			//(*m_pErrror) = "CAsyncSelect AMI call failed";
			(*m_pOutInfo) = "";
		}
		m_bFinished = true;
		pthread_cond_signal(m_pCond); /*等待*/
        
        
	}
    
	void setReturnP(pthread_cond_t* pCond, int* ic, string* outinfo, string* error)
	{
		m_ic = ic;
		m_pOutInfo = outinfo;
		m_pErrror = error;
		m_pCond = pCond;
	}
	bool isFinished()
	{
        
		return m_bFinished;
	}
	bool m_bTimeoutFromClient; //如果是客户端超时走了
    
	//HANDLE m_event;
private:
    
    
    
	pthread_cond_t *m_pCond;
    
	bool m_bFinished;
	int* m_ic;
	string* m_pOutInfo;
	string* m_pErrror;
    
};


class CAsyncSelectCmd : public MQServerModule::AMI_MQInterface_selectCmd
{
public:
	CAsyncSelectCmd()
	{
		//m_vLock = PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
		//m_condition = PTHREAD_COND_INITIALIZER;
		//m_event = CreateEvent (0, TRUE, FALSE, 0);
		m_bFinished = false;
        
		m_bTimeoutFromClient = false;
		m_pCond = NULL;
	}
    
	virtual void ice_response(int ic, const string& outinfo, const string& error)
	{
        
		if (m_bTimeoutFromClient) return;
        
		if (m_pErrror)
		{
            
			if (m_pOutInfo)
			{
				(*m_ic) = ic;
				(*m_pErrror) = error;
				(*m_pOutInfo) = outinfo;
			}
		}
        
        
		//Sleep(3000);
		m_bFinished = true;
		//std::cout << "in----wait finished" << std::endl;
		pthread_cond_signal(m_pCond); /*等待*/
        
		//SetEvent(m_event);
	}
	virtual void ice_exception()
	{
		if (m_bTimeoutFromClient) return;
        
		util::string_format((*m_pErrror), "查询出现未知网络异常");
		if (m_pOutInfo)
		{
			(*m_ic) = -1;
			//(*m_pErrror) = "CAsyncSelect AMI call failed";
			(*m_pOutInfo) = "";
		}
		m_bFinished = true;
		pthread_cond_signal(m_pCond); /*等待*/
        
	}
    
	virtual void ice_exception(const Ice::Exception& ex)
	{
		if (m_bTimeoutFromClient) return;
        
		util::string_format((*m_pErrror), "查询出现未知网络失败:%s", ex.what());
		if (m_pOutInfo)
		{
			(*m_ic) = -1;
			//(*m_pErrror) = "CAsyncSelect AMI call failed";
			(*m_pOutInfo) = "";
		}
		m_bFinished = true;
		pthread_cond_signal(m_pCond); /*等待*/
        
        
	}
    
	void setReturnP(pthread_cond_t* pCond, int* ic, string* outinfo, string* error)
	{
		m_ic = ic;
		m_pOutInfo = outinfo;
		m_pErrror = error;
		m_pCond = pCond;
	}
	bool isFinished()
	{
        
		return m_bFinished;
	}
	bool m_bTimeoutFromClient; //如果是客户端超时走了
    
	//HANDLE m_event;
private:
    
    
    
	pthread_cond_t *m_pCond;
    
	bool m_bFinished;
	int* m_ic;
	string* m_pOutInfo;
	string* m_pErrror;
    
};

class CAsyncSelectPage : public MQServerModule::AMI_MQInterface_selectPage
{
public:
    CAsyncSelectPage()
    {
        //m_vLock = PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
        //m_condition = PTHREAD_COND_INITIALIZER;
        //m_event = CreateEvent (0, TRUE, FALSE, 0);
        m_bFinished = false;
        
		m_bTimeoutFromClient = false;
        m_pCond = NULL;
    }
    
    virtual void ice_response(int ic,const string& outinfo,const string& error)
    {
        
		if ( m_bTimeoutFromClient ) return;
        if (  m_pErrror )
        {
            
            if ( m_pOutInfo )
            {
                (*m_ic) = ic;
                (*m_pErrror) = error;
                (*m_pOutInfo) = outinfo;
            }
        }
        
        
        //Sleep(3000);
        m_bFinished  = true;
        //std::cout << "in----wait finished" << std::endl;
        pthread_cond_signal(m_pCond); /*等待*/
        
        //SetEvent(m_event);
    }
    virtual void ice_exception()
    {
		if ( m_bTimeoutFromClient ) return;
        util::string_format((*m_pErrror), "查询分页出现未知网络失败 ");
        if ( m_pOutInfo )
        {
            (*m_ic) = -1;
            //(*m_pErrror) = "CAsyncSelect AMI call failed";
            (*m_pOutInfo) = "";
        }
        m_bFinished  = true;
        pthread_cond_signal(m_pCond); /*等待*/
        
    }
    
    virtual void ice_exception(const Ice::Exception& ex)
    {
		if ( m_bTimeoutFromClient ) return;
        util::string_format((*m_pErrror), "查询分页出现未知网络失败:%s",ex.what());
        if ( m_pOutInfo )
        {
            (*m_ic) = -1;
            //(*m_pErrror) = "CAsyncSelect AMI call failed";
            (*m_pOutInfo) = "";
        }
        m_bFinished  = true;
        pthread_cond_signal(m_pCond); /*等待*/
        
        
    }
    
    void setReturnP(pthread_cond_t* pCond,int* ic,string* outinfo,string* error)
    {
        m_ic = ic;
        m_pOutInfo = outinfo;
        m_pErrror = error;
        m_pCond = pCond;
    }
    bool isFinished()
    {
        
        return m_bFinished;
    }
	bool m_bTimeoutFromClient; //如果是客户端超时走了
    
    //HANDLE m_event;
private:
    
    pthread_cond_t *m_pCond;
    
    bool m_bFinished;
    int* m_ic;
    string* m_pOutInfo;
    string* m_pErrror;
    
};

class CAsyncExecSQL : public MQServerModule::AMI_MQInterface_execSQL
{
public:
    CAsyncExecSQL()
    {
        m_bFinished = false;
        m_bOK = NULL;
        m_pCond = NULL;
		m_bTimeoutFromClient = false;
        //m_event = CreateEvent (0, TRUE, FALSE, 0);
    }
    
    virtual void ice_response(bool bOK,const string& error)
    {
		if ( m_bTimeoutFromClient ) return;
        
        if (  m_pErrror )
        {
            (*m_bOK) = bOK;
            (*m_pErrror) = error;
        }
        
        m_bFinished  = true;
        
        //Sleep(2000);
        pthread_cond_signal(m_pCond); /*等待*/
        //SetEvent(m_event);
    }
    
    virtual void ice_exception(const Ice::Exception& ex)
    {
		if ( m_bTimeoutFromClient ) return;
        util::string_format((*m_pErrror), "执行数据库操作出现失败:%s",ex.what());
        (*m_ic) = -1;
        m_bFinished  = true;
        pthread_cond_signal(m_pCond); /*等待*/
        
    }
    
    void setReturnP(pthread_cond_t* pCond,bool* bOK,string* error)
    {
        m_pCond = pCond;
        m_pErrror = error;
        m_bOK = bOK;
        
    }
    bool isFinished()
    {
        
        return m_bFinished;
    }
    //HANDLE m_event;
    
    
	bool m_bTimeoutFromClient; //如果是客户端超时走了
    bool m_bFinished;
private:
	
    pthread_cond_t *m_pCond;
    
    
    int* m_ic;
    string* m_pOutInfo;
    string* m_pErrror;
    bool* m_bOK;
    
};

class CAsyncExecProc : public MQServerModule::AMI_MQInterface_execProc
{
public:
    CAsyncExecProc()
    {
        m_bFinished = false;
        m_bOK = NULL;
        //m_event = CreateEvent (0, TRUE, FALSE, 0);
		m_bTimeoutFromClient = false;
        m_pCond = NULL;
    }
    
    virtual void ice_response(bool bOK,const string& outinfo,const string& error)
    {
        
		if ( m_bTimeoutFromClient ) return;
        if (  m_pOutInfo &&  m_pErrror )
        {
            (*m_bOK) = bOK;
            (*m_pErrror) = error;
            (*m_pOutInfo) = outinfo;
        }
        
        m_bFinished  = true;
        //SetEvent(m_event);
        pthread_cond_signal(m_pCond); /*等待*/
    }
    
    virtual void ice_exception(const Ice::Exception& ex)
    {
		if ( m_bTimeoutFromClient ) return;
        util::string_format((*m_pErrror), "执行数据库操作出现未知网络失败:%s",ex.what());
        m_bFinished  = true;
        pthread_cond_signal(m_pCond); /*等待*/
        
    }
    
    void setReturnP(pthread_cond_t* pCond,bool* bOK,string* out,string* error)
    {
        m_pErrror = error;
        m_bOK = bOK;
        m_pOutInfo = out;
        m_pCond = pCond;
    }
    bool isFinished()
    {
        
        return m_bFinished;
    }
    //HANDLE m_event;
    
	bool m_bTimeoutFromClient;
private:
    
    pthread_cond_t* m_pCond;
    
    bool m_bFinished;
    
    string* m_pErrror;
    bool* m_bOK;
    std::string* m_pOutInfo;
    
};

class CAsyncExecSQLBatch : public MQServerModule::AMI_MQInterface_execSQLBatch
{
public:
    CAsyncExecSQLBatch()
    {
        m_bFinished = false;
        m_bOK = NULL;
        //m_event = CreateEvent (0, TRUE, FALSE, 0);
        m_pCond = NULL;
		m_bTimeoutFromClient = false;
    }
    
    virtual void ice_response(bool bOK,const string& error)
    {
        //wlog("inice_respone -%d--\n",bOK);
		if ( m_bTimeoutFromClient ) return;
        if ( m_bOK )
        {
            (*m_bOK) = bOK;
        }
        
        if ( m_pErrror )
        {
            
            //(*m_bOK) = bOK;
            
            (*m_pErrror) = error;
            
            
        }
        
        m_bFinished  = true;
        //SetEvent(m_event);
        pthread_cond_signal(m_pCond); /*等待*/
    }
    
    virtual void ice_exception(const Ice::Exception& ex)
    {
		if (  m_bTimeoutFromClient ) return;
        
        util::string_format((*m_pErrror), "执行数据库操作出现未知网络失败:%s",ex.what());
        wlog("error inice_respone -%d--%s\n",(*m_bOK),ex.what());
        m_bFinished  = true;
        pthread_cond_signal(m_pCond); /*等待*/
        
        
        
        
        
    }
    
    void setReturnP(pthread_cond_t* pCond,bool* bOK,string* error)
    {
        m_pCond = pCond;
        m_pErrror = error;
        m_bOK = bOK;
    }
    bool isFinished()
    {
        
        return m_bFinished;
    }
    
	bool m_bTimeoutFromClient;
    
private:
    
    
    pthread_cond_t* m_pCond;
    bool m_bFinished;
    int* m_ic;
    string* m_pOutInfo;
    string* m_pErrror;
    bool* m_bOK;
    
};


class OneICE
{
public:
    OneICE()
    {
        m_ic = NULL;
        m_db = NULL;
        m_id = 0 ;
    }
    ~OneICE()
    {
        
    }
    Ice::CommunicatorPtr *m_ic;
    MQServerModule::MQInterfacePrx *m_db;
    int  m_id; //是哪一类占用了
};


class CICEMyPool
{
public:
    CICEMyPool()
    {
        //m_vLock = PTHREAD_MUTEX_INITIALIZER;
		index = 0;
        pthread_mutex_init(&m_vLock,NULL);
    }
    ~CICEMyPool()
    {
        if ( m_v.size() > 0 )
        {
            //wlog("退出时有ICE对象没有清空-[%d]\n",m_v.size());
            for(std::vector<OneICE>::iterator it=m_v.begin(); it!=m_v.end(); )
            {
                //if( (*it).m_id == id)
                
                try
                {
                    
                    if ( (*it).m_ic )
                    {
                        try
                        {
                            
                            (*(*it).m_ic)->destroy();
                            
                        }
                        catch(...)
                        {
                            
                        }
                        if ( (*it).m_ic )
                        {
                            delete (*it).m_ic;
                        }
                        
                        if ( (*it).m_db )
                        {
                            delete (*it).m_db;
                        }
                    }
                    it = m_v.erase(it);
                }
                catch(...)
                {
                    
                }
            }
			pthread_mutex_unlock(&m_vLock);
			pthread_mutex_destroy(&m_vLock);
        }
        
    }
    Ice::CommunicatorPtr* getIC(unsigned int id)
    {
        Scope_Mutex_C lock(m_vLock);
        for(std::vector<OneICE>::iterator it=m_v.begin(); it!=m_v.end(); )
        {
            if( (*it).m_id == id)
            {
                return (*it).m_ic;
            }
            else
            {
                ++it;
            }
        }
        return NULL;
    }
    MQServerModule::MQInterfacePrx* getDB(unsigned int id)
    {
        Scope_Mutex_C lock(m_vLock);
        for(std::vector<OneICE>::iterator it=m_v.begin(); it!=m_v.end(); )
        {
            if( (*it).m_id == id)
            {
                return (*it).m_db;
            }
            else
            {
                ++it;
            }
        }
        
        
        return NULL;
    }
    
    int  size()
    {
        Scope_Mutex_C lock(m_vLock);
        return static_cast<int>(m_v.size());
    }
    int add()
    {
        Scope_Mutex_C lock(m_vLock);
        
        OneICE one;
        
        one.m_ic = new Ice::CommunicatorPtr;
        one.m_db =  new MQServerModule::MQInterfacePrx;
        one.m_id = index++;
        m_v.push_back(one);
        
        return one.m_id;
        
    }
    bool remove(unsigned int id)
    {
        Scope_Mutex_C lock(m_vLock);
        
        for(std::vector<OneICE>::iterator it=m_v.begin(); it!=m_v.end(); )
        {
            if( (*it).m_id == id)
            {
                try
                {
                    
                    if ( (*it).m_ic )
                    {
                        try
                        {
                            
                            (*(*it).m_ic)->destroy();
                            
                            
                        }
                        catch(...)
                        {
                            
                        }
                        if ( (*it).m_ic )
                        {
                            delete (*it).m_ic;
                        }
                        
                        if ( (*it).m_db )
                        {
                            delete (*it).m_db;
                        }
                    }
                    
                    it = m_v.erase(it);
                    return true;
                }
                catch(...)
                {
                    
                }
            }
            else
            {
                ++it;
            }
        }
        
        return false;
    }
private:
    std::vector<OneICE> m_v;
	int index;
    pthread_mutex_t m_vLock;
};

CICEMyPool  g_icePool;


#define IC_GET_DB (*g_icePool.getDB(m_id))
#define IC_GET_IC (*g_icePool.getIC(m_id))

//Ice::CommunicatorPtr			m_ic;
//MQServerModule::MQInterfacePrx	m_db;
//#define m_db g_icePool.getDB(m_id)
//#define m_ic g_icePool.getDB(m_ic)

void CICEBaseDBUtil::getServerInfo(string& ip,int& port,string& user,string& pass)
{
    ip =   m_sServer;
    port = m_iTCPPort;
    user = "";
    pass = "";
}

CICEBaseDBUtil::CICEBaseDBUtil()
:m_bConnected(false)
{
    m_iMaxRecvSize = 40960;
    m_iTimeOut = 30000;
    m_iSleepSlip = 20;
    m_id = g_icePool.add();
    m_bICEInited = false;
    util::string_format(m_sSep,"%c",CONST_SEP_FIELD);
    util::string_format(m_sLineSep,"%c",CONST_SEP_LINE);
    
	m_iConnectTimeOut = 8000;
    
    
}
//int CICEBaseDBUtil::getMaxID(const string& sSeqName,int count,int& start)
//{
//
//	int iCurID = 0;
//	start = -1;
//
//
//	string sql;
//	util::string_format(sql,"select seq_value from t_cfg_seq where seq_name='%s' ",
//		sSeqName.c_str());
//
//
//	string out;
//	string sError;
//
//	if ( select(sql,out,sError) <= 0 )
//	{
//		return -1;
//	}
//
//	CSelectHelp help;
//	help.fromString(out.c_str());
//
//	if ( help._count <= 0 ) return -1;
//
//	iCurID = help.valueInt(0,0);
//
//	start  = iCurID;
//
//
//	util::string_format(sql,"update  t_cfg_seq set seq_value=%d  where seq_name='%s' ",
//		iCurID+count,sSeqName.c_str());
//
//	if ( !execSQL(sql,"",sError) )
//	{
//		return -1;
//	}
//
//	return count;
//}
CICEBaseDBUtil::~CICEBaseDBUtil()
{
    try
    {
        //wlog("exit\n");
        if ( isLogin() )
        {
            //从服务器注销
            string hid = CSystemUtil::getID();
            
            string outmsg;
            command("un_register_sn",hid,outmsg);
        }
        g_icePool.remove(m_id);
    }
    catch(...)
    {
        
    }
}
//用户名和密码只在使用认证方式时使用,如果UDP端口设置为0代表与TCPPort相同
void CICEBaseDBUtil::setServer(const char* server,int iTcpPort,int iUdpPort,int iSSLPort)
{
    m_sServer = server;
    m_iTCPPort = iTcpPort;
    m_iUDPPort = iUdpPort;
    if ( m_iUDPPort <= 0 )
    {
        m_iUDPPort = iTcpPort;
    }
    m_iSSLPort = iSSLPort;
}
std::string& CICEBaseDBUtil::getVersion(std::string& out)
{
    out = "";
    if ( !IC_GET_DB )
    {
        return out;
    }
    
    try
    {
        out =  IC_GET_DB->version();
        return out;
    }
    catch (const Ice::Exception& e)
    {
        wlog("%s\n",e.what());
        return out;
    }
    catch(...)
    {
        return out;
    }
    return out;
}
void CICEBaseDBUtil::setMaxRecvSize(int iMax)
{
    if( iMax<= 100 )
    {
        m_iMaxRecvSize = 40960;
    }
    else
        m_iMaxRecvSize = iMax;
}

bool CICEBaseDBUtil::login()
{
    
    try
    {
        logout();
    }
    catch(...)
    {
        
    }
    
    char sEndPoint[200]= {0};
    sprintf(sEndPoint,"env:tcp -p %d -h %s:udp -p %d -h %s",
            m_iTCPPort,m_sServer.c_str(),
            m_iUDPPort,m_sServer.c_str());
    
    //    int status = 0;
    try {
        
        
        int argc = 1;
        char *argv[]= {const_cast<char*>("MQClient")};
        
        if ( !m_bICEInited )
        {
            string sMaxSize;
            
            util::string_format(sMaxSize,"%d",m_iMaxRecvSize);
            
            //IC_GET_IC = Ice::initialize(argc, argv);
            
            Ice::PropertiesPtr props = Ice::createProperties(argc, argv);
            props->setProperty("Ice.MessageSizeMax",sMaxSize.c_str());
            
            Ice::InitializationData id;
            
            id.properties = props;
            id.stringConverter = new StringConverterI();// 邦定转码器
            IC_GET_IC = Ice::initialize(id);
            
            m_bICEInited = true;
        }
        IC_GET_DB  = MQServerModule::MQInterfacePrx::checkedCast(
                                                                 IC_GET_IC->stringToProxy(sEndPoint)->ice_twoway()->ice_timeout((int)(m_iConnectTimeOut/2.0))->ice_secure(false));
        
    }
    catch (const Ice::Exception& e)
    {
        wlog("%s\n",e.what());
        m_bConnected = false;
        m_sError = e.what();
        return false;
    }
    catch(...)
    {
        
        m_bConnected = false;
        return false;
    }
	//重设超时参数
	setTimeOut(m_iTimeOut);
    
    m_bConnected = true;
    
    return true;
}

bool CICEBaseDBUtil::isLogin()
{
    return m_bConnected;
    
}
bool CICEBaseDBUtil::logout()
{
    try
    {
        
        IC_GET_IC->destroy();
        m_bICEInited = false;
        
    }
    catch(...)
    {
        m_bICEInited = false;
    }
    return true;
}
bool CICEBaseDBUtil::loginUser(const char* username,const char* pass,string& error)
{
    string sql;
    util::string_format(sql,"select user_id,user_name,user_passwd from uums_user where user_name='%s'  and user_passwd='%s'",
                        username,pass);
    wlog("%s\n",sql.c_str());
    
    CSelectHelp help;
    help.reset();
    
    string out,sError;
    
    int ic = select(sql,"",out,sError);
    
    help.fromString(out.c_str());
    
    wlog("%s\n",out.c_str());
    
    if ( ic < 0  )
    {
        return false;
    }
    if ( help._count <=  0 )
    {
        error = "用户名或密码不正确";
        return false;
    }
    //register sn
    string hid = CSystemUtil::getID();
    if ( command("register_sn",hid,error) < 0 ) return false;
    return true;
}


string& CICEBaseDBUtil::getConfigure(char* segment,char* key,string& out)
{
    
    try
    {
        
        out =  IC_GET_DB->getConfigure(segment,key);
        
        return out;
    }
    catch (const Ice::Exception& e)
    {
        wlog("Error in getConfigure:%s\n",e.what());
        return out;
    }
    catch(...)
    {
        
        return out;
    }
    
    return out;
    
}

string& CICEBaseDBUtil::getTime(string& out)
{
    
    try
    {
        out =  IC_GET_DB->getTime();
        return out;
    }
    catch (const Ice::Exception& e)
    {
        wlog("%s\n",e.what());
        return out;
    }
    catch(...)
    {
        
        return out;
    }
    
    return out;
    
}
int CICEBaseDBUtil::command(const string& cmd,const string& param,string& out)
{
    
    
    try
    {
        
        return IC_GET_DB->command(cmd,param,out);
    }
    catch(...)
    {
        
    }
    
    return -1;
    
}

int CICEBaseDBUtil::plugin(const string& pname,const string& cmd,const string& param,string& out)
{
    try
    {
        return IC_GET_DB->plugin(pname,cmd,param,out);
    }
    catch(...)
    {
        
    }
    
    return -1;
}

void CICEBaseDBUtil::sendOneway(const char* msg)
{
    
    try
    {
        IC_GET_DB->sendOneway(msg);
    }
    catch (const Ice::Exception& e)
    {
        wlog("%s\n",e.what());
        return ;
    }
    catch(...)
    {
        
        return ;
    }
    
}

bool CICEBaseDBUtil::send(const char* msg)
{
    
    try
    {
        return IC_GET_DB->send(msg);
    }
    catch (const Ice::Exception& e)
    {
        wlog("%s\n",e.what());
        return false;
    }
    catch(...)
    {
        
        return false;
    }
    
    return false;
}


int CICEBaseDBUtil::select(const string& sql,string& out,string &sError)
{
    return select(sql,"",out,sError);
}
int CICEBaseDBUtil::select(const string& sql,const string& param,string& out,string &sError)
{
    
    CAsyncSelect *pSelect = NULL;
    try
    {
        
        out  = "";
		sError="";
        pSelect = new CAsyncSelect;
        
        int ic = -1;
        
        pthread_cond_t cond ;
        pthread_cond_init(&cond,NULL);
        pthread_mutex_t vLock ;//= PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
        
        pthread_mutex_init(&vLock,NULL);
        
        pSelect->setReturnP(&cond,&ic,&out,&sError);
        
        pthread_mutex_lock(&vLock);
        
        bool bOK = IC_GET_DB->select_async(pSelect,sql,param);
        if ( !bOK )
        {
			out="";
            sError="之前查询还未结束,请稍后再试";
			ic = -2;
        }
        
		timespec to;
		to.tv_sec = (long)(time(NULL) + m_iTimeOut/1000+1);
		to.tv_nsec = 0;
        
		time_t tCur = time(NULL);
        //		int ret = pthread_cond_timedwait(&cond,&vLock,&to);
        pthread_cond_timedwait(&cond,&vLock,&to);
        
		time_t tNow = time(NULL);
		if ( tNow-tCur +2 >= m_iTimeOut/1000 )
		{
			out="";
			sError="查询超时";
			ic = -3;
			pSelect->m_bTimeoutFromClient = true;
		}
        
		pthread_mutex_unlock(&vLock);
		pthread_mutex_destroy(&vLock);
		pthread_cond_destroy(&cond);
		
        return ic;
        
    }
    catch(const Ice::Exception& ex)
    {
        wlog("unkonw ice exception in select %s\n",ex.what());
        //SAVE_DELETE(pSelect);
        sError = ex.what();
        return -1;
    }
    
}
int CICEBaseDBUtil::selectPage(const string& sql,const string& param,
							   string& out,string &sError,int iStart,int iCount)
{
    
    CAsyncSelectPage *pSelect = NULL;
    try
    {
        
        out  = "";
		sError="";
        pSelect = new CAsyncSelectPage;
        
        int ic = -1;
        
        pthread_cond_t cond ;
        pthread_cond_init(&cond,NULL);
        pthread_mutex_t vLock ;//= PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
        
        pthread_mutex_init(&vLock,NULL);
        
        
        pSelect->setReturnP(&cond,&ic,&out,&sError);
        
        pthread_mutex_lock(&vLock);
        
        bool bOK = IC_GET_DB->selectPage_async(pSelect,sql,param,iStart,iCount);
        if ( !bOK )
        {
            //sError="调用selectPage_async失败";
			out="";
			sError="之前查询还未结束,请稍后再试";
			ic = -2;
        }
        
		timespec to;
		to.tv_sec = (long)(time(NULL) + m_iTimeOut/1000+1);
		to.tv_nsec = 0;
        
		time_t tCur = time(NULL);
        //		int ret = pthread_cond_timedwait(&cond,&vLock,&to);
        pthread_cond_timedwait(&cond,&vLock,&to);
        
		time_t tNow = time(NULL);
		if ( tNow-tCur +2 >= m_iTimeOut/1000 )
		{
			out="";
			sError="查询超时";
			ic = -3;
			pSelect->m_bTimeoutFromClient = true;
		}
        
		pthread_mutex_unlock(&vLock);
		pthread_cond_destroy(&cond);
		pthread_mutex_destroy(&vLock);
        return ic;
        
    }
    catch(const Ice::Exception& ex)
    {
        wlog("unkonw ice exception in select %s\n",ex.what());
        //SAVE_DELETE(pSelect);
        sError = ex.what();
        return -1;
    }
    
}
int CICEBaseDBUtil::selectPage(const string& sql,
							   string& out,string &sError,int iStart,int iCount)
{
    
    return  selectPage(sql,"",out,sError,iStart,iCount);
    
}
int CICEBaseDBUtil::selectSync(const string& sql,string& out,string &sError)
{
    return selectSync(sql,"",out,sError);
}
int CICEBaseDBUtil::selectSync(const string& sql,const string& param,string& out,string &sError)
{
    
    try
    {
        bool bOK = IC_GET_DB->select(sql,param,out,sError);
        
        
        return bOK;
        
    }
    catch(const Ice::Exception& ex)
    {
        wlog("%s\n",ex.what());
        
        sError = ex.what();
        return -1;
    }
    
}
int CICEBaseDBUtil::selectCmd(const std::string & cmd, const std::string & sqlcode, const ::std::string& param,
                              string& out, string& sError)
{
	CAsyncSelectCmd *pSelect = NULL;
	try
	{
        
		out = "";
		sError = "";
		pSelect = new CAsyncSelectCmd;
        
		int ic = -1;
        
		pthread_cond_t cond;
		pthread_cond_init(&cond, NULL);
		pthread_mutex_t vLock;//= PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
        
		pthread_mutex_init(&vLock, NULL);
        
		pSelect->setReturnP(&cond, &ic, &out, &sError);
        
		pthread_mutex_lock(&vLock);
        
		bool bOK = IC_GET_DB->selectCmd_async(pSelect, cmd,sqlcode, param);
		if (!bOK)
		{
			out = "";
			sError = "之前查询还未结束,请稍后再试";
			ic = -2;
		}
        
		timespec to;
		to.tv_sec = (long)(time(NULL) + m_iTimeOut / 1000 + 1);
		to.tv_nsec = 0;
        
		time_t tCur = time(NULL);
        //		int ret = pthread_cond_timedwait(&cond, &vLock, &to);
        pthread_cond_timedwait(&cond, &vLock, &to);
        
		time_t tNow = time(NULL);
		if (tNow - tCur + 2 >= m_iTimeOut / 1000)
		{
			out = "";
			sError = "查询超时";
			ic = -3;
			pSelect->m_bTimeoutFromClient = true;
		}
        
		pthread_mutex_unlock(&vLock);
		pthread_mutex_destroy(&vLock);
		pthread_cond_destroy(&cond);
        
		return ic;
        
	}
	catch (const Ice::Exception& ex)
	{
		wlog("unkonw ice exception in select %s\n", ex.what());
		//SAVE_DELETE(pSelect);
		sError = ex.what();
		return -1;
	}
    
	return 0;
}
//bool CICEBaseDBUtil::execSQL(CSQLBuilder& builder,string &sError)
//{
//    string ss,sp;
//    return execSQL(builder.getSQL(ss),builder.toParamString(sp),sError);
//}
bool CICEBaseDBUtil::execSQL(const string& sql,const string& param,string &sError)
{
    
    CAsyncExecSQL *pSelect  = NULL;
    try
    {
        string out;
        //sSet.reset();
		sError="";
        
        pSelect = new CAsyncExecSQL;
        
        bool b = false;
        
        pthread_cond_t cond ;
        pthread_cond_init(&cond,NULL);
        pthread_mutex_t vLock ;//= PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
        
        pthread_mutex_init(&vLock,NULL);
        
        pSelect->setReturnP(&cond,&b,&sError);
        
        pthread_mutex_lock(&vLock);
        
        bool bOK = IC_GET_DB->execSQL_async(pSelect,sql,param);
        if ( !bOK )
        {
            //sError="调用execSQL_async失败";
			out="";
			sError="之前执行还未结束,请稍后再试";
			b = false;
        }
        
		timespec to;
		to.tv_sec = (long)(time(NULL) + m_iTimeOut/1000+1);
		to.tv_nsec = 0;
        
		time_t tCur = time(NULL);
        //		int ret = pthread_cond_timedwait(&cond,&vLock,&to);
        pthread_cond_timedwait(&cond,&vLock,&to);
        
		time_t tNow = time(NULL);
		if ( tNow-tCur +2 >= m_iTimeOut/1000 )
		{
			out="";
			sError="执行超时";
			b = false;
			pSelect->m_bTimeoutFromClient = true;
		}
        
		pthread_mutex_unlock(&vLock);
		pthread_cond_destroy(&cond);
		pthread_mutex_destroy(&vLock);
        //SAVE_DELETE(pSelect);
        return b;
        
        
    }
    catch(const Ice::Exception& ex)
    {
        wlog("%s\n",ex.what());
        //SAVE_DELETE(pSelect);
        return false;
    }
    
}

int CICEBaseDBUtil::execCmd(const std::string & cmd, const std::string & sqlcode, const ::std::string& param,
                            string& out, string& sError)
{
	CAsyncExecCmd *pSelect = NULL;
	try
	{
        
		out = "";
		sError = "";
		pSelect = new CAsyncExecCmd;
        
		int ic = -1;
        
		pthread_cond_t cond;
		pthread_cond_init(&cond, NULL);
		pthread_mutex_t vLock;//= PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
        
		pthread_mutex_init(&vLock, NULL);
        
		pSelect->setReturnP(&cond, &ic, &out, &sError);
        
		pthread_mutex_lock(&vLock);
        
		bool bOK = IC_GET_DB->execCmd_async(pSelect, cmd, sqlcode, param);
		if (!bOK)
		{
			out = "";
			sError = "之前查询还未结束,请稍后再试";
			ic = -2;
		}
        
		timespec to;
		to.tv_sec = (long)(time(NULL) + m_iTimeOut / 1000 + 1);
		to.tv_nsec = 0;
        
		time_t tCur = time(NULL);
        //		int ret = pthread_cond_timedwait(&cond, &vLock, &to);
        pthread_cond_timedwait(&cond, &vLock, &to);
        
		time_t tNow = time(NULL);
		if (tNow - tCur + 2 >= m_iTimeOut / 1000)
		{
			out = "";
			sError = "查询超时";
			ic = -3;
			pSelect->m_bTimeoutFromClient = true;
		}
        
		pthread_mutex_unlock(&vLock);
		pthread_mutex_destroy(&vLock);
		pthread_cond_destroy(&cond);
        
		return ic;
        
	}
	catch (const Ice::Exception& ex)
	{
		wlog("unkonw ice exception in select %s\n", ex.what());
		//SAVE_DELETE(pSelect);
		sError = ex.what();
		return -1;
	}
    
	return 0;
}

bool CICEBaseDBUtil::execSQLBatch(const string& sql,string &sError)
{
    CAsyncExecSQLBatch *pSelect = NULL;
    
    //wlog("step-01\n");
    try
    {
        string out;
        //sSet.reset();
		sError="";
        
        pSelect = new CAsyncExecSQLBatch;
        
        
        pthread_cond_t cond ;
        pthread_cond_init(&cond,NULL);
        pthread_mutex_t vLock ;//= PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
        
        pthread_mutex_init(&vLock,NULL);
        
        bool b = false;
        pSelect->setReturnP(&cond,&b,&sError);
        pthread_mutex_lock(&vLock);
        
        //wlog("step-02\n");
        bool bOK = IC_GET_DB->execSQLBatch_async(pSelect,sql);
        if ( !bOK )
        {
            //wlog("call--IC_GET_DB->execSQLBatch_async fail\n");
            //sError="调用execSQLBatch_async失败";
			out="";
			sError="之前执行还未结束,请稍后再试";
			b = false;
            //wlog("step-03\n");
        }
        
		timespec to;
		to.tv_sec = (long)(time(NULL) + m_iTimeOut/1000+1);
		to.tv_nsec = 0;
        
        
		//wlog("step-04\n");
		time_t tCur = time(NULL);
        //		int ret = pthread_cond_timedwait(&cond,&vLock,&to);
        pthread_cond_timedwait(&cond,&vLock,&to);
        
		time_t tNow = time(NULL);
		if ( tNow-tCur +2 >= m_iTimeOut/1000 )
		{
			out="";
			sError="执行超时";
			b = false;
			pSelect->m_bTimeoutFromClient = true;
		}
        
        //wlog("step-05\n");
        
        //wlog("execsqlbatch---in bOK=%d---%d-%s\n",bOK,b,sError.c_str());
		pthread_mutex_unlock(&vLock);
		pthread_cond_destroy(&cond);
		pthread_mutex_destroy(&vLock);
        return b;
        
    }
    catch(const Ice::Exception& ex)
    {
        wlog("find ice exception %s\n",ex.what());
        //SAVE_DELETE(pSelect);
        
        wlog("step-06\n");
        return false;
    }
    
    wlog("step-over\n");
    return true;
}

bool CICEBaseDBUtil::execProc(const string& sql,const string& param,string& out,string &sError)
{
    
    CAsyncExecProc *pSelect  = NULL;
    
    try
    {
        
        
        pSelect = new CAsyncExecProc;
        
        //string out;
		out="";
		sError="";
        pthread_cond_t cond ;
        pthread_cond_init(&cond,NULL);
        pthread_mutex_t vLock ;//= PTHREAD_MUTEX_INITIALIZER; /*初始化互斥锁*/
        
        pthread_mutex_init(&vLock,NULL);
        
        bool b = false;
        pSelect->setReturnP(&cond,&b,&out,&sError);
        pthread_mutex_lock(&vLock);
        
        bool bOK = IC_GET_DB->execProc_async(pSelect,sql,param);
        if ( !bOK )
        {
            //sError="调用execProc失败";
			out="";
			sError="之前执行还未结束,请稍后再试";
			b = false;
        }
        
		timespec to;
		to.tv_sec = (long)(time(NULL) + m_iTimeOut/1000+1);
		to.tv_nsec = 0;
        
		time_t tCur = time(NULL);
        //		int ret = pthread_cond_timedwait(&cond,&vLock,&to);
        pthread_cond_timedwait(&cond,&vLock,&to);
        
		time_t tNow = time(NULL);
		if ( tNow-tCur +2 >= m_iTimeOut/1000 )
		{
			out="";
			sError="执行超时";
			b = false;
			pSelect->m_bTimeoutFromClient = true;
		}
        
        //help.fromString(out.c_str());
        
        //return help._count;
        
		pthread_mutex_unlock(&vLock);
		pthread_cond_destroy(&cond);
		pthread_mutex_destroy(&vLock);
        return true;
        
        
    }
    catch(const Ice::Exception& ex)
    {
        wlog("%s\n",ex.what());
        //SAVE_DELETE(pSelect);
        
        return false;
    }
    
}

void CICEBaseDBUtil::setConnectTimeOut(int iMSeconds)
{
	m_iConnectTimeOut = iMSeconds;
    
	if ( m_iConnectTimeOut <= 1000 )
	{
		m_iConnectTimeOut = 1000;
	}
    
	return;
    
}
void CICEBaseDBUtil::setTimeOut(int iMSeconds)
{
    m_iTimeOut = iMSeconds;
    
    try
    {
        char sEndPoint[200]= {0};
        sprintf(sEndPoint,"env:tcp -p %d -h %s:udp -p %d -h %s",
                m_iTCPPort,m_sServer.c_str(),
                m_iUDPPort,m_sServer.c_str());
        
        IC_GET_DB  = MQServerModule::MQInterfacePrx::checkedCast(
                                                                 IC_GET_IC->stringToProxy(sEndPoint)->ice_twoway()->ice_timeout(m_iTimeOut)->ice_secure(false));
        
		m_iTimeOut += 2000;
    }
    catch(...)
    {
        
        //PopMsg("连接失败");
    }
    
}
/************************************************************************/
/*         此函数将提交至后台执行，不管是否成功，都返回true             */
/************************************************************************/
bool CICEBaseDBUtil::writeBusiLog(const string& personid,const string&  ip,const string& busiType,const string& comment)
{
    try
    {
        return IC_GET_DB->writeBusiLog(personid,ip,busiType,comment);
    }
    catch(const Ice::Exception& ex)
    {
        wlog("%s\n",ex.what());
        return false;
    }
    
    return false;
}


std::string& CICEBaseDBUtil::getMsg(std::string& out)
{
    out =  m_sError;
    return out;
}

std::string& CICEBaseDBUtil::getUUID(std::string& out)
{
    out =  IceUtil::generateUUID();
    return out;
}

#endif //end of USE_ICE

//!  CMD5类，用于MD5加密算法的实现.
/*!
 
 */

static uint8 md5_padding[64] =
{
    0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

#define GET_UINT32(n,b,i)                       \
{                                               \
	(n) = ( (uint32) (b)[(i)    ]       )       \
	| ( (uint32) (b)[(i) + 1] <<  8 )       \
	| ( (uint32) (b)[(i) + 2] << 16 )       \
	| ( (uint32) (b)[(i) + 3] << 24 );      \
}

#define PUT_UINT32(n,b,i)                       \
{                                               \
	(b)[(i)    ] = (uint8) ( (n)       );       \
	(b)[(i) + 1] = (uint8) ( (n) >>  8 );       \
	(b)[(i) + 2] = (uint8) ( (n) >> 16 );       \
	(b)[(i) + 3] = (uint8) ( (n) >> 24 );       \
}






CMD5::CMD5()
{
    *m_szMD5 = '\0';
}
CMD5::CMD5(std::string& sText)
{
    MakeHash(sText.c_str(), (unsigned long)sText.length());
}
CMD5::CMD5(const char* sText)
{
    MakeHash(sText, (unsigned long)strlen(sText));
}
CMD5::CMD5(const char* szText, uint32 nTextLen)
{
    MakeHash(szText, nTextLen);
}
CMD5::~CMD5()
{
    
}

CMD5::operator std::string() const
{
    return (std::string) m_szMD5;
}

CMD5::operator char*() const
{
    return (char*)m_szMD5;
}

char*	CMD5::get()
{
    return (char*)m_szMD5;
}

char* CMD5::MakeHash(const char* szText, uint32 nTextLen)
{
    md5_context ctx;
    unsigned char md5sum[16];
    unsigned short i;
    
    md5_starts(&ctx);
    md5_update(&ctx, (uint8*)szText, nTextLen);
    md5_finish(&ctx, md5sum);
    
    for (i = 0; i < 16; i++)
    {
        sprintf(m_szMD5 + i * 2, "%02x", md5sum[i]);
    }
    
    return(m_szMD5);
}


void CMD5::md5_starts( md5_context *ctx ) const
{
    ctx->total[0] = 0;
    ctx->total[1] = 0;
    
    ctx->state[0] = 0x67452301;
    ctx->state[1] = 0xEFCDAB89;
    ctx->state[2] = 0x98BADCFE;
    ctx->state[3] = 0x10325476;
}
void CMD5::md5_update( md5_context *ctx, uint8 *input, uint32 length ) const
{
    uint32 left, fill;
    
    if( ! length ) return;
    
    left = ctx->total[0] & 0x3F;
    fill = 64 - left;
    
    ctx->total[0] += length;
    ctx->total[0] &= 0xFFFFFFFF;
    
    if( ctx->total[0] < length )
        ctx->total[1]++;
    
    if( left && length >= fill )
    {
        memcpy( (void *) (ctx->buffer + left),
               (void *) input, fill );
        md5_process( ctx, ctx->buffer );
        length -= fill;
        input  += fill;
        left = 0;
    }
    
    while( length >= 64 )
    {
        md5_process( ctx, input );
        length -= 64;
        input  += 64;
    }
    
    if( length )
    {
        memcpy( (void *) (ctx->buffer + left),
               (void *) input, length );
    }
}
void CMD5::md5_finish( md5_context *ctx, uint8 digest[16] ) const
{
    uint32 last, padn;
    uint32 high, low;
    uint8 msglen[8];
    
    high = ( ctx->total[0] >> 29 )
    | ( ctx->total[1] <<  3 );
    low  = ( ctx->total[0] <<  3 );
    
    PUT_UINT32( low,  msglen, 0 );
    PUT_UINT32( high, msglen, 4 );
    
    last = ctx->total[0] & 0x3F;
    padn = ( last < 56 ) ? ( 56 - last ) : ( 120 - last );
    
    md5_update( ctx, md5_padding, padn );
    md5_update( ctx, msglen, 8 );
    
    PUT_UINT32( ctx->state[0], digest,  0 );
    PUT_UINT32( ctx->state[1], digest,  4 );
    PUT_UINT32( ctx->state[2], digest,  8 );
    PUT_UINT32( ctx->state[3], digest, 12 );
}


void CMD5::md5_process( md5_context *ctx, uint8 data[64] ) const
{
    uint32 X[16], A, B, C, D;
    
    GET_UINT32( X[0],  data,  0 );
    GET_UINT32( X[1],  data,  4 );
    GET_UINT32( X[2],  data,  8 );
    GET_UINT32( X[3],  data, 12 );
    GET_UINT32( X[4],  data, 16 );
    GET_UINT32( X[5],  data, 20 );
    GET_UINT32( X[6],  data, 24 );
    GET_UINT32( X[7],  data, 28 );
    GET_UINT32( X[8],  data, 32 );
    GET_UINT32( X[9],  data, 36 );
    GET_UINT32( X[10], data, 40 );
    GET_UINT32( X[11], data, 44 );
    GET_UINT32( X[12], data, 48 );
    GET_UINT32( X[13], data, 52 );
    GET_UINT32( X[14], data, 56 );
    GET_UINT32( X[15], data, 60 );
    
#define S(x,n) ((x << n) | ((x & 0xFFFFFFFF) >> (32 - n)))
    
#define P(a,b,c,d,k,s,t)                                \
    {                                                       \
		a += F(b,c,d) + X[k] + t; a = S(a,s) + b;           \
    }
    
    A = ctx->state[0];
    B = ctx->state[1];
    C = ctx->state[2];
    D = ctx->state[3];
    
#define F(x,y,z) (z ^ (x & (y ^ z)))
    
    P( A, B, C, D,  0,  7, 0xD76AA478 );
    P( D, A, B, C,  1, 12, 0xE8C7B756 );
    P( C, D, A, B,  2, 17, 0x242070DB );
    P( B, C, D, A,  3, 22, 0xC1BDCEEE );
    P( A, B, C, D,  4,  7, 0xF57C0FAF );
    P( D, A, B, C,  5, 12, 0x4787C62A );
    P( C, D, A, B,  6, 17, 0xA8304613 );
    P( B, C, D, A,  7, 22, 0xFD469501 );
    P( A, B, C, D,  8,  7, 0x698098D8 );
    P( D, A, B, C,  9, 12, 0x8B44F7AF );
    P( C, D, A, B, 10, 17, 0xFFFF5BB1 );
    P( B, C, D, A, 11, 22, 0x895CD7BE );
    P( A, B, C, D, 12,  7, 0x6B901122 );
    P( D, A, B, C, 13, 12, 0xFD987193 );
    P( C, D, A, B, 14, 17, 0xA679438E );
    P( B, C, D, A, 15, 22, 0x49B40821 );
    
#undef F
    
#define F(x,y,z) (y ^ (z & (x ^ y)))
    
    P( A, B, C, D,  1,  5, 0xF61E2562 );
    P( D, A, B, C,  6,  9, 0xC040B340 );
    P( C, D, A, B, 11, 14, 0x265E5A51 );
    P( B, C, D, A,  0, 20, 0xE9B6C7AA );
    P( A, B, C, D,  5,  5, 0xD62F105D );
    P( D, A, B, C, 10,  9, 0x02441453 );
    P( C, D, A, B, 15, 14, 0xD8A1E681 );
    P( B, C, D, A,  4, 20, 0xE7D3FBC8 );
    P( A, B, C, D,  9,  5, 0x21E1CDE6 );
    P( D, A, B, C, 14,  9, 0xC33707D6 );
    P( C, D, A, B,  3, 14, 0xF4D50D87 );
    P( B, C, D, A,  8, 20, 0x455A14ED );
    P( A, B, C, D, 13,  5, 0xA9E3E905 );
    P( D, A, B, C,  2,  9, 0xFCEFA3F8 );
    P( C, D, A, B,  7, 14, 0x676F02D9 );
    P( B, C, D, A, 12, 20, 0x8D2A4C8A );
    
#undef F
    
#define F(x,y,z) (x ^ y ^ z)
    
    P( A, B, C, D,  5,  4, 0xFFFA3942 );
    P( D, A, B, C,  8, 11, 0x8771F681 );
    P( C, D, A, B, 11, 16, 0x6D9D6122 );
    P( B, C, D, A, 14, 23, 0xFDE5380C );
    P( A, B, C, D,  1,  4, 0xA4BEEA44 );
    P( D, A, B, C,  4, 11, 0x4BDECFA9 );
    P( C, D, A, B,  7, 16, 0xF6BB4B60 );
    P( B, C, D, A, 10, 23, 0xBEBFBC70 );
    P( A, B, C, D, 13,  4, 0x289B7EC6 );
    P( D, A, B, C,  0, 11, 0xEAA127FA );
    P( C, D, A, B,  3, 16, 0xD4EF3085 );
    P( B, C, D, A,  6, 23, 0x04881D05 );
    P( A, B, C, D,  9,  4, 0xD9D4D039 );
    P( D, A, B, C, 12, 11, 0xE6DB99E5 );
    P( C, D, A, B, 15, 16, 0x1FA27CF8 );
    P( B, C, D, A,  2, 23, 0xC4AC5665 );
    
#undef F
    
#define F(x,y,z) (y ^ (x | ~z))
    
    P( A, B, C, D,  0,  6, 0xF4292244 );
    P( D, A, B, C,  7, 10, 0x432AFF97 );
    P( C, D, A, B, 14, 15, 0xAB9423A7 );
    P( B, C, D, A,  5, 21, 0xFC93A039 );
    P( A, B, C, D, 12,  6, 0x655B59C3 );
    P( D, A, B, C,  3, 10, 0x8F0CCC92 );
    P( C, D, A, B, 10, 15, 0xFFEFF47D );
    P( B, C, D, A,  1, 21, 0x85845DD1 );
    P( A, B, C, D,  8,  6, 0x6FA87E4F );
    P( D, A, B, C, 15, 10, 0xFE2CE6E0 );
    P( C, D, A, B,  6, 15, 0xA3014314 );
    P( B, C, D, A, 13, 21, 0x4E0811A1 );
    P( A, B, C, D,  4,  6, 0xF7537E82 );
    P( D, A, B, C, 11, 10, 0xBD3AF235 );
    P( C, D, A, B,  2, 15, 0x2AD7D2BB );
    P( B, C, D, A,  9, 21, 0xEB86D391 );
    
#undef F
    
    ctx->state[0] += A;
    ctx->state[1] += B;
    ctx->state[2] += C;
    ctx->state[3] += D;
}

