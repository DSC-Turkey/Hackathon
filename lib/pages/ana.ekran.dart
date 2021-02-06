import 'dart:ui';

import 'package:Hackathon/main.dart';
import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/sadece.fotograf.dart';
import 'package:Hackathon/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

var kullaniciID;
var kullaniciProfilFoto;
var kullaniciMail;

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
    kullaniciBilgileri().whenComplete(() {
      kullaniciProfilFoto = kullaniciProfilFoto;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: genelSayfaTasarimi,
                  width: double.infinity,
                  height: 200,
                ),
                Positioned(
                  bottom: 50,
                  left: 10,
                  child: Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SadeceFotograf(
                                      gelenFoto: kullaniciProfilFoto,
                                    )));
                      },
                      child: Hero(
                        tag: "hero$kullaniciProfilFoto",
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 2.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(70.0),
                            image: DecorationImage(
                              image: NetworkImage(kullaniciProfilFoto ??
                                  "https://firebasestorage.googleapis.com/v0/b/hackathon-c3438.appspot.com/o/groom.png?alt=media&token=5aa8a568-f86d-4658-8be2-50a6db239232"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: Text(
                    'username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  left: 90,
                  bottom: 45,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () {},
                    child: Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
            buildListTile(Icon(Icons.mail), kullaniciMail ?? ""),
            buildListTile(Icon(Icons.security), "Şifre İşlemleri"),
            buildListTile(Icon(Icons.help), "Yardıma İhtiyacım Var"),
            buildListTile(Icon(Icons.settings), "Ayarlar"),
            buildListTile(Icon(Icons.close), "Oturumu Kapat"),
          ],
        ),
      ),
      body: Container(
        decoration: genelSayfaTasarimi,
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(color: Colors.red),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  FlatButton buildListTile(Icon icon, String text) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      highlightColor: Colors.lightBlueAccent,
      onPressed: () {
        text == "Oturumu Kapat" ? delete() : print("ds");
      },
      child: ListTile(
        leading: icon,
        title: Text(text),
      ),
    );
  }

  Future<dynamic> kullaniciBilgileri() async {
    final TodoHelper _todoHelper = TodoHelper();
    await _todoHelper.initDatabase();
    List<TaskModel> list = await _todoHelper.getAllTask();
    if (list.isEmpty) {
    } else {
      kullaniciID = list.last.kullaniciID;
      kullaniciProfilFoto = list.last.kullaniciProfilFoto;
      kullaniciMail = list.last.kullaniciMail;
      return "";
    }
  }

  void delete() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: AlertDialog(
                title: Text(
                  "Oturumu kapatmak istediğine emin misin?",
                  style: TextStyle(fontSize: 17),
                ),
                actions: [
                  FlatButton(
                    color: Colors.deepOrange,
                    onPressed: () {
                      final TodoHelper _todoHelper = TodoHelper();
                      _todoHelper.delete();
                      Navigator.of(context)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => MyApp()),
                              (Route<dynamic> route) => false)
                          .whenComplete(() {
                        Toast.show("Oturum Kapatıldı", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      });
                    },
                    child: Text("Evet"),
                  ),
                  FlatButton(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Hayır"),
                  ),
                ],
              ));
        });
  }
}
