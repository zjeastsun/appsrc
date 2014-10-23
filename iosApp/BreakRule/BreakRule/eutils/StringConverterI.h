// **********************************************************************
//
// Copyright (c) 2003-2010 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#ifndef STRING_CONVERTER_I_H
#define STRING_CONVERTER_I_H

#include <Ice/StringConverter.h>



//
// UTF-8 converter for LATIN-1
//
class StringConverterI : public Ice::StringConverter
{
public:
    
    StringConverterI();
    ~StringConverterI();
    
    virtual Ice::Byte* toUTF8(const char*, const char*, Ice::UTF8Buffer&) const;
    virtual void fromUTF8(const Ice::Byte*, const Ice::Byte*, std::string&) const;
};


/*
//这是个类strCoding (strCoding.h文件)
#pragma once
#include <iostream>
#include <string>
using namespace std;

class strCoding
{
public:
	strCoding(void);
	~strCoding(void);
    
	void UTF_8ToGB2312(string &pOut, char *pText, int pLen);//utf_8转为gb2312
	void GB2312ToUTF_8(string& pOut,char *pText, int pLen); //gb2312 转utf_8
	string UrlGB2312(char * str);                           //urlgb2312编码
	string UrlUTF8(char * str);                             //urlutf8 编码
	string UrlUTF8Decode(string str);                  //urlutf8解码
	string UrlGB2312Decode(string str);                //urlgb2312解码
    
    
private:
	void Gb2312ToUnicode(wchar_t* pOut,char *gbBuffer);
	void UTF_8ToUnicode(wchar_t* pOut,char *pText);
	void UnicodeToUTF_8(char* pOut,wchar_t* pText);
	void UnicodeToGB2312(char* pOut,wchar_t uData);
	char  CharToInt(char ch);
	char StrToBin(char *str);
    
};
*/

//把str编

#endif
