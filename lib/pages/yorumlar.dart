import 'package:Hackathon/main.dart';
import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/pages/noConnection.dart';
import 'package:Hackathon/widget/yuklemeEkraniBekleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

var comments;

class Yorumlar extends StatefulWidget {
  final ilanID;

  const Yorumlar({
    Key key,
    this.ilanID,
  }) : super(key: key);
  @override
  _YorumlarState createState() => _YorumlarState();
}

TextEditingController controller = TextEditingController();

class _YorumlarState extends State<Yorumlar> {
  @override
  void initState() {
    commentss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {},
      child: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return connected
                ? Scaffold(
                    appBar: ortakAppBar(context, "Yorumlar"),
                    body: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                FutureBuilder(
                                  future: comments,
                                  builder: (BuildContext context, snapshot) {
                                    if (snapshot.hasError) {
                                      return yuklemeBasarisizIse();
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return YuklemeBeklemeEkrani(
                                        gelenYazi: "Lütfen Bekleyin.",
                                      );
                                    }
                                    return snapshot.data.docs.length != 0
                                        ? ListView.builder(
                                            reverse: true,
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data.docs.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    child: CircleAvatar(
                                                      child: Image.network(snapshot
                                                              .data.docs[index][
                                                          "yorumYapanProfilFoto"]),
                                                    ),
                                                  ),
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        snapshot.data
                                                                .docs[index]
                                                            ["yorumYapanAd"],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                          DateTime.fromMillisecondsSinceEpoch(snapshot
                                                                          .data
                                                                          .docs[index]
                                                                      ["zaman"])
                                                                  .hour
                                                                  .toString() +
                                                              "." +
                                                              DateTime.fromMillisecondsSinceEpoch(snapshot
                                                                          .data
                                                                          .docs[index]
                                                                      ["zaman"])
                                                                  .minute
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontSize: 10.0,
                                                          )),
                                                    ],
                                                  ),
                                                  subtitle: Text(
                                                    snapshot.data.docs[index]
                                                        ["yorum"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "İlk yorum yapan sen ol.",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        mesajBari(context),
                      ],
                    ),
                  )
                : NoConnection();
          },
          child: Container()),
    );
  }

  Container mesajBari(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 0.5, color: Colors.grey)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FittedTextFieldContainer(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    controller.text;
                  });
                },
                maxLines: 5,
                minLines: 1,
                showCursor: true,
                textInputAction: TextInputAction.newline,
                toolbarOptions: ToolbarOptions(
                    selectAll: true, copy: true, cut: true, paste: true),
                controller: controller,
                decoration: InputDecoration(
                    hintText: 'Bir mesaj yazın.', border: InputBorder.none),
              ),
            ),
          ),
          controller.text.trim().length <= 0
              ? Container()
              : IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    databaseReferance.collection("yorumlar").add({
                      "ilanID": widget.ilanID,
                      "yorumYapanAd": kullaniciAdi,
                      "yorum": controller.text,
                      "yorumYapanProfilFoto": kullaniciProfilFoto,
                      "zaman": DateTime.now().millisecondsSinceEpoch,
                    }).whenComplete(() {
                      setState(() {
                        controller.clear();
                        commentss();
                      });
                    });
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.lightBlueAccent,
                  ),
                )
        ],
      ),
    );
  }

  Future<QuerySnapshot> commentss() {
    comments = FirebaseFirestore.instance
        .collection("yorumlar")
        .where("ilanID", isEqualTo: widget.ilanID)
        .orderBy("zaman", descending: false)
        .get();
    setState(() {
      comments = comments;
    });
    return comments;
  }
}
