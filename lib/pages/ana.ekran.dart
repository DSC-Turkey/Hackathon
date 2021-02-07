import 'dart:ui';

import 'package:Hackathon/main.dart';
import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/ilanlarim.dart';
import 'package:Hackathon/pages/sadece.fotograf.dart';
import 'package:Hackathon/widget/sqflite.dart';
import 'package:Hackathon/pages/tabcontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:toast/toast.dart';

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
                            image: kullaniciProfilFoto != null
                                ? DecorationImage(
                                    image: NetworkImage(kullaniciProfilFoto),
                                    fit: BoxFit.cover,
                                  )
                                : null,
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
                    kullaniciAdi ?? "",
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
                    heroTag: "1",
                    mini: true,
                    onPressed: () {},
                    child: Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
            buildListTile(Icon(LineAwesomeIcons.envelope), kullaniciMail ?? ""),
            buildListTile(Icon(LineAwesomeIcons.lock), "Şifre İşlemleri"),
            buildListTile(Icon(LineAwesomeIcons.home), "İlanlarım"),
            buildListTile(Icon(LineAwesomeIcons.door_closed), "Oturumu Kapat"),
          ],
        ),
      ),
      body: TabBarController(),
    );
  }

  FlatButton buildListTile(Icon icon, String text) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      highlightColor: Colors.lightBlueAccent,
      onPressed: () {
        if (text == "İlanlarım") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Ilanlarim(),
            ),
          );
        } else if (text == "Oturumu Kapat")
          delete();
        else if (text == "Şifre İşlemleri") sifreDegistir();
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
      setState(() {
        kullaniciID = list.last.kullaniciID;
        kullaniciProfilFoto = list.last.kullaniciProfilFoto;
        kullaniciMail = list.last.kullaniciMail;
        kullaniciAdi = list.last.kullaniciAdi;
        print(kullaniciAdi);
      });
      return "";
    }
  }

  void delete() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                contentPadding: const EdgeInsets.all(16),
                title: Text("Oturumu kapatmak istediğine emin misin?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Evet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
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
                  ),
                  FlatButton(
                    child: Text(
                      'Hayır',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
        });
  }

  void sifreDegistir() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: AlertDialog(
                title: Text(
                  "Mailinize bir şifre sıfırlama bağlantısı gönderilecek.",
                  style: TextStyle(fontSize: 17),
                ),
                actions: [
                  FlatButton(
                    color: Colors.deepOrange,
                    onPressed: () async {
                      await _firebaseAuth
                          .sendPasswordResetEmail(
                              email: _firebaseAuth.currentUser.email)
                          .whenComplete(() {
                        Navigator.pop(context);
                        Toast.show("Bağlantı Gönderildi.", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER);
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
