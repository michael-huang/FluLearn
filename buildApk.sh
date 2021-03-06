#!/usr/bin/env bash
#
# author:李玉江<1032694760@qq.com>
#
# 切换到当前脚本所在的目录
_CURRENT_FILE="${BASH_SOURCE[0]}"
_DIR_NAME="$(dirname "${_CURRENT_FILE}")"
echo "当前脚本：${_CURRENT_FILE}"
echo "脚本目录：${_DIR_NAME}"
cd "${_DIR_NAME}" || exit
echo "工作目录：${PWD}"

#==============================================================
# 以下为自动化构建，当然可考虑使用Github-Actions、Travis-CI等持续集成工具
#==============================================================

# 目标平台可选[android-arm (default), android-arm64 (default), android-x86, android-x64]
# 截止2019.8.28，Flutter的发布包貌似只支持armeabi-v7a及arm64-v8a
# 还不支持x86包构建？报错："android-x86" is not an allowed value for option "target-platform".
# 还不支持x64包构建？报错："android-x64" is not an allowed value for option "target-platform".
# 需注意和安卓原生的build.gradle里配置的“ndk.abiFilters”或“splits.abi”冲突

echo "清除上次构建的生成的文件"
flutter clean

if [[ $1 == "--debug" || $1 == "-d" ]]apt search

then
  _BUILD_TYPE="debug"
elif [[ $1 == "--profile" || $1 == "-p" ]]
then
  _BUILD_TYPE="profile"
else
  _BUILD_TYPE="release"
fi
echo "构建类型：${_BUILD_TYPE}"

_OUTPUT_PATH="${PWD}/build/app/outputs/apk/${_BUILD_TYPE}/app-armeabi-v7a-${_BUILD_TYPE}.apk"
_TARGET_PATH="${PWD}/app-armeabi-v7a-${_BUILD_TYPE}.apk"
echo -e "构建路径：${_OUTPUT_PATH}\t${_TARGET_PATH}"
_VERSION_NAME="1.0.0-dev"
_VERSION_CODE=`date +%Y%m%d`
echo "版本名称：v${_VERSION_NAME} build${_VERSION_CODE}"

flutter build apk --verbose\
  --${_BUILD_TYPE}\
  --no-pub\
  --no-track-widget-creation\
  --build-name=${_VERSION_NAME}\
  --build-number=${_VERSION_CODE}\
  --split-per-abi\
  --target-platform android-arm

rm ${_TARGET_PATH}
cp ${_OUTPUT_PATH} ${_TARGET_PATH}
