#include "Eutils.h"

#include "sqlite3.h"


sqlite3*	_db;

#define SET_SQLITE_ERROR \
util::string_format(_sError,"%s", sqlite3_errmsg(_db));\
wlog("%s\n",_sError.c_str());

#define SET_SQLITE_ERROR2(p) \
util::string_format(_sError,"%s", sqlite3_errmsg(_db));\
wlog("%s\n",_sError.c_str());\
p = _sError;

string getValue(sqlite3_stmt* res,int idx);

CSQLiteUtil::CSQLiteUtil()
{
	_bconnected = false;
    
	_db =  NULL;
}
CSQLiteUtil::~CSQLiteUtil()
{
	logout();
}


bool CSQLiteUtil::login(const std::string& file)
{
	_bconnected = false;
    
    
	int rc = sqlite3_open(file.c_str(), &_db);
	
	if ( rc )
	{
		SET_SQLITE_ERROR;
		sqlite3_close(_db);
		return false;
	}
    
    
	_bconnected = true;
    
	return true;
}

void CSQLiteUtil::logout()
{
	_bconnected = false;
    
	if (_db)
		sqlite3_close(_db);
}

bool CSQLiteUtil::isLogin()
{
	return _bconnected;
}

int CSQLiteUtil::select(const string& sql,CSelectHelp& help,string& error)
{
	if ( !isLogin() )
	{
		return -1;
	}
    
    help.reset();
	sqlite3_stmt *res; ///< Stored result
    
	const char *s = NULL;
	int rc = sqlite3_prepare(_db, sql.c_str(), static_cast<int>(sql.length()), &res, &s);
    
	if (rc != SQLITE_OK)
	{
		SET_SQLITE_ERROR2(error);
		return -1;
	}
	if (!res)
	{
		SET_SQLITE_ERROR2(error);
		return -1;
	}
    
	//增加字段列表
	int iFields = sqlite3_column_count(res);
	for(int i=0;i<iFields;i++)
	{
		
		const char *p = sqlite3_column_name(res, i);
		
		if (!p)
		{
			help.addField("");
			continue;
		}
		//wlog("%s-type=%d\n",p,sqlite3_column_type(res,i));
		help.addField(p,p);
	}
    
    
    
	rc = sqlite3_step(res);
	if ( rc == SQLITE_BUSY ||
        rc == SQLITE_ERROR ||
        rc == SQLITE_MISUSE)
	{
		SET_SQLITE_ERROR2(error);;
		//关掉游标
		sqlite3_finalize(res);
		return -1;
	}
	if ( rc == SQLITE_DONE )
	{
		//关掉游标
		sqlite3_finalize(res);
		return 0;
	}
	
	int j=0;
	while( rc == SQLITE_ROW )
	{
		//增加一行数据
		table_line line;
		for(j=0;j<iFields;j++)
		{
			line.push_back(getValue(res,j));
            
		}
		help.addValue(line);
        
		rc = sqlite3_step(res);
        
	}
	//关掉游标
	sqlite3_finalize(res);
    
	return help._count;
}
int CSQLiteUtil::select(const string& sql,string& out,string& error)
{
	CSelectHelp help;
	int ic = select(sql,help,error);
    
	out = help.toString();
    
//	return help._count;
    return ic;
}

bool CSQLiteUtil::execSQL(const string& sql,string& error)
{
	int rc = 0;
	char * errMsg = NULL;
	rc = sqlite3_exec(_db,sql.c_str(),0,0,&errMsg);
	if ( rc != SQLITE_OK )
	{
		_sError = errMsg;
		error = errMsg;
		return false;
	}
    
	return true;
}

