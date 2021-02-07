import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/arama.ekrani.dart';
import 'package:Hackathon/pages/kart.dart';
import 'package:Hackathon/widget/yuklemeEkraniBekleme.dart';
import 'package:flutter/material.dart';

class AramadanGelenler extends StatefulWidget {
  const AramadanGelenler({
    Key key,
  }) : super(key: key);

  @override
  _AramadanGelenlerState createState() => _AramadanGelenlerState();
}

class _AramadanGelenlerState extends State<AramadanGelenler> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ilanArama != null
            ? FutureBuilder(
                future: ilanArama,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return yuklemeBasarisizIse();
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                          : landingPage("Bulunamadı"));
                })
            : landingPage("Bulunan Kullanıcılar Burada Götüntülenecek"));
  }
}
