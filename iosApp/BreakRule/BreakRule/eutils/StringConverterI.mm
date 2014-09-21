// **********************************************************************
//
// Copyright (c) 2003-2010 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#include <Ice/Ice.h>
#include "StringConverterI.h"

using namespace std;

strCoding  g_code;

StringConverterI::StringConverterI()
{
}

StringConverterI::~StringConverterI()
{
}

Ice::Byte*
StringConverterI::toUTF8(const char* sourceStart, const char* sourceEnd, Ice::UTF8Buffer& buffer) const
{
    size_t inputSize = static_cast<size_t>(sourceEnd - sourceStart);
    size_t chunkSize = std::max<size_t>(inputSize, 6);
    size_t outputBytesLeft = chunkSize;
    
    Ice::Byte* targetStart = buffer.getMoreBytes(chunkSize, 0);
    size_t offset = 0;
    
    for(unsigned int i = 0; i < inputSize; ++i)
    {
        unsigned char byte = sourceStart[i];
        if(byte <= 0x7F)
        {
            if(outputBytesLeft == 0)
            {
                targetStart = buffer.getMoreBytes(chunkSize, targetStart + chunkSize);
                offset = 0;
            }
            
            targetStart[offset] = byte;
            
            ++offset;
            --outputBytesLeft;
        }
        else
        {
            if(outputBytesLeft <= 1)
            {
                targetStart = buffer.getMoreBytes(chunkSize, targetStart + chunkSize - outputBytesLeft);
                offset = 0;
            }
            
            targetStart[offset] = 0xC0 | ((byte & 0xC0) >> 6);
            targetStart[offset + 1] = 0x80 | (byte & 0x3F);
            
            offset += 2;
            outputBytesLeft -= 2;
        }
    }
    
    return targetStart + offset;
}

void
StringConverterI::fromUTF8(const Ice::Byte* sourceStart, const Ice::Byte* sourceEnd,
                           string& target) const
{
    
	//strCoding cd;
	
    size_t inSize = static_cast<size_t>(sourceEnd - sourceStart);
	target.resize(inSize);
    
//	g_code.UTF_8ToGB2312(target,(char*)sourceStart,inSize);
    
//	//target.resize();
//	return;
	
    
    unsigned int targetIndex = 0;
    unsigned int i = 0;
    while(i < inSize)
    {
        if((sourceStart[i] & 0xC0) == 0xC0)
        {
            if(i + 1 >= inSize)
            {
                throw Ice::StringConversionException(__FILE__, __LINE__, "UTF-8 string source exhausted");
            }
            target[targetIndex] = (sourceStart[i] & 0x03) << 6;
            target[targetIndex] = target[targetIndex] | (sourceStart[i + 1] & 0x3F);
            i += 2;
        }
        else
        {
            target[targetIndex] = sourceStart[i];
            ++i;
        }
        ++targetIndex;
    }
    
    target.resize(targetIndex);
	printf("%s\n",target.c_str());
}


//////////////////////////////////////////////////////////////////////////

//这是个类strCoding (strCoding.cpp文件)


strCoding::strCoding(void)
{
}

strCoding::~strCoding(void)
{
}
void strCoding::Gb2312ToUnicode(wchar_t* pOut,char *gbBuffer)
{
//	::MultiByteToWideChar(CP_ACP,MB_PRECOMPOSED,gbBuffer,2,pOut,1);
	return;
}
void strCoding::UTF_8ToUnicode(wchar_t* pOut,char *pText)
{
	char* uchar = (char *)pOut;
    
	uchar[1] = ((pText[0] & 0x0F) << 4) + ((pText[1] >> 2) & 0x0F);
	uchar[0] = ((pText[1] & 0x03) << 6) + (pText[2] & 0x3F);
    
	return;
}

void strCoding::UnicodeToUTF_8(char* pOut,wchar_t* pText)
{
	// 注意 WCHAR高低字的顺序,低字节在前，高字节在后
	char* pchar = (char *)pText;
    
	pOut[0] = (0xE0 | ((pchar[1] & 0xF0) >> 4));
	pOut[1] = (0x80 | ((pchar[1] & 0x0F) << 2)) + ((pchar[0] & 0xC0) >> 6);
	pOut[2] = (0x80 | (pchar[0] & 0x3F));
    
	return;
}
void strCoding::UnicodeToGB2312(char* pOut,wchar_t uData)
{
//	WideCharToMultiByte(CP_ACP,NULL,&uData,1,pOut,sizeof(wchar_t),NULL,NULL);
	return;
}

