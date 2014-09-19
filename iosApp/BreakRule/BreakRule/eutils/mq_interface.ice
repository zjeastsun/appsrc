/***************************************************************************
*                                 
* ��Ŀ����                     
*             __  __    _    ____                           
*             |  \/  |  / \  / ___|  ___ _ ____   _____ _ __ 
*             | |\/| | / _ \ \___ \ / _ \ '__\ \ / / _ \ '__|
*             | |  | |/ ___ \ ___) |  __/ |   \ V /  __/ |   
*             |_|  |_/_/   \_\____/ \___|_|    \_/ \___|_|
*
*
* Copyright (C) 2007 - 2009, ��ΰ�� [Eric Goo] , <guwncn@gmail.com>.
* ���ļ���ICE �ӿ��ļ�,�ǿͻ����������Stub�������ɵĻ���
* �ļ��޸ļ�¼:
*          2009-11-01 �½�   by Eric Goo
*          2009-11-13 ���� reInitApp,getConfigure,loadPlugin�ӿ�  by Eric Goo
*          2009-11-19 ���� ���ʵ��,�����Զ������ⲿ���  by Eric Goo
*		   2009-12-11 ���� execHCProc�ӿ� by Eric Goo
*		   2009-01-06 ������ϵͳ�ӿڣ�ɾ����һЩ���õĽӿڣ����ӿڸ�Ϊ�첽���÷�ʽ
***************************************************************************/     

#ifndef MQ_INTERFACE_ICE
#define MQ_INTERFACE_ICE

module MQServerModule
{


interface MQInterface
{
	//�ӿڰ汾��Ϣ
	string version();
	
	//��������ʱ��
	string getTime();

	//��ȡ��������������Ϣ
	/*  ��ʽ���� key = value ,��ֵ֮ͬ����\n�ָ�
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

	
	//��ͨ��Ϣ
	void sendOneway(string msg);   //��򵥵�UDP���ݷ���
	bool send(string msg);   //������ͨ��Ϣ
	
	//ͨ������֧��
	int command(string cmd,string param,out string outmsg); 
	
	//����ӿ�
	int plugin(string pname,string func,string param,out string outmsg); 
	
	["ami","amd"] idempotent int selectCmd(string cmd,string sqlcode,string param,out string set,out string error);    //Զ�̹������ڲ�ѯ
	["ami","amd"] idempotent int execCmd(string cmd,string sqlcode,string param,out string set,out string error);    //Զ�̹���,����ִ��SQL��


	//���ݿ���ؽӿ�
	["ami","amd"] idempotent int select(string sql,string param,out string set,out string error);    //Զ�̲�ѯ���ݿ�

	//���ݿ���ؽӿ�,�ṩ��ҳ��ѯ�ӿ�
	["ami","amd"] idempotent int selectPage(
						string sql,string param,int iStart,int iCount,
						out string set,out string error);    //Զ�̷�ҳ��ѯ���ݿ�


	["ami","amd"] bool execSQL(string sql,string param,out string error);    //Զ��ִ�����ݿ�

	//Զ��ִ�д洢����
	["ami","amd"] bool execProc(string sql,string param,out string set,out string error);   

	
	//�������ݲ������ܣ�����һ���Խ�һ������Ҫִ�е�SQL push����������
	//sqlblock ÿһ��ͬ���֮���� �ַ� 0x02Ϊ�ָ��� 
	//sIDΪ�ͻ��˴����������˵�ʶ���룬����������ѯִ�еĽ��
	["ami","amd"]  bool execSQLBatch(string sqlblock,out string error);    //Զ��ִ�����ݿ�
	
	
	//�ͻ���ҵ���ռǽӿ�
	idempotent bool writeBusiLog(string personid,string ip,string busiType,string comment);




	//����첽�ӿ�,��Ϊ������һ��ʼ�ͷ��ؽ��ֵ���ͻ���,��˿ͻ��˿���ͨ��Щ�ӿ������á�
	//�Ѿ�����֧�ִ˽ӿ�
	bool getRespone(string sID,out string outinfo,out string error);
	
	//��β�ѯ���
	//����ӿ���ʱ��֧��
	idempotent bool desc(string sql,out string set,out string insertsql,out string error);    //Զ�̲�ѯ��ṹ��Ϣ	
	idempotent bool selectPrepareByParam(string sql,string param,out string sID,out string error);  
	idempotent bool selectPrepare(string sql,out string sID,out string error);
	idempotent int  selectNext(string sID,out string set);
	idempotent bool selectFinish(string sID);


	
};


};

#endif
