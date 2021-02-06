import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/profil.Foto.Sec.dart';
import 'package:Hackathon/widget/textLogin.dart';
import 'package:Hackathon/widget/userOld.dart';
import 'package:Hackathon/widget/verticalText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
TextEditingController newName = TextEditingController();
TextEditingController newEmail = TextEditingController();
TextEditingController newPassword = TextEditingController();
String kullaniciAdiValidator(String value) {
  if (value.length < 3) {
    return 'Kullanıcı adınız en az 3 karakter içermelidir.';
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

String passwordValidator(String value) {
  if (value.length < 6) {
    return 'Şifreniz en az 6 karakter içermelidir.';
  } else {
    return null;
  }
}

GlobalKey<FormState> _nameNew = GlobalKey<FormState>();
GlobalKey<FormState> _mailNew = GlobalKey<FormState>();
GlobalKey<FormState> _passwordNew = GlobalKey<FormState>();

class _NewUserState extends State<NewUser> {
  @override
  Widget build(BuildContext context) {
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
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 50, right: 50),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Form(
                        key: _nameNew,
                        child: TextFormField(
                          controller: newName,
                          validator: kullaniciAdiValidator,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'Kullanıcı Adı',
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
                        key: _mailNew,
                        child: TextFormField(
                          controller: newEmail,
                          validator: emailValidator,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.lightBlueAccent,
                            labelText: 'E-posta',
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
                        key: _passwordNew,
                        child: TextFormField(
                          controller: newPassword,
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
                          borderRadius: BorderRadius.circular(30)),
                      child: FlatButton(
                        onPressed: () async {
                          if (_nameNew.currentState.validate() &&
                              _mailNew.currentState.validate() &&
                              _passwordNew.currentState.validate()) {
                            await _firebaseAuth
                                .fetchSignInMethodsForEmail(
                                    newEmail.text.trim())
                                .then((value) {
                              if (value.length > 0) {
                                buildToast("Bu mail adresi kullanılmaktadır");
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilFotoSec(
                                              mail: newEmail.text.trim(),
                                              sifre: newPassword.text.trim(),
                                              name: newName.text.trim(),
                                            )));
                              }
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Üyeliğe Devam',
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
                  UserOld(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buildToast(String text) => Toast.show(text, context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
}
