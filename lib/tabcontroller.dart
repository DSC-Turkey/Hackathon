import 'package:Hackathon/home.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController>
    with TickerProviderStateMixin {
  bool isHeaderOpened = true;
  double offsetData = 0;
  ScrollController scrollController;
  MotionTabController _tabController;
  @override
  void initState() {
    super.initState();
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
        bottomNavigationBar: _tabBar,
        body: MotionTabBarView(
          controller: _tabController,
          children: [
            FloatingSearchBar.builder(
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text(index.toString()),
                  );
                }),
            Home(scrollController),
            Text("3"),
          ],
        ),
      ),
    );
  }

  Widget get _tabBar => MotionTabBar(
        labels: ["Arama", "Ana Ekran", "Diger"],
        initialSelectedTab: "Ana Ekran",
        tabIconColor: Colors.blueGrey,
        tabSelectedColor: Colors.lightBlueAccent,
        onTabItemSelected: (int value) {
          print(value);
          setState(() {
            _tabController.index = value;
            currentIndex = value;
          });
        },
        icons: [Icons.search, Icons.home, Icons.menu],
        textStyle: TextStyle(color: Colors.lightBlueAccent),
      );
}

final titleTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black);
