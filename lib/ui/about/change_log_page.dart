import 'package:flutter/material.dart';
import 'package:flutter_app/config/asset_dir.dart';
import 'package:flutter_app/generated/i18n.dart';
import 'package:flutter_app/ui/widget/back_screen.dart';
import 'package:flutter_app/ui/widget/markdown_viewer.dart';

const _PATH = AssetDir.docs + '/ChangeLog.md';
//const _PATH = 'https://raw.githubusercontent.com/gzu-liyujiang/AndroidPicker/master/ChangeLog.md';

///
/// 版本更新日志页
///
class ChangeLogPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return BackScreen(
      presetScroll: false,
      title: S.of(context).titleChangeLog,
      body: MarkdownViewer(path: _PATH),
    );
  }
}
