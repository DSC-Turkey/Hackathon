import 'package:Hackathon/main.dart';
import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/pages/yorumlar.dart';
import 'package:Hackathon/yuklemeEkraniBekleme.dart';
import 'package:animations/animations.dart';
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
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 15),
      child: Card(
        elevation: 20,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Image.network(
                        snapshot.data.docs[index]["fotograflar"][0]))),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2.0,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(70.0),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      snapshot2.data["profilFoto"]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                                '  ${snapshot.data.docs[index]["paslasanName"]}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
              child: Text(
                '${snapshot.data.docs[index]["ilanYazisi"]}',
                style: TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            Text(
              '${(snapshot.data.docs[index]["sehir"]).toString().toUpperCase()} / ${(snapshot.data.docs[index]["ilçe"]).toString().toUpperCase()}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text('${snapshot.data.docs[index]["ilanKonusu"]}',
                style: TextStyle(fontWeight: FontWeight.w500)),
            Divider(
              height: 5,
              indent: 500.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                          Text("Beğen "),
                          Icon(Icons.check),
                        ],
                      ),
                    ),
                  ),
                  Material(
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                          Text("Yorum Yap "),
                          Icon(Icons.comment),
                        ],
                      ),
                    ),
                  ),
                  Material(
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                          Text("Yardım Et "),
                          Icon(Icons.help),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
