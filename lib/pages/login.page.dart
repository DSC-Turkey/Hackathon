import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/sqflite.dart';
import 'package:Hackathon/widget/login.page.eposta.dart';
import 'package:Hackathon/widget/login.page.giris.yap.dart';
import 'package:Hackathon/widget/login.page.ilk.seferin.mi.dart';
import 'package:Hackathon/widget/login.page.password.dart';
import 'package:Hackathon/widget/login.page.sifre.unuttum.dart';
import 'package:Hackathon/widget/textLogin.dart';
import 'package:Hackathon/widget/verticalText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

String idd;
TaskModel gonderilen;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
TextEditingController passwordGiris = TextEditingController();
TextEditingController mailGiris = TextEditingController();
TextEditingController sifreUnuttum = TextEditingController();
GlobalKey<FormState> _sifreUnuttum = GlobalKey<FormState>();
GlobalKey<FormState> _password = GlobalKey<FormState>();
GlobalKey<FormState> _mail = GlobalKey<FormState>();

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        setState(() {
          passwordGiris.clear();
          mailGiris.clear();
        });
        Navigator.pop(context);
      },
      child: Scaffold(
        body: Container(
          decoration: genelSayfaTasarimi,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      VerticalText(
                        text: "Giriş Yap",
                      ),
                      TextLogin(
                        text:
                            "İnsanlarla Etkileşime Geçmek İçin Giriş Yapman Yeterli.",
                      ),
                    ],
                  ),
                  LoginPageEPosta(
                    controller: mailGiris,
                    keyy: _mail,
                    validator: emailValidator,
                  ),
                  LoginPagePassword(
                    keyy: _password,
                    validator: passwordValidator,
                    controller: passwordGiris,
                  ),
                  LoginPageGirisYap(
                    firebaseauth: _firebaseAuth,
                    mailGiris: mailGiris,
                    passwordGiris: passwordGiris,
                    gonderilen: gonderilen,
                  ),
                  LoginPageIlkSeferinMi(
                    passwordGiris: passwordGiris,
                    mailGiris: mailGiris,
                  ),
                  LoginPageSifreUnuttum(
                    globalKey1: _sifreUnuttum,
                    validator: emailValidator,
                    controller: sifreUnuttum,
                    firebaseAuth: _firebaseAuth,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
