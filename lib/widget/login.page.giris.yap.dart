import 'dart:ui';

import 'package:Hackathon/main.dart';
import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:flutter/material.dart';

import 'sqflite.dart';

String idd;
TaskModel gonderilen;

class LoginPageGirisYap extends StatefulWidget {
  final firebaseauth;
  final mailGiris;
  final passwordGiris;
  final gonderilen;
  const LoginPageGirisYap({
    Key key,
    this.firebaseauth,
    this.mailGiris,
    this.passwordGiris,
    this.gonderilen,
  }) : super(key: key);

  @override
  _LoginPageGirisYapState createState() => _LoginPageGirisYapState();
}

class _LoginPageGirisYapState extends State<LoginPageGirisYap> {
  final TodoHelper _todoHelper = TodoHelper();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 50, left: 200),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue[300],
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(
                5.0,
                5.0,
              ),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: FlatButton(
          onPressed: () async {
            try {
              final user = await widget.firebaseauth.signInWithEmailAndPassword(
                  email: widget.mailGiris.text.trim(),
                  password: widget.passwordGiris.text.trim());
              if (user.user.emailVerified == true) {
                databaseReferance
                    .collection("users")
                    .where("uid", isEqualTo: user.user.uid)
                    .get()
                    .then((value) {
                  idd = value.docs.first.id;
                  print(value.docs.first.data()["kullanıcıAdı"]);
                  gonderilen = TaskModel(
                      kullaniciAdi: value.docs.first.data()["kullanıcıAdı"],
                      kullaniciID: idd,
                      kullaniciMail: widget.mailGiris.text.trim(),
                      kullaniciProfilFoto:
                          value.docs.first.data()["profilFoto"]);
                  _todoHelper.insertTask(gonderilen);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => AnaEkran()),
                      (Route<dynamic> route) => false);
                  setState(() {
                    widget.passwordGiris.clear();
                    widget.mailGiris.clear();
                  });
                });
              } else {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 4.0,
                            sigmaY: 4.0,
                          ),
                          child: AlertDialog(
                            title: Text(
                              "Mail adresini doğrula",
                              style: TextStyle(fontSize: 17),
                            ),
                            actions: [
                              FlatButton(
                                color: Colors.deepOrange,
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final userTekrar = await widget.firebaseauth
                                      .signInWithEmailAndPassword(
                                          email: widget.mailGiris.text.trim(),
                                          password:
                                              widget.passwordGiris.text.trim());
                                  userTekrar.user
                                      .sendEmailVerification()
                                      .whenComplete(() => buildToast(
                                          context, "Bağlantı gönderildi."));
                                },
                                child: Text("Tekrar Gönder"),
                              ),
                              FlatButton(
                                color: Colors.green,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Tamam"),
                              ),
                            ],
                          ));
                    });
              }
            } catch (_) {
              buildToast(context, "Böyle bir hsap yok.");
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Giriş Yap',
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
