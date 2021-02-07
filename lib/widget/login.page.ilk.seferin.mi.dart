import 'package:Hackathon/pages/newuser.page.dart';
import 'package:flutter/material.dart';

class LoginPageIlkSeferinMi extends StatefulWidget {
  final passwordGiris;
  final mailGiris;
  const LoginPageIlkSeferinMi({
    Key key,
    this.passwordGiris,
    this.mailGiris,
  }) : super(key: key);

  @override
  _LoginPageIlkSeferinMiState createState() => _LoginPageIlkSeferinMiState();
}

class _LoginPageIlkSeferinMiState extends State<LoginPageIlkSeferinMi> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 30),
      child: Container(
        alignment: Alignment.topRight,
        //color: Colors.red,
        height: 20,
        child: Row(
          children: <Widget>[
            Text(
              'İlk seferin mi?',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewUser()));
                setState(() {
                  widget.passwordGiris.clear();
                  widget.mailGiris.clear();
                });
              },
              child: Text(
                'Üye Ol',
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
