import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/widget/aramadan.gelenler.dart';
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
    return Container(
      decoration: genelSayfaTasarimi,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                if (value.trim() == "") {
                  ilanSilme();
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
                        ilanSilme();
                      },
                      icon: Icon(LineAwesomeIcons.trash)),
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide())),
            ),
            AramadanGelenler()
          ],
        ),
      ),
    );
  }

  Future<QuerySnapshot> ilanSilme() {
    setState(() {
      ilanArama = null;
    });
    return ilanlar;
  }
}
