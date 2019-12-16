import 'dart:convert';
import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_app/config/asset_dir.dart';
import 'package:flutter_app/config/constant.dart';
import 'package:flutter_app/config/prefs_key.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/toolkit/log.dart';
import 'package:intl/intl_standalone.dart' as intl;

///
/// 本地化语言工具类
///
/// 语言标签参见：http://www.localeplanet.com/icu/
/// 语言代码参见 https://baike.baidu.com/item/ISO%20639-1
/// 区域脚本代码 https://github.com/unicode-org/cldr/blob/master/common/validity/script.xml
/// 国家或地区代码参见 https://baike.baidu.com/item/ISO%203166-1
///
class LanguageKit {
  static int _languageIndex = -1;

  static Locale get locale {
    //Same as `Localizations.of(context).locale`;
    return toLocale(tag);
  }

  static String get tag {
    if (tagIndex == -1) {
      return '';
    }
    return Constant.SUPPORT_LANGUAGE[tagIndex];
  }

  static int get tagIndex {
    if (_languageIndex != -1) {
      return _languageIndex;
    }
    _languageIndex = SpUtil.getInt(PrefsKey.LANGUAGE_TAG_INDEX, defValue: -1);
    return _languageIndex;
  }

  static List<Locale> get supportedLocales {
    List<Locale> ret = [];
    Constant.SUPPORT_LANGUAGE.forEach((tag) {
      if (tag != null && tag.trim().isNotEmpty) {
        ret.add(toLocale(tag));
      }
    });
    L.d('supported locales: $ret');
    return ret;
  }

  static String toFriendlyName(BuildContext context, int index) {
    switch (index) {
      case 0:
        return 'English';
      case 1:
        return '简体中文';
      default:
        return I18N.translate(context, 'settingsAutoBySystem');
    }
  }

  ///
  /// 切换语言
  ///
  static Future change({int tagIndex, String tag}) async {
    if (tagIndex >= 0 && tagIndex < Constant.SUPPORT_LANGUAGE.length) {
      tag = Constant.SUPPORT_LANGUAGE[tagIndex];
    }
    if (tag == null) {
      tag = '';
    }
    Locale _locale = toLocale(tag);
    L.d('target locale is $_locale when tag is $tag');
    appStateKey.currentState.changeLocale(_locale);
    SpUtil.putInt(PrefsKey.LANGUAGE_TAG_INDEX, tagIndex);
    _languageIndex = tagIndex;
  }

  ///
  /// 根据语言标签得到[Locale]对象
  ///
  /// [langTag] e.g. en, zh_CN, zh_Hans, zh_Hans_CN, zh-Hant-TW
  ///
  static Locale toLocale(String langTag) {
    if (langTag == null || langTag.isEmpty) {
      //跟随系统
      return null;
    }
    if (langTag.indexOf('_') == -1 && langTag.indexOf('-') == -1) {
      return new Locale(langTag);
    }
    Locale locale;
    final List<String> codes = langTag.split(new RegExp(r'(_|-)'));
    if (codes.length == 2) {
      if (codes[1].length > 2) {
        locale = Locale.fromSubtags(
          languageCode: codes[0],
          scriptCode: codes[1],
        );
      } else {
        locale = Locale.fromSubtags(
          languageCode: codes[0],
          countryCode: codes[1],
        );
      }
    } else if (codes.length == 3) {
      locale = Locale.fromSubtags(
        languageCode: codes[0],
        scriptCode: codes[1],
        countryCode: codes[2],
      );
    } else {
      locale = new Locale(codes[0]);
    }
    return locale;
  }
}

///
/// 国际化方案（支持外部语言包），灵感来源于 https://github.com/ilteoood/flutter_i18n
///
class I18N {
  static const String PARAMETER_NAME_REGEXP = '{([\w_]+)}';
  Map<String, dynamic> _loadedTranslations = new Map();

  I18N();

