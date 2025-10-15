#!/bin/bash

LIBRARY_NAME="libMyUtils"
OUTPUT_DIR="build"
INCLUDE_DIR="include"

echo "🔨 编译 iOS 静态库..."

# 创建输出目录
mkdir -p ${OUTPUT_DIR}
mkdir -p ${INCLUDE_DIR}

# 1. 编译 arm64（真机）
echo "1️⃣ 编译 arm64（iOS 真机）..."
xcrun -sdk iphoneos clang++ -c MathUtils.cpp -o ${OUTPUT_DIR}/MathUtils_arm64.o \
    -arch arm64 \
    -std=c++11 \
    -O2 \
    -mios-version-min=12.0

xcrun -sdk iphoneos clang++ -c StringUtils.cpp -o ${OUTPUT_DIR}/StringUtils_arm64.o \
    -arch arm64 \
    -std=c++11 \
    -O2 \
    -mios-version-min=12.0

ar rcs ${OUTPUT_DIR}/${LIBRARY_NAME}_arm64.a \
    ${OUTPUT_DIR}/MathUtils_arm64.o ${OUTPUT_DIR}/StringUtils_arm64.o

echo "✅ 真机版本编译完成"

# 2. 编译 arm64（Apple Silicon 模拟器）- 关键修正
echo "2️⃣ 编译 arm64（iOS 模拟器 - Apple Silicon）..."
xcrun -sdk iphonesimulator clang++ -c MathUtils.cpp -o ${OUTPUT_DIR}/MathUtils_sim_arm64.o \
    -arch arm64 \
    -std=c++11 \
    -O2 \
    -mios-version-min=12.0 \
    -target arm64-apple-ios12.0-simulator

xcrun -sdk iphonesimulator clang++ -c StringUtils.cpp -o ${OUTPUT_DIR}/StringUtils_sim_arm64.o \
    -arch arm64 \
    -std=c++11 \
    -O2 \
    -mios-version-min=12.0 \
    -target arm64-apple-ios12.0-simulator

ar rcs ${OUTPUT_DIR}/${LIBRARY_NAME}_sim_arm64.a \
    ${OUTPUT_DIR}/MathUtils_sim_arm64.o ${OUTPUT_DIR}/StringUtils_sim_arm64.o

echo "✅ Apple Silicon 模拟器版本编译完成"

# 3. 编译 x86_64（Intel 模拟器）
echo "3️⃣ 编译 x86_64（iOS 模拟器 - Intel）..."
xcrun -sdk iphonesimulator clang++ -c MathUtils.cpp -o ${OUTPUT_DIR}/MathUtils_x86_64.o \
    -arch x86_64 \
    -std=c++11 \
    -O2 \
    -mios-version-min=12.0 \
    -target x86_64-apple-ios12.0-simulator

xcrun -sdk iphonesimulator clang++ -c StringUtils.cpp -o ${OUTPUT_DIR}/StringUtils_x86_64.o \
    -arch x86_64 \
    -std=c++11 \
    -O2 \
    -mios-version-min=12.0 \
    -target x86_64-apple-ios12.0-simulator

ar rcs ${OUTPUT_DIR}/${LIBRARY_NAME}_x86_64.a \
    ${OUTPUT_DIR}/MathUtils_x86_64.o ${OUTPUT_DIR}/StringUtils_x86_64.o

echo "✅ Intel 模拟器版本编译完成"

# 4. 创建 XCFramework
echo "4️⃣ 创建 XCFramework..."

# 复制头文件到临时目录
cp MathUtils.h ${INCLUDE_DIR}/
cp StringUtils.h ${INCLUDE_DIR}/

xcodebuild -create-xcframework \
    -library ${OUTPUT_DIR}/${LIBRARY_NAME}_arm64.a -headers ${INCLUDE_DIR} \
    -library ${OUTPUT_DIR}/${LIBRARY_NAME}_sim_arm64.a -headers ${INCLUDE_DIR} \
    -library ${OUTPUT_DIR}/${LIBRARY_NAME}_x86_64.a -headers ${INCLUDE_DIR} \
    -output ${OUTPUT_DIR}/MyUtils.xcframework

# 5. 清理中间文件
echo "5️⃣ 清理中间文件..."
rm ${OUTPUT_DIR}/*.o

echo ""
echo "✅ 编译完成！"
echo ""
echo "📦 生成的文件："
echo "   - ${OUTPUT_DIR}/${LIBRARY_NAME}_arm64.a              (真机)"
echo "   - ${OUTPUT_DIR}/${LIBRARY_NAME}_sim_arm64.a          (Apple Silicon 模拟器)"
echo "   - ${OUTPUT_DIR}/${LIBRARY_NAME}_x86_64.a             (Intel 模拟器)"
echo "   - ${OUTPUT_DIR}/MyUtils.xcframework             (推荐使用)"
echo ""
echo "🎯 使用 MyUtils.xcframework 即可同时支持真机和模拟器！"