import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/noConnection.dart';
import 'package:Hackathon/widget/ilanlar.firebase.kismi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Ilanlarim extends StatefulWidget {
  @override
  _IlanlarimState createState() => _IlanlarimState();
}

class _IlanlarimState extends State<Ilanlarim> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return connected
                ? Scaffold(
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.startTop,
                    floatingActionButton: Row(
                      children: [
                        ortakLeading(context),
                        Text(
                          "İlanlarım",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    body: Container(
                      padding: EdgeInsets.only(top: 20),
                      decoration: genelSayfaTasarimi,
                      child: IlanlarFirebaseKismi(),
                    ),
                  )
                : NoConnection();
          },
          child: Container()),
    );
  }

  SizedBox buildSizedBox(AsyncSnapshot snapshot, int index, String gelenFoto) {
    return SizedBox(width: 75, height: 75, child: Image.network(gelenFoto));
  }
}
