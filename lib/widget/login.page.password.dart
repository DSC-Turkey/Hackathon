import 'package:flutter/material.dart';

class LoginPagePassword extends StatefulWidget {
  final keyy;
  final validator;
  final controller;
  const LoginPagePassword({
    Key key,
    this.keyy,
    this.validator,
    this.controller,
  }) : super(key: key);

  @override
  _LoginPagePasswordState createState() => _LoginPagePasswordState();
}

class _LoginPagePasswordState extends State<LoginPagePassword> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
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
    );
  }
}