  ///
  /// 加载默认语言包
  ///
  Future<I18N> loadDefault([final Locale defaultLocale]) async {
    Locale locale = defaultLocale;
    L.d('will app locale: $locale');
    if (locale == null) {
      locale = await findSystemLocale();
      L.d('app locale is null, will use system locale: $locale');
    }
    String languageCode = locale.languageCode;
    String scriptCode = locale.scriptCode;
    String countryCode = locale.countryCode;
    if (countryCode != null &&
        countryCode.isNotEmpty &&
        scriptCode != null &&
        scriptCode.isNotEmpty) {
      if (await _tryLoadJson('${languageCode}_${scriptCode}_$countryCode')) {
        return this;
      }
    }
    if (countryCode != null && countryCode.isNotEmpty) {
      if (await _tryLoadJson('${languageCode}_$countryCode')) {
        return this;
      }
    }
    if (scriptCode != null && scriptCode.isNotEmpty) {
      if (await _tryLoadJson('${languageCode}_$scriptCode')) {
        return this;
      }
    }
    if (await _tryLoadJson(languageCode)) {
      return this;
    }
    return this;
  }

  static Future<Locale> findSystemLocale() async {
    final String systemLanguageTag = await intl.findSystemLocale();
    final List<String> systemLanguageTagSplit = systemLanguageTag.split('_');
    return Future(() {
      String _countryCode;
      if (systemLanguageTagSplit.length == 3) {
        // Hans, Hant, Latn, Arab or Cyrl
        _countryCode = systemLanguageTagSplit[2];
      } else {
        // en_US, zh_SG, ru_RU, ar_AE, bo_IN and so on
        _countryCode = systemLanguageTagSplit[1];
      }
      return Locale(systemLanguageTagSplit[0], _countryCode);
    });
  }

  Future<bool> _tryLoadJson(String fileName) async {
    String key = '${AssetDir.LANG}/$fileName.json';
    try {
      String str = await rootBundle.loadString(key);
      _loadedTranslations = json.decode(str);
      L.d('load $key success from assets: ${_loadedTranslations.length} keys');
      return true;
    } catch (e) {
      L.d('load $key failed from assets');
      _loadedTranslations = Map();
      return false;
    }
  }

  static String translate(
      final BuildContext context, final String translationKey,
      [final Map<String, String> translationParams]) {
    String translation =
        _retrieveInstance(context)._loadedTranslations[translationKey];
    if (translation == null) {
      L.d('**$translationKey** not found');
      translation = translationKey;
    }
    if (translationParams != null) {
      for (final String paramKey in translationParams.keys) {
        translation = translation.replaceAll(
            new RegExp('{$paramKey}'), translationParams[paramKey]);
      }
    }
    return translation;
  }

  static String plural(final BuildContext context, final String translationKey,
      final int pluralValue) {
    String parameterName = _findParameterName(
        _retrieveInstance(context)._loadedTranslations[translationKey]);
    return translate(context, translationKey,
        Map.fromIterables([parameterName], [pluralValue.toString()]));
  }

  static String _findParameterName(final String translation) {
    String parameterName = '';
    RegExp regexp = new RegExp(PARAMETER_NAME_REGEXP);
    if (translation != null && regexp.hasMatch(translation)) {
      final Match match = regexp.firstMatch(translation);
      parameterName = match.groupCount > 0 ? match.group(1) : '';
    }
    return parameterName;
  }

  static I18N _retrieveInstance(final BuildContext context) {
    return Localizations.of<I18N>(context, I18N);
  }
}

class I18NDelegate extends LocalizationsDelegate<I18N> {
  final Locale _locale;
  Locale _oldLocale;

  I18NDelegate(this._locale);

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<I18N> load(Locale locale) async {
    bool needPreload = locale == null;
    I18N _i18n = I18N();
    L.d('load ? current locale is $locale, old locale is $_oldLocale, new locale is $_locale');
    bool forceChange = (_oldLocale != null && _oldLocale != _locale);
    if (needPreload || forceChange) {
      return _i18n.loadDefault(_locale);
    }
    return _i18n;
  }

  @override
  bool shouldReload(I18NDelegate old) {
    _oldLocale = old._locale;
    L.d('should reload ? old locale is $_oldLocale, new locale is $_locale');
    return _oldLocale != _locale;
  }
}
