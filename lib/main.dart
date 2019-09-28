import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/constant.dart';
import 'package:flutter_app/toolkit/language_kit.dart';
import 'package:flutter_app/toolkit/log.dart';
import 'package:flutter_app/toolkit/overlay_style.dart';
import 'package:flutter_app/toolkit/route_navigator.dart';
import 'package:flutter_app/toolkit/theme_kit.dart';
import 'package:flutter_app/ui/empty/empty_router.dart';
import 'package:flutter_app/ui/guide/guide_router.dart';
import 'package:flutter_app/ui/home/home_page.dart';
import 'package:flutter_app/ui/home/home_router.dart';
import 'package:flutter_app/ui/login/login_router.dart';
import 'package:flutter_app/ui/splash/splash_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<MyAppState> appStateKey = new GlobalKey<MyAppState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  L.d('app init start');
  OverlayStyle.setOverlayStyle(Brightness.dark);
  RouteNavigator.registerRouter([
    new EmptyRouter(),
    new GuideRouter(),
    new HomeRouter(),
    new LoginRouter(),
  ]);
  await SpUtil.getInstance();
  await I18NDelegate(LanguageKit.locale).load(null);
  L.d('app init end');
  runApp(MyApp(key: appStateKey));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale;
  ThemeData _themeData;

  @override
  void initState() {
    super.initState();
    _locale = LanguageKit.locale;
    _themeData = ThemeKit.themeData;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //右上角调试标记
      debugShowCheckedModeBanner: true,
      //主题色彩
      theme: _themeData,
      //主入口页面
      home: Constant.SPLASH_SECONDS > 1 ? SplashPage() : HomePage(),
      //生成页面路由（用于Router）
      onGenerateRoute: RouteNavigator.router.generator,
      //生成页面标题（用于AppBar）
      onGenerateTitle: (context) {
        return I18N.translate(context, 'appName');
      },
      //区域设置，用于语言、日期时间、文字方向等本地化
      locale: _locale,
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        new I18NDelegate(_locale),
      ],
    );
  }

  void changeLocale(Locale locale) {
    setState(() {
      L.d('change locale to $locale from $_locale');
      _locale = locale;
    });
  }

  void changeThemeData(ThemeData themeData) {
    setState(() {
      L.d('''change theme data
            to ${themeData.brightness} ${themeData.primaryColor}
            from ${_themeData.brightness} ${_themeData.primaryColor}''');
      _themeData = themeData;
    });
  }
}
