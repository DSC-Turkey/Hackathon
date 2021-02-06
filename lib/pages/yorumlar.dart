import 'package:Hackathon/main.dart';
import 'package:Hackathon/yuklemeEkraniBekleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        title: Text("Yorumlar"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("yorumlar")
                        .where("ilanID", isEqualTo: widget.ilanID)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return yuklemeBasarisizIse();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return YuklemeBeklemeEkrani(
                          gelenYazi: "Lütfen Bekleyin.",
                        );
                      }
                      //print(snapshot.data.docs[0]["yorum"]);
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.data.docs[index]["yorumYapanAd"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  snapshot.data.docs[index]["yorum"],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
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
                onChanged: (value) {},
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
          IconButton(
            splashRadius: 20,
            onPressed: () {
              databaseReferance.collection("yorumlar").add({
                "ilanID": widget.ilanID,
                "yorumYapanAd": "samet",
                "yorum": controller.text,
              }).whenComplete(() {
                setState(() {
                  controller.clear();
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
