import 'package:flutter/material.dart';

class YuklemeBeklemeEkrani extends StatelessWidget {
  final gelenYazi;
  const YuklemeBeklemeEkrani({
    Key key,
    this.gelenYazi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          gelenYazi,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        ),
        Divider(
          height: 5,
          indent: 500.0,
        ),
        CircularProgressIndicator(),
      ],
    ));
  }
}
