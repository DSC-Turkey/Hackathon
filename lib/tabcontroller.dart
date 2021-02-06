import 'package:Hackathon/home.dart';
import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/search.dart';
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
            Text("1"),
            Home(scrollController),
            Text("3"),
          ],
        ),
      ),
    );
  }

  Widget get _sizedBox => SizedBox(width: 20);

  Widget get _searchField => TextField(
        maxLines: 1,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            contentPadding: EdgeInsets.all(0),
            hintText: "Search something.",
            filled: true,
            focusedBorder: _inputBorder,
            border: _inputBorder),
      );

  OutlineInputBorder get _inputBorder => OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(25));

  Widget get _tabBar => MotionTabBar(
        labels: ["Account", "Home", "Dashboard"],
        initialSelectedTab: "Home",
        tabIconColor: Colors.blueGrey,
        tabSelectedColor: Colors.lightBlueAccent,
        onTabItemSelected: (int value) {
          print(value);
          setState(() {
            _tabController.index = value;
            currentIndex = value;
          });
        },
        icons: [Icons.account_box, Icons.home, Icons.menu],
        textStyle: TextStyle(color: Colors.lightBlueAccent),
      );
}

final titleTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black);
