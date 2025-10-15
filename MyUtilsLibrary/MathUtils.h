#ifndef MATHUTILS_H
#define MATHUTILS_H
#include <stdbool.h>  

#ifdef __cplusplus
extern "C" {
#endif

// 计算两个整数的和
int add(int a, int b);

// 计算两个整数的乘积
int multiply(int a, int b);

// 计算阶乘
long long factorial(int n);

// 判断是否为质数
bool isPrime(int n);

// 计算斐波那契数列第n项
long long fibonacci(int n);

#ifdef __cplusplus
}
#endif

#endif // MATHUTILS_H
