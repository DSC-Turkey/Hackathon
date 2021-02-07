import 'package:flutter/material.dart';

class NewUserEPosta extends StatefulWidget {
  final keyy;
  final controller;
  final validator;
  const NewUserEPosta({
    Key key,
    this.keyy,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  _NewUserEPostaState createState() => _NewUserEPostaState();
}

class _NewUserEPostaState extends State<NewUserEPosta> {
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
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.lightBlueAccent,
              labelText: 'E-posta',
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
