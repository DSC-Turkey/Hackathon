import 'package:Hackathon/pages/kart.dart';
import 'package:Hackathon/widget/yuklemeEkraniBekleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ortak/ortak.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: genelSayfaTasarimi,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset("asset/icon.png")),
                  Text(
                    "HelpTouch",
                    style:
                        TextStyle(fontSize: 30, fontFamily: 'HammersmithOne'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _listView,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _listView => StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ilanlar")
            .limit(10)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return yuklemeBasarisizIse();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return YuklemeBeklemeEkrani(
              gelenYazi: "Lütfen Bekleyin.",
            );
          }
          return snapshot.data.docs.length != 0
              ? Container(
                  child: ListView.separated(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Kartt(
                            snapshot: snapshot,
                            index: index,
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 10,
                      );
                    },
                  ),
                )
              : landingPage("İlanlar Burada Görüntülenecek.");
        },
      );
}