//做为解Url使用
char strCoding:: CharToInt(char ch){
	if(ch>='0' && ch<='9')return (char)(ch-'0');
	if(ch>='a' && ch<='f')return (char)(ch-'a'+10);
	if(ch>='A' && ch<='F')return (char)(ch-'A'+10);
	return -1;
}
char strCoding::StrToBin(char *str){
	char tempWord[2];
	char chn;
    
	tempWord[0] = CharToInt(str[0]);                         //make the B to 11 -- 00001011
	tempWord[1] = CharToInt(str[1]);                         //make the 0 to 0  -- 00000000
    
	chn = (tempWord[0] << 4) | tempWord[1];                //to change the BO to 10110000
    
	return chn;
}


//UTF_8 转gb2312
void strCoding::UTF_8ToGB2312(string &pOut, char *pText, int pLen)
{
	char buf[4];
	char* rst = new char[pLen + (pLen >> 2) + 2];
	memset(buf,0,4);
	memset(rst,0,pLen + (pLen >> 2) + 2);
    
	int i =0;
	int j = 0;
    
	while(i < pLen)
	{
		if(*(pText + i) >= 0)
		{
            
			rst[j++] = pText[i++];
		}
		else
		{
			wchar_t Wtemp;
            
            
			UTF_8ToUnicode(&Wtemp,pText + i);
            
			UnicodeToGB2312(buf,Wtemp);
            
			unsigned short int tmp = 0;
			tmp = rst[j] = buf[0];
			tmp = rst[j+1] = buf[1];
			tmp = rst[j+2] = buf[2];
            
			//newBuf[j] = Ctemp[0];
			//newBuf[j + 1] = Ctemp[1];
            
			i += 3;
			j += 2;
		}
        
	}
	rst[j]='\0';
	pOut = rst;
	delete []rst;
}

//GB2312 转为 UTF-8
void strCoding::GB2312ToUTF_8(string& pOut,char *pText, int pLen)
{
	char buf[4];
	memset(buf,0,4);
    
	pOut.clear();
    
	int i = 0;
	while(i < pLen)
	{
		//如果是英文直接复制就可以
		if( pText[i] >= 0)
		{
			char asciistr[2]={0};
			asciistr[0] = (pText[i++]);
			pOut.append(asciistr);
		}
		else
		{
			wchar_t pbuffer;
			Gb2312ToUnicode(&pbuffer,pText+i);
            
			UnicodeToUTF_8(buf,&pbuffer);
            
			pOut.append(buf);
            
			i += 2;
		}
	}
    
	return;
}
//把str编码为网页中的 GB2312 url encode ,英文不变，汉字双字节  如%3D%AE%88
string strCoding::UrlGB2312(char * str)
{
	string dd;
	size_t len = strlen(str);
	for (size_t i=0;i<len;i++)
	{
		if(isalnum((Byte)str[i]))
		{
			char tempbuff[2];
			sprintf(tempbuff,"%c",str[i]);
			dd.append(tempbuff);
		}
		else if (isspace((Byte)str[i]))
		{
			dd.append("+");
		}
		else
		{
			char tempbuff[4];
			sprintf(tempbuff,"%%%X%X",((Byte*)str)[i] >>4,((Byte*)str)[i] %16);
			dd.append(tempbuff);
		}
        
	}
	return dd;
}

//把str编码为网页中的 UTF-8 url encode ,英文不变，汉字三字节  如%3D%AE%88

string strCoding::UrlUTF8(char * str)
{
	string tt;
	string dd;
	GB2312ToUTF_8(tt,str,(int)strlen(str));
    
	size_t len=tt.length();
	for (size_t i=0;i<len;i++)
	{
		if(isalnum((Byte)tt.at(i)))
		{
			char tempbuff[2]={0};
			sprintf(tempbuff,"%c",(Byte)tt.at(i));
			dd.append(tempbuff);
		}
		else if (isspace((Byte)tt.at(i)))
		{
			dd.append("+");
		}
		else
		{
			char tempbuff[4];
			sprintf(tempbuff,"%%%X%X",((Byte)tt.at(i)) >>4,((Byte)tt.at(i)) %16);
			dd.append(tempbuff);
		}
        
	}
	return dd;
}
//把url GB2312解码
string strCoding::UrlGB2312Decode(string str)
{
	string output="";
	char tmp[2];
	int i=0,len=str.length();
    
	while(i<len){
		if(str[i]=='%'){
			tmp[0]=str[i+1];
			tmp[1]=str[i+2];
			output += StrToBin(tmp);
			i=i+3;
		}
		else if(str[i]=='+'){
			output+=' ';
			i++;
		}
		else{
			output+=str[i];
			i++;
		}
	}
    
	return output;
}
//把url utf8解码
string strCoding::UrlUTF8Decode(string str)
{
	string output="";
    
	string temp =UrlGB2312Decode(str);//
    
	UTF_8ToGB2312(output,(char *)temp.data(),strlen(temp.data()));
    
	return output;
    
}