//将blob文件存到文件中
int CSQLiteUtil::getBlob(const string& sql,const string& sField,const string& sFieldFileName,const string& sDir)
{
	string fileName= "";
	sqlite3_stmt *stmt;
    
	//选取该条数据
    
	int iSize = 0;
    
	int rc;
	rc = sqlite3_prepare(_db, sql.c_str(), -1, &stmt, 0);
	if (rc != SQLITE_OK)
	{
		stmt = NULL;
		return -1;
	}
	rc = sqlite3_step(stmt);
	if ( rc != SQLITE_OK  && rc != SQLITE_DONE && rc != SQLITE_ROW)
	{
        
		return -1;
	}
	//得到记录中的BLOB字段
	int iBlobIdx = -1;
	
	int iFields = sqlite3_column_count(stmt);
	int iFileName = -1;
    
	int i=0;
	for(i=0;i<iFields;i++)
	{
        
		const char *p = sqlite3_column_name(stmt, i);
        
        
		if ( p != NULL )
		{
			if (gstricmp_gu(p,sField.c_str()) == 0 )
			{
                
				iBlobIdx = i;
			}
            
			if (gstricmp_gu(p,sFieldFileName.c_str()) == 0 )
			{
                
				iFileName = i;
			}
		}
        
	}
	if ( iBlobIdx < 0 || iFileName < 0  ) return -1;
    
    
	string sDBFileName = getValue(stmt,iFileName);
    
	Byte *pContent = (Byte*) sqlite3_column_blob(stmt, iBlobIdx);
    
	if ( pContent )
	{
		iSize = sqlite3_column_bytes(stmt, iBlobIdx);
	}
    
	//写文件
	if ( iSize >0 && pContent != NULL )
	{
		string sNewFile;
		util::string_format(sNewFile,"%s/%s",sDir.c_str(),sDBFileName.c_str());
        
		int ic = util::write2File(pContent,iSize,sNewFile);
        
		if ( ic < 0 )
		{
			wlog("写入文件[%s] 失败\n",sNewFile.c_str());
            
		}
	}
    
	sqlite3_finalize(stmt);
    
	return iSize;
    
}
//插入一个二进制流数据
bool CSQLiteUtil::insertBlob(const string& sql,const string& file,string& error)
{
	//读文件至BUF
	FILE *fp;
	long filesize = 0;
	Byte* ffile=NULL;
	fp = fopen(file.c_str(), "rb");
	if(fp != NULL)
	{
		//计算文件的大小
		fseek(fp, 0, SEEK_END);
		filesize = ftell(fp);
		fseek(fp, 0, SEEK_SET);
        
		//读取文件
		ffile = new Byte[filesize+1];
		memset(ffile,0x00,filesize+1);
		fread(ffile, sizeof(Byte), filesize, fp);
		fclose(fp);
	}
	else
	{
		return false;
        
	}
    
	sqlite3_stmt *stmt;
    
    
	int rc = sqlite3_prepare(_db, sql.c_str(), -1, &stmt, 0);
    
	if (rc != SQLITE_OK || stmt == NULL)
	{
		SET_SQLITE_ERROR2(error);
		return false;
	}
    
    
	//将文件数据绑定到insert语句中，替换“？”部分
	int index = sqlite3_bind_parameter_index(stmt, ":bindata");
    
	rc = sqlite3_bind_blob(stmt, index, ffile, static_cast<int>(filesize), NULL);
	if ( rc != SQLITE_OK )
	{
		SET_SQLITE_ERROR2(error);
		if ( ffile != NULL )
			delete ffile;
		return false;
	}
    
	//执行绑定之后的SQL语句
	rc = sqlite3_step(stmt);
	if ( rc != SQLITE_DONE )
	{
		SET_SQLITE_ERROR2(error);
		if ( ffile != NULL )
			delete ffile;
		return false;
	}
    
    
	if ( ffile != NULL )
		delete ffile;
    
    
	return true;
}

bool CSQLiteUtil::updateBlob(const string& sql,const string& file,string& error)
{
	//读文件至BUF
	FILE *fp;
	long filesize = 0;
	Byte* ffile=NULL;
	fp = fopen(file.c_str(), "rb");
	if(fp != NULL)
	{
		//计算文件的大小
		fseek(fp, 0, SEEK_END);
		filesize = ftell(fp);
		fseek(fp, 0, SEEK_SET);
        
		//读取文件
		ffile = new Byte[filesize+1];
		memset(ffile,0x00,filesize+1);
		fread(ffile, sizeof(Byte), filesize, fp);
		fclose(fp);
	}
	else
	{
		return false;
        
	}
    
	sqlite3_stmt *stmt;
    
    
	int rc = sqlite3_prepare(_db, sql.c_str(), -1, &stmt, 0);
    
	if (rc != SQLITE_OK || stmt == NULL)
	{
		util::string_format(error,"%s", sqlite3_errmsg(_db));
		return false;
	}
    
    
	//将文件数据绑定到insert语句中，替换“？”部分
	int index = sqlite3_bind_parameter_index(stmt, ":bindata");
    
	rc = sqlite3_bind_blob(stmt, index, ffile, static_cast<int>(filesize), NULL);
	if ( rc != SQLITE_OK )
	{
		if ( ffile != NULL )
			delete ffile;
        
		util::string_format(error,"%s", sqlite3_errmsg(_db));
		return false;
	}
    
	//执行绑定之后的SQL语句
	rc = sqlite3_step(stmt);
	if ( rc != SQLITE_DONE )
	{
		if ( ffile != NULL )
			delete ffile;
        
		util::string_format(error,"%s", sqlite3_errmsg(_db));
		return false;
	}
    
    
	if ( ffile != NULL )
		delete ffile;
    
    
	return true;
}
//插入一个二进制流数据
bool CSQLiteUtil::insertBlob(const string& sql,Byte* ffile,int filesize,string& error)
{
	//读文件至BUF
	
	if ( ffile == NULL ) return false;
    
	sqlite3_stmt *stmt;
    
    
	int rc = sqlite3_prepare(_db, sql.c_str(), -1, &stmt, 0);
    
	if (rc != SQLITE_OK || stmt == NULL)
	{
		return false;
	}
    
    
	//将文件数据绑定到insert语句中，替换“？”部分
	int index = sqlite3_bind_parameter_index(stmt, ":bindata");
    
	rc = sqlite3_bind_blob(stmt, index, ffile, filesize, NULL);
	if ( rc != SQLITE_OK )
	{
		if ( ffile != NULL )
			delete ffile;
		return false;
	}
    
	//执行绑定之后的SQL语句
	rc = sqlite3_step(stmt);
	if ( rc != SQLITE_DONE )
	{
		if ( ffile != NULL )
			delete ffile;
		return false;
	}
    
    
	if ( ffile != NULL )
		delete ffile;
    
    
	sqlite3_finalize(stmt);
	return true;
}

