/***************************************************************************
*                                 
* 项目名称                     
*             __  __    _    ____                           
*             |  \/  |  / \  / ___|  ___ _ ____   _____ _ __ 
*             | |\/| | / _ \ \___ \ / _ \ '__\ \ / / _ \ '__|
*             | |  | |/ ___ \ ___) |  __/ |   \ V /  __/ |   
*             |_|  |_/_/   \_\____/ \___|_|    \_/ \___|_|
*
*
* Copyright (C) 2007 - 2009, 谷伟年 [Eric Goo] , <guwncn@gmail.com>.
* 本文件是ICE 接口文件,是客户端与服务器Stub代码生成的基础
* 文件修改记录:
*          2009-11-01 新建   by Eric Goo
*          2009-11-13 新增 reInitApp,getConfigure,loadPlugin接口  by Eric Goo
*          2009-11-19 新增 插件实现,可以自动加载外部插件  by Eric Goo
*		   2009-12-11 新增 execHCProc接口 by Eric Goo
*		   2009-01-06 调整了系统接口，删除了一些无用的接口，将接口改为异步调用方式
***************************************************************************/     

#ifndef MQ_INTERFACE_ICE
#define MQ_INTERFACE_ICE

module MQServerModule
{


interface MQInterface
{
	//接口版本信息
	string version();
	
	//服务器端时间
	string getTime();

	//获取服务器的配置信息
	/*  格式形如 key = value ,不同值之间以\n分隔
		[common]
		server=localhost
		tcp_port=8780
		ftp_port=21
		user_name=qatest
		user_passwd=123
		debug=1

		[pstyle]
		window_init_x=1288
		window_init_y=780
	*/
	//idempotent string getConfigure();
	string getConfigure(string segment,string key);

	
	//普通消息
	void sendOneway(string msg);   //最简单的UDP数据发送
	bool send(string msg);   //发送普通消息
	
	//通用命令支持
	int command(string cmd,string param,out string outmsg); 
	
	//插件接口
	int plugin(string pname,string func,string param,out string outmsg); 
	
	["ami","amd"] idempotent int selectCmd(string cmd,string sqlcode,string param,out string set,out string error);    //远程管理，用于查询
	["ami","amd"] idempotent int execCmd(string cmd,string sqlcode,string param,out string set,out string error);    //远程管理,用于执行SQL等


	//数据库相关接口
	["ami","amd"] idempotent int select(string sql,string param,out string set,out string error);    //远程查询数据库

	//数据库相关接口,提供分页查询接口
	["ami","amd"] idempotent int selectPage(
						string sql,string param,int iStart,int iCount,
						out string set,out string error);    //远程分页查询数据库


	["ami","amd"] bool execSQL(string sql,string param,out string error);    //远程执行数据库

	//远程执行存储过程
	["ami","amd"] bool execProc(string sql,string param,out string set,out string error);   

	
	//批量数据操作功能，可以一次性将一大批需要执行的SQL push至服务器端
	//sqlblock 每一不同语句之间以 字符 0x02为分隔符 
	//sID为客户端传给服务器端的识别码，可以用来查询执行的结果
	["ami","amd"]  bool execSQLBatch(string sqlblock,out string error);    //远程执行数据库
	
	
	//客户端业务日记接口
	idempotent bool writeBusiLog(string personid,string ip,string busiType,string comment);




	//针对异步接口,因为不可能一开始就返回结果值给客户端,因此客户端可以通过些接口来调用。
	//已经不再支持此接口
	bool getRespone(string sID,out string outinfo,out string error);
	
	//多次查询结果
	//下面接口暂时不支持
	idempotent bool desc(string sql,out string set,out string insertsql,out string error);    //远程查询表结构信息	
	idempotent bool selectPrepareByParam(string sql,string param,out string sID,out string error);  
	idempotent bool selectPrepare(string sql,out string sID,out string error);
	idempotent int  selectNext(string sID,out string set);
	idempotent bool selectFinish(string sID);


	
};


};

#endif
