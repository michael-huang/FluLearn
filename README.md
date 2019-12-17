安卓 Native+Flutter 应用开发实战及踩坑记录


## 入门资料

- [第三方共享包检索（国内）](https://pub.flutter-io.cn/flutter)、[第三方共享包检索（国外）](https://pub.dev/flutter)
- [Flutter开发环境搭建（中文版）](https://flutter.cn/docs/get-started/install)、[Flutter开发环境搭建（英文版）](https://flutter.dev/docs/get-started/install)
- [Flutter官方开发文档（中文版）](https://flutter.cn/docs)、[Flutter官方开发文档（英文版）](https://flutter.dev/docs)
- [Flutter官方API手册（国内）](https://api.flutter-io.cn)、[Flutter官方API手册（国外）](https://api.flutter.dev)
- [Dart与C/C++交互（国内）](https://dart.cn/guides/libraries/c-interop)、[[Dart与C/C++交互（国外）](https://dart.dev/guides/libraries/c-interop)
- [《Flutter实战》（在线电子书）](https://book.flutterchina.club)、[《Flutter实战》（仓库托管）](https://github.com/flutterchina/flutter-in-action)
- [闲鱼团队技术博客Flutter专题](https://www.yuque.com/xytech/flutter)
- [语义化版本介绍](https://semver.org/lang/zh-CN)、[依赖版本号前的插入符号(^)是什么？](https://codeday.me/bug/20190727/1549058.html)
- 新手入门项目推荐：[flutter-go](https://github.com/alibaba/flutter-go)、[Flutter-learning](https://github.com/AweiLoveAndroid/Flutter-learning)、
  [flutter_deer](https://github.com/simplezhli/flutter_deer)、[fun_android_flutter](https://github.com/phoenixsky/fun_android_flutter)

## 典型库包

- 获取APP版本信息（官方）：[package_info](https://github.com/flutter/plugins/tree/master/packages/package_info)
- 获取终端设备信息（官方）：[device_info](https://github.com/flutter/plugins/tree/master/packages/device_info)
- 启动任意Scheme的URL（官方）：[url_launcher](https://github.com/flutter/plugins/tree/master/packages/url_launcher)
- 键值存储（官方）：[shared_preferences](https://github.com/flutter/plugins/tree/master/packages/shared_preferences)
- 图片选择器（官方）：[image_picker](https://github.com/flutter/plugins/tree/master/packages/image_picker)
- 视频播放（官方）：[video_player](https://github.com/flutter/plugins/tree/master/packages/video_player)
- 相机（官方）：[camera](https://github.com/flutter/plugins/tree/master/packages/camera)
- Markdown文档（官方）：[flutter_markdown](https://github.com/flutter/flutter_markdown)
- 调试日志：[logger](https://github.com/leisim/logger)
- 吐司提示：[FlutterToast](https://github.com/PonnamKarthik/FlutterToast)
- 网络请求：[dio](https://github.com/flutterchina/dio)
- JSON对象存储：[localstorage](https://github.com/lesnitsky/flutter_localstorage)
- 通用工具类：[common_utils](https://github.com/Sky24n/common_utils)
- 网页加载/JsBridge：[flutter_inappwebview](https://github.com/pichillilorenzo/flutter_inappwebview)
- 下拉刷新上拉加载：[pull_to_refresh](https://github.com/peng8350/flutter_pulltorefresh)
- 占位/骨架屏：[content_placeholder](https://github.com/ctrleffive/content-placeholder)
- 路由导航：[fluro](https://github.com/theyakka/fluro)
- 强大的图片库：[extended_image](https://github.com/fluttercandies/extended_image)
- 滚轮选择器：[flutter_picker](https://github.com/yangyxd/flutter_picker)
- 仿WeUI的组件：[flutter-weui](https://github.com/allan-hx/flutter-weui)
- 腾讯QQ互联SDK：[fake_tencent](https://github.com/v7lin/fake_tencent)
- 微信SDK：[wechat_kit](https://github.com/v7lin/wechat_kit)
- 计时器：[timer_builder](https://github.com/aryzhov/flutter-timer-builder)
- 新功能指引：[showcaseview](https://github.com/simformsolutions/flutter_showcaseview)
- 下载器：[flutter_downloader](https://github.com/fluttercommunity/flutter_downloader)
- 快速滚动可拖拽的滚动条：[draggable_scrollbar](https://github.com/fluttercommunity/flutter-draggable-scrollbar)
- 字母索引列表：[azlistview](https://github.com/flutterchina/azlistview)
- 初始化就能弹窗的能力：[after_layout](https://github.com/fluttercommunity/flutter_after_layout)
- 加密解密：[encrypt](https://github.com/leocavalcante/encrypt)
- 压缩存档：[archive](https://github.com/brendan-duncan/archive)
- 手写签名：[flutter_signature_pad](https://github.com/kiwi-bop/flutter_signature_pad)
- SQLite数据库：[sqflite](https://github.com/tekartik/sqflite)
- ObjectBox数据库：[objectbox-dart](https://github.com/objectbox/objectbox-dart)
- PDF创建：[dart_pdf](https://github.com/DavBfr/dart_pdf)


## 踩坑记录

##### 安装完Flutter插件及Flutter SDK后，执行`flutter doctor`一直不动问题

```
这是因为被墙了，参阅官方文档《Using Flutter in China》：https://flutter.dev/community/china
其实也就是添加两个系统环境变量，Windows系统桌面右键点击我的电脑->属性->高级系统设置->环境变量：
PUB_HOSTED_URL=https://pub.flutter-io.cn
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
设置好上面两个环境变量后重启flutter_console.bat，再次执行`flutter doctor --verbose`即可。
```


##### 在Android Studio中准备好Dart & Flutter插件及SDK后，无法连接模拟器。

```
因为Android SDK的位置不是默认的C:\Users\Administrator\AppData\Local\Android\Sdk导致的，新增系统环境变量“ANDROID_HOME”指向自己的Android SDK的位置，在系统环境变量“Path”增加“%ANDROID_HOME%\platform-tools”，重启Android Studio即可。
```

### Android studio 配置flutter 出现“no devices”

这应该是Android的SDK路径不对引起的，解决办法：
```aidl
打开AndroidStudio的命令窗口（Terminal），输入指定你的AndroidSDK路径，如：
flutter config --android-sdk /home/liyujiang/android-sdk 
如果出现Setting "android-sdk" value to "/home/liyujiang/android-sdk".
则代表成功，重启AndroidStudio就可以了。
```


##### 运行提示“Android dependency 'androidx...' has different version for the compile...”。

```
这是多个安卓模块依赖的androidx版本冲突导致的，问题讨论参见 https://github.com/flutter/flutter/issues/27254#issuecomment-525616582
解决办法一：
Upgrade Android Gradle Plugin and Gradle to the latest version can solve this problem. For Android Studio 3.5, modify these:

android/build.gradle:
com.android.tools.build:gradle:3.5.0

android/gradle/wrapper/gradle-wrapper.properties:
distributionUrl=https\://services.gradle.org/distributions/gradle-5.4.1-all.zip
解决办法二：
Of course, you should manually set the same version via DependencyResolution. So, the following resolution strategy can also be used to resolve the conflicts of dependency :

android/gradle.properties:
androidxCoreVersion=1.0.0
androidxLifecycleVersion=2.0.0

android/build.gradle:
subprojects {
    project.configurations.all {
        resolutionStrategy {
            force "androidx.core:core:${androidxCoreVersion}"
            force "androidx.lifecycle:lifecycle-common:${androidxLifecycleVersion}"
        }
    }
}
```

~~##### Flutter I18N插件生成的“generated/i18n.dart”未包含arb中设置的语言？~~

~~```~~
~~可能是arb文件内容格式或命名不正确。必须是JSON格式，只能是一个层级的键值对，键名不能含下划线（最好用小驼峰命名法）~~
~~```~~



##### 构建正式包报错提示“Conflicting configuration : '...' in ndk abiFilters cannot be present when splits abi filters are set : ...”

```
这是因为使用带“--split-per-abi”参数（如flutter build apk --release --split-per-abi --target-platform android-arm）的构建命令和安卓原生的build.gradle里配置的“ndk.abiFilters”或“splits.abi”冲突，删掉“ndk.abiFilters”或“splits.abi”节点即可。
目测截止2019.8.28，Flutter的发布包貌似只支持armeabi-v7a及arm64-v8a，使用“--target-platform android-x86”参数构建会报错"android-x86" is not an allowed value for option "target-platform"。
```

#### 在app/build.gradle里配置CPU架构需注意有坑

- Debug模式运行main.dart打包的apk里libflutter.so只有有arm64-v8a、x86及x86_64。
- Release模式打包的apk里libflutter.so只支持armeabi-v7a、arm64-v8a、x86、x86_64。
- 不要在app/build.gradle里配置ndk节点，否则报错“Conflicting configuration : ...”
```
        ndk {
            //支持的CPU架构：armeabi、armeabi-v7a、arm64-v8a、x86、x86_64、mips、mips64
            //目前主流手机都支持armeabi和armeabi-v7a，电脑上的模拟器支持x86，mips基本不用于手机
            abiFilters "armeabi-v7a", "arm64-v8a"
        }
```
