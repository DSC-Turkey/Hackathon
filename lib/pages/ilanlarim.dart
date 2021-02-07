import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/pages/kart.dart';
import 'package:Hackathon/pages/noConnection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:swipe_to/swipe_to.dart';
import '../widget/yuklemeEkraniBekleme.dart';

class Ilanlarim extends StatefulWidget {
  @override
  _IlanlarimState createState() => _IlanlarimState();
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class _IlanlarimState extends State<Ilanlarim> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return connected
                ? Scaffold(
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.startTop,
                    floatingActionButton: Row(
                      children: [
                        ortakLeading(context),
                        Text(
                          "İlanlarım",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    body: Container(
                      padding: EdgeInsets.only(top: 20),
                      decoration: genelSayfaTasarimi,
                      child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("ilanlar")
                              .where("paylasanID", isEqualTo: kullaniciID)
                              .limit(10)
                              .get(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Error");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return YuklemeBeklemeEkrani(
                                gelenYazi: "Aranıyor.",
                              );
                            }
                            return snapshot.data.docs.length != 0
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      return SwipeTo(
                                        rightSwipeWidget: Text("İlanı Sil"),
                                        onRightSwipe: () {
                                          ortakislemler(
                                              context,
                                              _firebaseAuth,
                                              "İlanı silmek istediğine emin misin?",
                                              snapshot.data.docs[index].id);
                                        },
                                        child: Kartt(
                                          index: index,
                                          snapshot: snapshot,
                                        ),
                                      );
                                    })
                                : landingPage(
                                    "Paylaştığınız ilanlar burada görüntülenecek.");
                          }),
                    ),
                  )
                : NoConnection();
          },
          child: Container()),
    );
  }

  SizedBox buildSizedBox(AsyncSnapshot snapshot, int index, String gelenFoto) {
    return SizedBox(width: 75, height: 75, child: Image.network(gelenFoto));
  }
}
