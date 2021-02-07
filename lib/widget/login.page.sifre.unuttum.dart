import 'dart:ui';

import 'package:Hackathon/ortak/ortak.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class LoginPageSifreUnuttum extends StatefulWidget {
  final globalKey1;
  final validator;
  final controller;
  final firebaseAuth;

  const LoginPageSifreUnuttum({
    Key key,
    this.globalKey1,
    this.validator,
    this.controller,
    this.firebaseAuth,
  }) : super(key: key);

  @override
  _LoginPageSifreUnuttumState createState() => _LoginPageSifreUnuttumState();
}

class _LoginPageSifreUnuttumState extends State<LoginPageSifreUnuttum> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 50, left: 150),
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
            showDialog<String>(
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
                        title: Text("Mail adresinizi giriniz."),
                        content: Row(
                          children: [
                            Expanded(
                              child: Form(
                                key: widget.globalKey1,
                                child: TextFormField(
                                  validator: widget.validator,
                                  controller: widget.controller,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      tooltip: "Temizle",
                                      splashRadius: 20,
                                      splashColor: Colors.blue,
                                      highlightColor: Colors.blue,
                                      icon: Icon(LineAwesomeIcons.trash),
                                      onPressed: () {
                                        widget.controller.clear();
                                      },
                                    ),
                                    icon: Icon(LineAwesomeIcons.envelope),
                                    labelText: 'E-Mail',
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'İptal',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Gönder',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () async {
                              if (widget.globalKey1.currentState.validate()) {
                                final mailVarMi = await widget.firebaseAuth
                                    .fetchSignInMethodsForEmail(
                                        widget.controller.text.trim());
                                print(mailVarMi.length);
                                if (mailVarMi.length >= 1) {
                                  await widget.firebaseAuth
                                      .sendPasswordResetEmail(
                                          email: widget.controller.text.trim())
                                      .whenComplete(() {
                                    Navigator.pop(context);
                                    buildToast(context,
                                        "Şifre sıfırlama bağlantısı gönderildi. Mail kutunu kontrol et.");
                                  });
                                } else {
                                  buildToast(context,
                                      "${widget.controller.text} mail hesabı sistemde bulunamadı.");
                                }
                              }
                            },
                          )
                        ],
                      ));
                }).whenComplete(() {
              setState(() {
                widget.controller.clear();
              });
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Şifremi Unuttum',
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                LineAwesomeIcons.user_lock,
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
