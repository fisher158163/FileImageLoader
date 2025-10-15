#include "StringUtils.h"
#include <cstring>
#include <cctype>

// 字符串长度
int stringLength(const char* str) {
    if (str == nullptr) {
        return 0;
    }
    return static_cast<int>(strlen(str));
}

// 字符串反转
void reverseString(char* str) {
    if (str == nullptr) {
        return;
    }
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - 1 - i];
        str[len - 1 - i] = temp;
    }
}

// 字符串转大写
void toUpperCase(char* str) {
    if (str == nullptr) {
        return;
    }
    for (int i = 0; str[i] != '\0'; i++) {
        str[i] = toupper(str[i]);
    }
}

// 字符串转小写
void toLowerCase(char* str) {
    if (str == nullptr) {
        return;
    }
    for (int i = 0; str[i] != '\0'; i++) {
        str[i] = tolower(str[i]);
    }
}

// 统计字符出现次数
int countChar(const char* str, char c) {
    if (str == nullptr) {
        return 0;
    }
    int count = 0;
    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] == c) {
            count++;
        }
    }
    return count;
}