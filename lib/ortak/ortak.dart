import 'dart:ui';

import 'package:Hackathon/main.dart';
import 'package:Hackathon/widget/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:toast/toast.dart';

const color = const Color(0xFF92FFC0);
const color1 = const Color(0xff002661);
BoxDecoration genelSayfaTasarimi = BoxDecoration(
  gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, color1]),
);

AppBar ortakAppBar(BuildContext context, String text) => AppBar(
      leading: IconButton(
        icon: Icon(LineAwesomeIcons.chevron_left),
        splashRadius: 20,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Colors.lightBlueAccent,
      elevation: 0,
      title: Text(text),
    );
Padding yuklemeBasarisizIse() => Padding(
      padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
      child: CircleAvatar(
        backgroundColor: Colors.grey[50],
        child: Icon(
          Icons.clear,
          color: Colors.red,
        ),
      ),
    );
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

String kullaniciAdiValidator(String value) {
  if (value.length < 3 || value.length > 12) {
    return 'En az 3, en fazla 12 karakter içermelidir.';
  } else {
    return null;
  }
}

void buildToast(BuildContext context, String text) => Toast.show(text, context,
    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);

void ortakislemler(
    BuildContext context, dynamic firebaseAuth, String text, dynamic id) {
  showDialog(
      barrierDismissible: false,
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
              title: Text(text),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Evet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onPressed: () async {
                    if (text ==
                        "Mailinize bir şifre sıfırlama bağlantısı gönderilecektir.") {
                      await firebaseAuth
                          .sendPasswordResetEmail(
                              email: firebaseAuth.currentUser.email)
                          .whenComplete(() {
                        Navigator.pop(context);
                        Toast.show("Bağlantı Gönderildi.", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.CENTER);
                      });
                    } else if (text ==
                        "Oturumu kapatmak istediğine emin misin?") {
                      final TodoHelper _todoHelper = TodoHelper();
                      _todoHelper.delete();
                      Navigator.of(context)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => MyApp()),
                              (Route<dynamic> route) => false)
                          .whenComplete(() {
                        Toast.show("Oturum Kapatıldı", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      });
                    } else if (text ==
                        "Uygulamadan çıkmak istediğine emin misin?") {
                      SystemNavigator.pop();
                    } else if (text == "İlanı silmek istediğine emin misin?") {
                      databaseReferance
                          .collection("ilanlar")
                          .doc(id)
                          .delete()
                          .whenComplete(() {
                        Navigator.pop(context);
                        buildToast(context, "İlan silindi.");
                      });
                    }
                  },
                ),
                FlatButton(
                  child: Text(
                    'Hayır',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      });
}

Center landingPage(String text) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
      ),
    ),
  );
}

IconButton ortakLeading(BuildContext context) {
  return IconButton(
    icon: Icon(LineAwesomeIcons.arrow_left),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}
