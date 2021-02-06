import 'dart:ui';

import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/sqflite.dart';
import 'package:Hackathon/widget/first.dart';
import 'package:Hackathon/widget/textLogin.dart';
import 'package:Hackathon/widget/verticalText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:Hackathon/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

String idd;
TaskModel gonderilen;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
TextEditingController passwordGiris = TextEditingController();
TextEditingController mailGiris = TextEditingController();
GlobalKey<FormState> _password = GlobalKey<FormState>();
GlobalKey<FormState> _mail = GlobalKey<FormState>();

String passwordValidator(String value) {
  if (value.length < 6) {
    return 'Şifreniz en az 6 karakter içermelidir.';
  } else {
    return null;
  }
}

String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Lütfen geçerli bir mail adresi giriniz.';
  } else {
    return null;
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final TodoHelper _todoHelper = TodoHelper();
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        body: Container(
          decoration: genelSayfaTasarimi,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    VerticalText(
                      text: "Giriş Yap",
                    ),
                    TextLogin(
                      text:
                          "İnsanlarla Etkileşime Geçmek İçin Giriş Yapman Yeterli.",
                    ),
                  ]),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Form(
                        key: _mail,
                        child: TextFormField(
                          controller: mailGiris,
                          validator: emailValidator,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'E-Posta',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Form(
                        key: _password,
                        child: TextFormField(
                          controller: passwordGiris,
                          validator: passwordValidator,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Şifre',
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, right: 50, left: 200),
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
                            final user =
                                await _firebaseAuth.signInWithEmailAndPassword(
                                    email: mailGiris.text.trim(),
                                    password: passwordGiris.text.trim());
                            if (user.user.emailVerified == true) {
                              databaseReferance
                                  .collection("users")
                                  .where("uid", isEqualTo: user.user.uid)
                                  .get()
                                  .then((value) {
                                idd = value.docs.first.id;
                                print(value.docs.first.data()["kullanıcıAdı"]);
                                gonderilen = TaskModel(
                                    kullaniciAdi:
                                        value.docs.first.data()["kullanıcıAdı"],
                                    kullaniciID: idd,
                                    kullaniciMail: mailGiris.text.trim(),
                                    kullaniciProfilFoto:
                                        value.docs.first.data()["profilFoto"]);
                                _todoHelper.insertTask(gonderilen);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => AnaEkran()),
                                    (Route<dynamic> route) => false);
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
                                                final userTekrar =
                                                    await _firebaseAuth
                                                        .signInWithEmailAndPassword(
                                                            email: mailGiris
                                                                .text
                                                                .trim(),
                                                            password:
                                                                passwordGiris
                                                                    .text
                                                                    .trim());
                                                userTekrar.user
                                                    .sendEmailVerification()
                                                    .whenComplete(() => buildToast(
                                                        "Bağlantı gönderildi."));
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
                            buildToast("Böyle bir hesap yok.");
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
                  ),
                  FirstTime(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buildToast(String text) => Toast.show(text, context,
      duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
}
