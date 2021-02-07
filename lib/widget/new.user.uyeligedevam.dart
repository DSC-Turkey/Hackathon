import 'package:Hackathon/pages/profil.Foto.Sec.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class UyeligeDevamEt extends StatefulWidget {
  final mail;
  final password;
  final kullaniciadi;
  final globalkey1;
  final globalkey2;
  final globalkey3;
  final firebaseauth;
  const UyeligeDevamEt({
    Key key,
    this.mail,
    this.password,
    this.kullaniciadi,
    this.globalkey1,
    this.globalkey2,
    this.globalkey3,
    this.firebaseauth,
  }) : super(key: key);

  @override
  _UyeligeDevamEtState createState() => _UyeligeDevamEtState();
}

class _UyeligeDevamEtState extends State<UyeligeDevamEt> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 50, left: 150),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.blue[300],
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: Offset(
              5.0,
              5.0,
            ),
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: FlatButton(
          onPressed: () async {
            if (widget.globalkey1.currentState.validate() &&
                widget.globalkey2.currentState.validate() &&
                widget.globalkey3.currentState.validate()) {
              await widget.firebaseauth
                  .fetchSignInMethodsForEmail(widget.mail.text.trim())
                  .then((value) {
                if (value.length > 0) {
                  Toast.show("Bu mail adresi kullanılmaktadır.", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilFotoSec(
                                mail: widget.mail.text.trim(),
                                sifre: widget.password.text.trim(),
                                name: widget.kullaniciadi.text.trim(),
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
    );
  }
}
