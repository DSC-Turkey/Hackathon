import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/yorumlar.dart';
import 'package:Hackathon/widget/yuklemeEkraniBekleme.dart';
import 'package:flutter/material.dart';

class YorumlarFirebaseKismi extends StatefulWidget {
  const YorumlarFirebaseKismi({
    Key key,
  }) : super(key: key);

  @override
  _YorumlarFirebaseKismiState createState() => _YorumlarFirebaseKismiState();
}

class _YorumlarFirebaseKismiState extends State<YorumlarFirebaseKismi> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: comments,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return yuklemeBasarisizIse();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return YuklemeBeklemeEkrani(
            gelenYazi: "Lütfen Bekleyin.",
          );
        }
        return snapshot.data.docs.length != 0
            ? ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: CircleAvatar(
                          child: Image.network(snapshot.data.docs[index]
                              ["yorumYapanProfilFoto"]),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            snapshot.data.docs[index]["yorumYapanAd"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                          snapshot.data.docs[index]["zaman"])
                                      .hour
                                      .toString() +
                                  "." +
                                  DateTime.fromMillisecondsSinceEpoch(
                                          snapshot.data.docs[index]["zaman"])
                                      .minute
                                      .toString(),
                              style: TextStyle(
                                fontSize: 10.0,
                              )),
                        ],
                      ),
                      subtitle: Text(
                        snapshot.data.docs[index]["yorum"],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: 100),
                child: landingPage("İlk yorum yapan sen ol..."),
              );
      },
    );
  }
}
