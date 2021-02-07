import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/sadece.fotograf.dart';
import 'package:Hackathon/widget/yuklemeEkraniBekleme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Ayrinti extends StatefulWidget {
  final paylasanID;
  final idd;
  const Ayrinti({Key key, this.paylasanID, this.idd}) : super(key: key);
  @override
  _AyrintiState createState() => _AyrintiState();
}

class _AyrintiState extends State<Ayrinti> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: genelSayfaTasarimi,
          child: Column(
            children: [
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.paylasanID)
                      .get(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return yuklemeBasarisizIse();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return YuklemeBeklemeEkrani(
                        gelenYazi: "Lütfen Bekleyin.",
                      );
                    }
                    return Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                              width: 75,
                              height: 75,
                              child: CircleAvatar(
                                onBackgroundImageError:
                                    (exception, stackTrace) => print("Hata"),
                                backgroundImage: NetworkImage(
                                  snapshot.data["profilFoto"],
                                ),
                              )),
                        ),
                        Text(
                          snapshot.data["kullanıcıAdı"][0].toUpperCase() +
                              snapshot.data["kullanıcıAdı"]
                                  .substring(1)
                                  .toLowerCase(),
                          style: _textStyle,
                        )
                      ],
                    );
                  }),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("ilanlar")
                      .doc(widget.idd)
                      .get(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return yuklemeBasarisizIse();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return YuklemeBeklemeEkrani(
                        gelenYazi: "Lütfen Bekleyin.",
                      );
                    }
                    return Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            height: 181.0,
                            autoPlay: true,
                          ),
                          items: snapshot.data["fotograflar"].map<Widget>((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border.all(
                                      width: 2.0,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      print(i);
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
                                      child: Image.network(i),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        Divider(
                          height: 15,
                        ),
                        Text(
                          snapshot.data["sehir"] +
                              " / " +
                              snapshot.data["ilçe"],
                          style: _textStyle,
                        ),
                        Text(
                          snapshot.data["ilanKonusu"],
                          style: _textStyle,
                        ),
                        Text(
                          snapshot.data["ilanYazisi"],
                          style: _textStyle,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _textStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
}
