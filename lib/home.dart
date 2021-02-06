import 'package:Hackathon/pages/kart.dart';
import 'package:Hackathon/yuklemeEkraniBekleme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home(this.controller);

  final ScrollController controller;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String data =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: genelSayfaTasarimi,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: _listView,
        ),
      ),
    );
  }

  Widget get _listView => StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ilanlar")
            .limit(10)
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
          return ListView.separated(
            itemCount: snapshot.data.docs.length,
            controller: widget.controller,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Kartt(
                    snapshot: snapshot,
                    index: index,
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 10,
              );
            },
          );
        },
      );
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
