import 'package:Hackathon/main.dart';
import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/pages/ayrinti.dart';
import 'package:Hackathon/pages/yorumlar.dart';
import 'package:Hackathon/widget/yuklemeEkraniBekleme.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Kartt extends StatefulWidget {
  final snapshot;
  final index;
  const Kartt({
    Key key,
    this.snapshot,
    this.index,
  }) : super(key: key);

  @override
  _KarttState createState() => _KarttState();
}

class _KarttState extends State<Kartt> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 35, 20, 35),
      child: OpenContainer(
        closedElevation: 0,
        closedColor: Colors.transparent,
        openBuilder: (context, _) => Ayrinti(
            paylasanID: widget.snapshot.data.docs[widget.index]["paylasanID"],
            idd: widget.snapshot.data.docs[widget.index].id),
        closedBuilder: (context, _) => Card(
          elevation: 50,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Image.network(widget.snapshot.data
                            .docs[widget.index]["fotograflar"][0]))),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.snapshot.data.docs[widget.index]
                            ["paylasanID"])
                        .get(),
                    builder: (BuildContext context, snapshot2) {
                      if (snapshot2.hasError) {
                        return yuklemeBasarisizIse();
                      }
                      if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
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
                                    '  ${widget.snapshot.data.docs[widget.index]["paslasanName"]}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(LineAwesomeIcons.heart_1),
                              Text(
                                widget.snapshot.data
                                        .docs[widget.index]["begenenler"].length
                                        .toString() +
                                    "   ",
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                  child: Text(
                    '${widget.snapshot.data.docs[widget.index]["ilanYazisi"]}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                buildText(
                    "${(widget.snapshot.data.docs[widget.index]["sehir"]).toString()} / ${(widget.snapshot.data.docs[widget.index]["ilçe"]).toString()}"),
                buildText(
                    "${widget.snapshot.data.docs[widget.index]["ilanKonusu"]}"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildMaterial(
                        context,
                        "Beğen ",
                        Icon(
                          LineAwesomeIcons.heart,
                          color: Colors.red,
                        ),
                      ),
                      buildMaterial(
                        context,
                        "Yorumlar ",
                        Icon(
                          LineAwesomeIcons.comment,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text buildText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }

  Material buildMaterial(BuildContext context, String text, Icon icon) {
    return Material(
      color: Colors.white,
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () {
          if (text == "Beğen ") {
            databaseReferance
                .collection("ilanlar")
                .doc(widget.snapshot.data.docs[widget.index].id)
                .get()
                .then((value) {
              List gel = value.data()["begenenler"];
              if (gel.contains(kullaniciID)) {
                gel.remove(kullaniciID);
              } else
                gel.add(kullaniciID);
              databaseReferance
                  .collection("ilanlar")
                  .doc(widget.snapshot.data.docs[widget.index].id)
                  .update({
                "begenenler": gel,
              });
            });
          } else if (text == "Yorumlar ") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Yorumlar(
                  ilanID: widget.snapshot.data.docs[widget.index].id,
                ),
              ),
            );
          }
        },
        child: Row(
          children: [
            Text(
              text,
              style:
                  TextStyle(color: text == "Beğen " ? Colors.red : Colors.blue),
            ),
            icon
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
