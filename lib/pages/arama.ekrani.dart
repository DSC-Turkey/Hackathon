import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/kart.dart';
import 'package:Hackathon/widget/yuklemeEkraniBekleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

var ilanlar;
Future<QuerySnapshot> ilanArama;
TextEditingController arama = TextEditingController();

class AramaEkrani extends StatefulWidget {
  const AramaEkrani({
    Key key,
  }) : super(key: key);

  @override
  _AramaEkraniState createState() => _AramaEkraniState();
}

class _AramaEkraniState extends State<AramaEkrani> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              if (value.trim() == "") {
                getParkYerSilme();
                return;
              }
              setState(() {
                ilanArama = FirebaseFirestore.instance
                    .collection("ilanlar")
                    .limit(10)
                    .orderBy("paslasanName")
                    .startAt([value.toLowerCase()]).endAt(
                        [value.toLowerCase() + '\uf8ff']).get();
              });
            },
            cursorColor: Theme.of(context).cursorColor,
            controller: arama,
            decoration: InputDecoration(
                icon: Icon(LineAwesomeIcons.search),
                labelText: "Kullanıcı Ara",
                labelStyle: TextStyle(),
                hintText: 'Hadi Bir Kullanıcı Ara.',
                helperText: "Bir Kullanıcı Bulmak İçin Arama Yap.",
                suffixIcon: IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      if (arama.text.length == 0) return;
                      arama.clear();
                      getParkYerSilme();
                    },
                    icon: Icon(LineAwesomeIcons.trash)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide())),
          ),
          Expanded(
              child: ilanArama != null
                  ? FutureBuilder(
                      future: ilanArama,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasError) {
                          return yuklemeBasarisizIse();
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return YuklemeBeklemeEkrani(
                            gelenYazi: "Aranıyor.",
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: snapshot.data.docs.length != 0
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
                                  child: Text(
                                    "BULUNAMADI.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 18),
                                  ),
                                ),
                        );
                      })
                  : Center(
                      child: Text(
                        "Bulunan Kullanıcılar Burada Görüntülecek.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 18),
                      ),
                    ))
        ],
      ),
    );
  }

  Future<QuerySnapshot> getParkYerSilme() {
    setState(() {
      ilanArama = null;
    });
    return ilanlar;
  }
}
