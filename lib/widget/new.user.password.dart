import 'package:flutter/material.dart';

class NewUserPassword extends StatefulWidget {
  final keyy;
  final controller;
  final validator;
  const NewUserPassword({
    Key key,
    this.keyy,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _NewUserPasswordState createState() => _NewUserPasswordState();
}

class _NewUserPasswordState extends State<NewUserPassword> {
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
