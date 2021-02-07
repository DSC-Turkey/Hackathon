import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/sadece.fotograf.dart';
import 'package:Hackathon/widget/yuklemeEkraniBekleme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Ayrinti extends StatefulWidget {
  final paylasanID;
  final idd;
  const Ayrinti({Key key, this.paylasanID, this.idd}) : super(key: key);
  @override
  _AyrintiState createState() => _AyrintiState();
}

class _AyrintiState extends State<Ayrinti> {
  @override
  void initState() {
    bilgiler();
    super.initState();
  }

  bool isLoaded = false;
  DocumentSnapshot kullaniciBilgileri;
  DocumentSnapshot b;
  void bilgiler() async {
    kullaniciBilgileri = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.paylasanID)
        .get();
    b = await FirebaseFirestore.instance
        .collection("ilanlar")
        .doc(widget.idd)
        .get();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: ortakLeading(context),
        body: !isLoaded
            ? YuklemeBeklemeEkrani(
                gelenYazi: " Yükleniyor",
              )
            : Column(
                children: [
                  Stack(
                    overflow: Overflow.visible,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 10,
                          enableInfiniteScroll: false,
                          height: 250.0,
                          autoPlay: true,
                        ),
                        items: b.data()["fotograflar"].map<Widget>((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SadeceFotograf(
                                                  gelenFoto: i,
                                                )));
                                  },
                                  child: Hero(
                                    tag: "hero$i",
                                    child: Image.network(
                                      i,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Positioned(
                        top: 210,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height - 210,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40)),
                              color: Colors.teal[400]),
                          child: Column(
                            children: [
                              buildListTile(
                                  kullaniciBilgileri
                                          .data()["kullanıcıAdı"][0]
                                          .toUpperCase() +
                                      kullaniciBilgileri
                                          .data()["kullanıcıAdı"]
                                          .substring(1)
                                          .toLowerCase(),
                                  CircleAvatar(
                                    onBackgroundImageError:
                                        (exception, stackTrace) =>
                                            print("Hata"),
                                    backgroundImage: NetworkImage(
                                      kullaniciBilgileri.data()["profilFoto"],
                                    ),
                                  )),
                              Divider(),
                              buildListTile(
                                  b.data()["sehir"] + " / " + b.data()["ilçe"],
                                  Icon(
                                    LineAwesomeIcons.map,
                                    color: Colors.white,
                                  )),
                              buildListTile(
                                  b.data()["ilanKonusu"],
                                  Icon(
                                    LineAwesomeIcons.info,
                                    color: Colors.white,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  b.data()["ilanYazisi"],
                                  style: _textStyle,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  ListTile buildListTile(String text, dynamic icon) {
    return ListTile(
      title: Text(
        text,
        style: _textStyle,
      ),
      leading: icon,
    );
  }

  TextStyle _textStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
}
