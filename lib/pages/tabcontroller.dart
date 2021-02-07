import 'dart:ui';

import 'package:Hackathon/pages/home.dart';
import 'package:Hackathon/pages/yeni.ilan.olustur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

import 'arama.ekrani.dart';

var ilanlar;
Future<QuerySnapshot> ilanArama;

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

TextEditingController arama = TextEditingController();

class _TabBarControllerState extends State<TabBarController>
    with TickerProviderStateMixin {
  bool isHeaderOpened = true;
  double offsetData = 0;
  ScrollController scrollController;
  MotionTabController _tabController;
  @override
  void initState() {
    getParkYerSilme();
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
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        uygulamadanCik();
      },
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: _tabBar,
          body: MotionTabBarView(
            controller: _tabController,
            children: [
              AramaEkrani(),
              Home(scrollController),
              YeniIlanOlustur(),
            ],
          ),
        ),
      ),
    );
  }

  void uygulamadanCik() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: AlertDialog(
                title: Text(
                  "Uygulamadan çıkmak istediğine emin misin?",
                  style: TextStyle(fontSize: 17),
                ),
                actions: [
                  FlatButton(
                    color: Colors.deepOrange,
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text("Evet"),
                  ),
                  FlatButton(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Hayır"),
                  ),
                ],
              ));
        });
  }

  Widget get _tabBar => MotionTabBar(
        labels: ["Arama", "Ana Ekran", "İlan Ekle"],
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
        icons: [Icons.search, Icons.home, Icons.add],
        textStyle: TextStyle(color: Colors.lightBlueAccent),
      );

  Future<QuerySnapshot> getParkYerSilme() {
    setState(() {
      ilanArama = null;
    });
    return ilanlar;
  }
}

final titleTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black);
