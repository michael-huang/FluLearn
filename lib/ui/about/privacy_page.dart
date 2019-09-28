import 'package:flutter/material.dart';
import 'package:flutter_app/config/asset_dir.dart';
import 'package:flutter_app/toolkit/language_kit.dart';
import 'package:flutter_app/ui/widget/back_screen.dart';
import 'package:flutter_app/ui/widget/markdown_viewer.dart';

const _PATH = AssetDir.DOCS + '/PrivacyPolicy.md';

///
/// 隐私声明页
///
class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackScreen(
      presetScroll: false,
      title: I18N.translate(context, 'titlePrivacy'),
      body: MarkdownViewer(path: _PATH),
    );
  }
}
