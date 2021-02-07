import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/pages/kart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widget/yuklemeEkraniBekleme.dart';

class Ilanlarim extends StatefulWidget {
  @override
  _IlanlarimState createState() => _IlanlarimState();
}

class _IlanlarimState extends State<Ilanlarim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        title: Text("İlanlarım"),
      ),
      body: ListView(
        children: [
          FutureBuilder(
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
                          return Kartt(
                            index: index,
                            snapshot: snapshot,
                          );
                        })
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Paylaştığınız park yerleri burada görüntülenecek.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 18),
                          ),
                        ),
                      );
              }),
        ],
      ),
    );
  }

  SizedBox buildSizedBox(AsyncSnapshot snapshot, int index, String gelenFoto) {
    return SizedBox(width: 75, height: 75, child: Image.network(gelenFoto));
  }
}
