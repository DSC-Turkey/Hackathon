import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/yeni.ilan.olustur.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home(this.controller);

  final ScrollController controller;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String data =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _button,
      body: Container(
        decoration: genelSayfaTasarimi,
        child: _listView,
      ),
    );
  }

  Widget get _button => FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => YeniIlanOlustur())),
        child: Icon(Icons.add),
      );

  Widget get _listView => ListView.builder(
        itemCount: 10,
        controller: widget.controller,
        itemBuilder: (context, index) {
          return _card;
        },
      );

  Widget get _card => Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ListTile(
          leading: CircleAvatar(),
          title: Wrap(
            runSpacing: 10,
            children: <Widget>[
              Text("Hello", style: titleTextStyle),
              Text(
                data,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              _placeHolder,
              _cardButtons
            ],
          ),
        ),
      );

  Widget get _placeHolder => Container(
        height: 100,
        child: Placeholder(),
      );

  Widget get _cardButtons => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[_iconButton, _iconButton],
      );

  Widget _iconChild(String text) => Wrap(
        spacing: 5,
        children: <Widget>[
          Icon(Icons.money),
          Text(text),
        ],
      );

  Widget get _iconButton => InkWell(
        child: _iconChild("1"),
        onTap: () {},
      );
}

final titleTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black);
