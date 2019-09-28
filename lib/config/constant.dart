///
/// 常量集中管理
///
class Constant {
  ///
  /// 调试开关，上线需要关闭
  /// 运行在Release环境时为true；运行在Debug和Profile环境时为false
  ///
  static const bool ENABLE_DEBUG =
      !const bool.fromEnvironment("dart.vm.product");

  ///
  /// 闪屏时长，大于1秒才显示闪屏页
  ///
  static const int SPLASH_SECONDS = 5;

  ///
  /// 服务端接口基础地址
  ///
  static const String BASE_API_URL = 'http://hn216.api.yesapi.cn/';

  ///
  /// 内置支持的语言
  ///
  static const List<String> SUPPORT_LANGUAGE = ['en', 'zh_CN'];
}
