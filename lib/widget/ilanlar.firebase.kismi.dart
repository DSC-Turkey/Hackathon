import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/pages/kart.dart';
import 'package:Hackathon/widget/yuklemeEkraniBekleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class IlanlarFirebaseKismi extends StatefulWidget {
  const IlanlarFirebaseKismi({
    Key key,
  }) : super(key: key);

  @override
  _IlanlarFirebaseKismiState createState() => _IlanlarFirebaseKismiState();
}

class _IlanlarFirebaseKismiState extends State<IlanlarFirebaseKismi> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("ilanlar")
            .where("paylasanID", isEqualTo: kullaniciID)
            .limit(10)
            .get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
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
              : landingPage("Paylaştığınız ilanlar burada görüntülenecek.");
        });
  }
}
