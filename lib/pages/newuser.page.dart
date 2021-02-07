import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/widget/new.User.Eposta.dart';
import 'package:Hackathon/widget/new.user.giris.yap.butonu.dart';
import 'package:Hackathon/widget/new.user.kullanici.adi.dart';
import 'package:Hackathon/widget/new.user.password.dart';
import 'package:Hackathon/widget/new.user.uyeligedevam.dart';
import 'package:Hackathon/widget/textLogin.dart';
import 'package:Hackathon/widget/verticalText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
TextEditingController newName = TextEditingController();
TextEditingController newEmail = TextEditingController();
TextEditingController newPassword = TextEditingController();

GlobalKey<FormState> _nameNew = GlobalKey<FormState>();
GlobalKey<FormState> _mailNew = GlobalKey<FormState>();
GlobalKey<FormState> _passwordNew = GlobalKey<FormState>();

class _NewUserState extends State<NewUser> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        setState(() {
          newName.clear();
          newEmail.clear();
          newPassword.clear();
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
                        text: "Üye Ol",
                      ),
                      TextLogin(
                        text: "Yeni Şeyler İçin Üye Ol",
                      ),
                    ],
                  ),
                  NewUserKullaniciAdi(
                    keyy: _nameNew,
                    validator: kullaniciAdiValidator,
                    controller: newName,
                  ),
                  NewUserEPosta(
                    keyy: _mailNew,
                    controller: newEmail,
                    validator: emailValidator,
                  ),
                  NewUserPassword(
                    keyy: _passwordNew,
                    controller: newPassword,
                    validator: passwordValidator,
                  ),
                  UyeligeDevamEt(
                    firebaseauth: _firebaseAuth,
                    globalkey1: _nameNew,
                    globalkey2: _mailNew,
                    globalkey3: _passwordNew,
                    mail: newEmail,
                    password: newPassword,
                    kullaniciadi: newName,
                  ),
                  NewUserGirisYapButonu(
                    name: newName,
                    mail: newEmail,
                    password: newPassword,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
