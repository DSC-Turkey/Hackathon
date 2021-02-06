import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/login.page.dart';
import 'package:Hackathon/widget/textLogin.dart';
import 'package:Hackathon/widget/verticalText.dart';
import 'package:flutter/material.dart';

class IlkEkran extends StatefulWidget {
  @override
  _IlkEkranState createState() => _IlkEkranState();
}

class _IlkEkranState extends State<IlkEkran> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: genelSayfaTasarimi,
        child: ListView(
          children: [
            Column(
              children: [
                Row(children: <Widget>[
                  VerticalText(
                    text: "Hoşgeldin",
                  ),
                  TextLogin(
                      text: "Nitelikli Eğitim İçin Yardımlaşma Platformu"),
                ]),
                SizedBox(
                  width: 300,
                  child: Image.asset("asset/icon.png"),
                ),
                Divider(
                  height: 15,
                  indent: 500.0,
                ),
                Container(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Başlayın',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
