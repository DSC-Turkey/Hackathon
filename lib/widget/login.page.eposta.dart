import 'package:flutter/material.dart';

class LoginPageEPosta extends StatefulWidget {
  final keyy;
  final controller;
  final validator;
  const LoginPageEPosta({
    Key key,
    this.keyy,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _LoginPageEPostaState createState() => _LoginPageEPostaState();
}

class _LoginPageEPostaState extends State<LoginPageEPosta> {
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
              labelText: 'E-Posta',
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
