import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:toast/toast.dart';

BoxDecoration genelSayfaTasarimi = BoxDecoration(
  gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Colors.blueGrey, Colors.lightBlueAccent]),
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
