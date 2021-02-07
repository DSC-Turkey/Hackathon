import 'package:Hackathon/home.dart';
import 'package:Hackathon/pages/yeni.ilan.olustur.dart';
import 'package:Hackathon/search.dart';
import 'package:Hackathon/uitesting.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'notifications.dart';
import 'package:animations/animations.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isHeaderOpened = true;
  double offsetData = 0;
  ScrollController scrollController;
  MotionTabController _tabController;
  @override
  void initState() {
    super.initState();
    final animController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    final animation = Tween(begin: 0.0, end: 1.0).animate(animController);
    _tabController = new MotionTabController(initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _animatedTabBar,
        body: MotionTabBarView(
          controller: _tabController,
          children: [
            Search(),
            Home(scrollController),
            YeniIlanOlustur(),
          ],
        ),
      ),
    );
  }

  Widget get _tabBar => MotionTabBar(
        labels: ["Arama", "Ana Ekran", "Bildirimler"],
        initialSelectedTab: "Ana Ekran",
        tabIconColor: Colors.blueGrey,
        tabSelectedColor: Colors.lightBlueAccent,
        onTabItemSelected: (int value) {
          setState(() {
            _tabController.index = value;
            currentIndex = value;
          });
        },
        icons: [Icons.search, Icons.home, Icons.add],
        textStyle: TextStyle(color: Colors.lightBlueAccent),
      );

  Widget get _animatedTabBar => PageTransitionSwitcher(
        transitionBuilder: (Widget child, Animation<double> primaryAnim,
            Animation<double> secondaryAnim) {
          return FadeThroughTransition(
            child: child,
            animation: primaryAnim,
            secondaryAnimation: secondaryAnim,
          );
        },
        child: _tabBar,
      );

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

final titleTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black);