//获取blob数据
int CSQLiteUtil::getBlob(const string& sql,const string& sField,Byte* pContent)
{
	string fileName= "";
	sqlite3_stmt *stmt;
    
	//选取该条数据
    
	int iSize = 0;
    
	int rc;
	rc = sqlite3_prepare(_db, sql.c_str(), -1, &stmt, 0);
	if (rc != SQLITE_OK)
	{
		stmt = NULL;
		return -1;
	}
	rc = sqlite3_step(stmt);
	if ( rc != SQLITE_OK  && rc != SQLITE_DONE && rc != SQLITE_ROW)
	{
        
		return -1;
	}
	//得到记录中的BLOB字段
	int i = 0;
	int iFields = sqlite3_column_count(stmt);
	for(i=0;i<iFields;i++)
	{
        
		const char *p = sqlite3_column_name(stmt, i);
        
		
		if ( p != NULL )
		{
			if (gstricmp_gu(p,sField.c_str()) == 0 )
			{
                
				break;
			}
		}
        
	}
	if ( i >= iFields ) return -1;
	
    
	pContent = (Byte*) sqlite3_column_blob(stmt, i);
	
	if ( pContent )
	{
		iSize = sqlite3_column_bytes(stmt, i);
	}
    
	sqlite3_finalize(stmt);
    
	return iSize;
    
}
//事务功能
bool CSQLiteUtil::begin()
{
	//在开始之前务必先做一次提交，省得死锁
	commit();
    
	char * errMsg = NULL;
	int rc= sqlite3_exec( _db, "begin transaction", 0, 0, &errMsg ); //开始一个事务
	
	if ( rc != SQLITE_OK )
	{
		_sError = errMsg;
		return false;
	}
    
	return true;
}

//
bool CSQLiteUtil::commit()
{
	char * errMsg = NULL;
	int rc= sqlite3_exec( _db, "commit transaction", 0, 0, &errMsg ); //开始一个事务
	
	if ( rc != SQLITE_OK )
	{
		_sError = errMsg;
		return false;
	}
	return true;
}
bool CSQLiteUtil::rollback()
{
	char * errMsg = NULL;
	int rc= sqlite3_exec( _db, "rollback transaction", 0, 0, &errMsg ); //开始一个事务
	
	if ( rc != SQLITE_OK )
	{
		_sError = errMsg;
		return false;
	}
	return true;
}

std::string& CSQLiteUtil::getMsg(string& error)
{
	error =  _sError;
	return error;
}

string getValue(sqlite3_stmt* res,int idx)
{
	const unsigned char* pStr = NULL;
	int type =  sqlite3_column_type(res, idx) ;
	string sReturn = "";
    
	switch(type)
	{
        case SQLITE_INTEGER:
            util::string_format(sReturn,"%d",sqlite3_column_int(res,idx));
            break;
        case SQLITE_FLOAT:
            util::string_format(sReturn,"%f",sqlite3_column_double(res,idx));
            if ( sReturn.find(".") != std::string::npos )
            {
                util::trim_right(sReturn,"0");
                util::trim_right(sReturn,".");
            }
            break;
        case SQLITE_BLOB:
            //sqlite3_column_bytes(res, 0);
            //(void*) sqlite3_column_blob(res, 0);
            sReturn = "blob";
            break;
            
        case SQLITE_NULL:
            sReturn = "";
            break;
        case SQLITE3_TEXT:
            pStr= sqlite3_column_text(res, idx);
            if ( pStr )
            {
                sReturn = (char*)pStr;
            }
            break;
        default:
            sReturn = "";
            break;
	};
    
    
	return sReturn;
}


