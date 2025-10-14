#ifndef STRINGUTILS_H
#define STRINGUTILS_H

#ifdef __cplusplus
extern "C" {
#endif

// 字符串长度
int stringLength(const char* str);

// 字符串反转（会修改原字符串）
void reverseString(char* str);

// 字符串转大写（会修改原字符串）
void toUpperCase(char* str);

// 字符串转小写（会修改原字符串）
void toLowerCase(char* str);

// 统计字符出现次数
int countChar(const char* str, char c);

#ifdef __cplusplus
}
#endif

#endif // STRINGUTILS_H