import 'dart:ui';

import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/ilanlarim.dart';
import 'package:Hackathon/widget/profil.getir.dart';
import 'package:Hackathon/widget/sqflite.dart';
import 'package:Hackathon/pages/tabcontroller.dart';
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

var kullaniciID;
var kullaniciProfilFoto;
var kullaniciMail;
var kullaniciAdi;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class AnaEkran extends StatefulWidget {
  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnaEkranHome(),
    );
  }
}

class AnaEkranHome extends StatefulWidget {
  @override
  _AnaEkranHomeState createState() => _AnaEkranHomeState();
}

class _AnaEkranHomeState extends State<AnaEkranHome> {
  @override
  void initState() {
    kullaniciBilgileri();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: genelSayfaTasarimi,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                  ),
                  ProfilGetir(),
                  Positioned(
                    top: 90,
                    left: 130,
                    child: Text(
                      kullaniciAdi ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 50,
                indent: 500.0,
              ),
              buildListTile(
                  Icon(
                    LineAwesomeIcons.envelope,
                    color: Colors.white,
                  ),
                  kullaniciMail ?? ""),
              buildListTile(
                  Icon(
                    LineAwesomeIcons.lock,
                    color: Colors.white,
                  ),
                  "Şifre İşlemleri"),
              buildListTile(
                  Icon(
                    LineAwesomeIcons.home,
                    color: Colors.white,
                  ),
                  "İlanlarım"),
              Stack(
                children: [
                  Container(
                    color: Colors.red,
                  ),
                  buildListTile(
                      Icon(
                        LineAwesomeIcons.door_closed,
                        color: Colors.white,
                      ),
                      "Oturumu Kapat"),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarController(),
    );
  }

  OpenContainer buildListTile(Icon icon, String text) {
    return OpenContainer(
      openElevation: 5,
      closedColor: Colors.transparent,
      closedElevation: 0,
      openBuilder: (context, _) => Ilanlarim(),
      closedBuilder: (context, _) => FlatButton(
        padding: EdgeInsets.all(0),
        highlightColor: Colors.lightBlueAccent,
        onPressed: text != "İlanlarım"
            ? () {
                if (text == "Oturumu Kapat")
                  ortakislemler(context, _firebaseAuth,
                      "Oturumu kapatmak istediğine emin misin?", "");
                else if (text == "Şifre İşlemleri")
                  ortakislemler(
                      context,
                      _firebaseAuth,
                      "Mailinize bir şifre sıfırlama bağlantısı gönderilecektir.",
                      "");
              }
            : null,
        child: ListTile(
          leading: icon,
          title: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> kullaniciBilgileri() async {
    final TodoHelper _todoHelper = TodoHelper();
    await _todoHelper.initDatabase();
    List<TaskModel> list = await _todoHelper.getAllTask();
    if (list.isEmpty) {
    } else {
      setState(() {
        kullaniciID = list.last.kullaniciID;
        kullaniciProfilFoto = list.last.kullaniciProfilFoto;
        kullaniciMail = list.last.kullaniciMail;
        kullaniciAdi = list.last.kullaniciAdi;
      });
      return "";
    }
  }
}
