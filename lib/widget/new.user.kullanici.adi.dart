import 'package:flutter/material.dart';

class NewUserKullaniciAdi extends StatefulWidget {
  final keyy;

  final controller;

  final validator;
  const NewUserKullaniciAdi({
    Key key,
    this.keyy,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _NewUserKullaniciAdiState createState() => _NewUserKullaniciAdiState();
}

class _NewUserKullaniciAdiState extends State<NewUserKullaniciAdi> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: widget.keyy,
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
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
    );
  }
}
