import 'dart:ui';

import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/home.dart';
import 'package:Hackathon/pages/noConnection.dart';
import 'package:Hackathon/pages/yeni.ilan.olustur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'arama.ekrani.dart';

var ilanlar;
Future<QuerySnapshot> ilanArama;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

TextEditingController arama = TextEditingController();

class _TabBarControllerState extends State<TabBarController>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        ortakislemler(context, _firebaseAuth,
            "Uygulamadan çıkmak istediğine emin misin?", "");
      },
      child: SafeArea(
        child: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;
              return connected
                  ? Scaffold(
                      bottomNavigationBar: _tabBar,
                      body: MotionTabBarView(
                        controller: _tabController,
                        children: [
                          AramaEkrani(),
                          Home(),
                          YeniIlanOlustur(),
                        ],
                      ),
                    )
                  : NoConnection();
            },
            child: Container()),
      ),
    );
  }

  Widget get _tabBar => MotionTabBar(
        labels: ["Arama", "Akış", "İlan Ekle"],
        initialSelectedTab: "Akış",
        tabIconColor: Colors.teal[400],
        tabSelectedColor: Colors.teal[400],
        onTabItemSelected: (int value) {
          setState(() {
            _tabController.index = value;
          });
        },
        icons: [LineAwesomeIcons.search, LineAwesomeIcons.stream, Icons.add],
        textStyle: TextStyle(color: Colors.teal[400]),
      );
}

final titleTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black);
