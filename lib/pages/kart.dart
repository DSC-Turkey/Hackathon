import 'package:Hackathon/main.dart';
import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/pages/ayrinti.dart';
import 'package:Hackathon/pages/yorumlar.dart';
import 'package:Hackathon/yuklemeEkraniBekleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Kartt extends StatelessWidget {
  final snapshot;
  final index;
  const Kartt({
    Key key,
    this.snapshot,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Ayrinti(
                      paylasanID: snapshot.data.docs[index]["paylasanID"],
                      idd: snapshot.data.docs[index].id,
                    )));
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data.docs[index]["paylasanID"])
                    .get(),
                builder: (BuildContext context, snapshot2) {
                  if (snapshot2.hasError) {
                    return yuklemeBasarisizIse();
                  }
                  if (snapshot2.connectionState == ConnectionState.waiting) {
                    return YuklemeBeklemeEkrani(
                      gelenYazi: "Lütfen Bekleyin.",
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.0,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(70.0),
                              image: DecorationImage(
                                image:
                                    NetworkImage(snapshot2.data["profilFoto"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                              '  ${snapshot.data.docs[index]["paslasanName"]}'),
                        ],
                      ),
                      Text(
                        "Beğeni : " +
                            snapshot.data.docs[index]["begenenler"].length
                                .toString() +
                            "   ",
                      ),
                    ],
                  );
                }),
            Image.network(snapshot.data.docs[index]["fotograflar"][0]),
            Text('${snapshot.data.docs[index]["ilanYazisi"]}'),
            Text(
                '${snapshot.data.docs[index]["sehir"]} / ${snapshot.data.docs[index]["ilçe"]}'),
            Text('${snapshot.data.docs[index]["ilanKonusu"]}'),
            Divider(
              height: 5,
              indent: 500.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  child: InkWell(
                    onTap: () {
                      databaseReferance
                          .collection("ilanlar")
                          .doc(snapshot.data.docs[index].id)
                          .get()
                          .then((value) {
                        List gel = value.data()["begenenler"];
                        if (gel.contains(kullaniciID)) {
                          gel.remove(kullaniciID);
                        } else
                          gel.add(kullaniciID);
                        databaseReferance
                            .collection("ilanlar")
                            .doc(snapshot.data.docs[index].id)
                            .update({
                          "begenenler": gel,
                        });
                      });
                      print(snapshot.data.docs[index].id);
                    },
                    child: Row(
                      children: [
                        Text("Beğen"),
                        Icon(Icons.check),
                      ],
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Yorumlar(
                            ilanID: snapshot.data.docs[index].id,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text("Yorum Yap"),
                        Icon(Icons.comment),
                      ],
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () async {
                      const url = 'tel://05419403812';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Row(
                      children: [
                        Text("Yardım Et"),
                        Icon(Icons.help),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding yuklemeBasarisizIse() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
      child: CircleAvatar(
        backgroundColor: Colors.grey[50],
        child: Icon(
          Icons.clear,
          color: Colors.red,
        ),
      ),
    );
  }
}
