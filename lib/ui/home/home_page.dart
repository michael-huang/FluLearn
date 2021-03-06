import 'package:flutter/material.dart';
import 'package:flutter_app/toolkit/image_loader.dart';
import 'package:flutter_app/toolkit/overlay_style.dart';
import 'package:flutter_app/ui/home/home_drawer.dart';
import 'package:flutter_app/ui/login/login_page.dart';
import 'package:flutter_app/ui/widget/exit_container.dart';
import 'package:flutter_app/ui/widget/title_bar.dart';

///
/// 主页
///
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;
  var _tabIcons = [
    ["statistics_normal", "statistics_selected"],
    ["statistics_normal", "statistics_selected"],
    ["statistics_normal", "statistics_selected"],
    ["statistics_normal", "statistics_selected"],
    ["statistics_normal", "statistics_selected"],
  ];
  var _tabTexts = ['考试', '提问', '下载', '学习', '我的'];
  var _pageList;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    _pageList = [
      Text("考试"),
      Text("提问"),
      Text("下载"),
      Text("学习"),
      //Text("我的"),
      new LoginPage(),
    ];
  }

  Widget _buildTabIcon(int index) {
    String name;
    if (index == _tabIndex) {
      name = _tabIcons[index][1];
    } else {
      name = _tabIcons[index][0];
    }
    String icon = ImageLoader.assetPath("home/ic_$name.png");
    //L.d("selected: $_tabIndex, index: $index, icon: $icon");
    return ImageLoader.fromAsset(icon);
  }

  Widget _buildTabText(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(
        _tabTexts[index],
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExitContainer(
      child: Scaffold(
        appBar: TitleBar(
          title: _tabTexts[_tabIndex],
          leading: Builder(
            builder: (context) {
              return IconButton(
                color: OverlayStyle.estimateFrontColor(
                    Theme.of(context).primaryColor),
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: HomeDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          items: List.generate(_tabTexts.length, (i) {
            return BottomNavigationBarItem(
              icon: _buildTabIcon(i),
              title: _buildTabText(i),
            );
          }),
          type: BottomNavigationBarType.fixed,
          currentIndex: _tabIndex,
          elevation: 10.0,
          iconSize: 25.0,
          selectedFontSize: 15.5,
          unselectedFontSize: 15.0,
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        ),
        // 使用PageView的原因参看 https://zhuanlan.zhihu.com/p/58582876
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pageList,
          physics: NeverScrollableScrollPhysics(),
          //physics: AlwaysScrollableScrollPhysics(),
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _tabIndex = index;
    });
  }
}
