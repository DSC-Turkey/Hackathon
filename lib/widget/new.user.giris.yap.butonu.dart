import 'package:flutter/material.dart';

class NewUserGirisYapButonu extends StatefulWidget {
  final name;
  final mail;
  final password;
  const NewUserGirisYapButonu({
    Key key,
    this.name,
    this.mail,
    this.password,
  }) : super(key: key);

  @override
  _NewUserGirisYapButonuState createState() => _NewUserGirisYapButonuState();
}

class _NewUserGirisYapButonuState extends State<NewUserGirisYapButonu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Container(
        alignment: Alignment.topRight,
        height: 20,
        child: Row(
          children: <Widget>[
            Text(
              'Daha önce tanıştık mı ?',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  widget.name.clear();
                  widget.mail.clear();
                  widget.password.clear();
                });
                Navigator.pop(context);
              },
              child: Text(
                'Giriş Yap',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
