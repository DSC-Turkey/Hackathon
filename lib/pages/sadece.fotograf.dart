import 'package:Hackathon/pages/internetYok.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:photo_view/photo_view.dart';

class SadeceFotograf extends StatefulWidget {
  final gelenFoto;

  const SadeceFotograf({Key key, this.gelenFoto}) : super(key: key);
  @override
  _SadeceFotografState createState() => _SadeceFotografState();
}

bool appBar = false;

class _SadeceFotografState extends State<SadeceFotograf> {
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
                  appBar: appBar == false
                      ? AppBar(
                          backgroundColor: Colors.black,
                        )
                      : AppBar(
                          backgroundColor: Colors.black,
                          automaticallyImplyLeading: false,
                        ),
                  body: GestureDetector(
                    onTap: () {
                      if (appBar == false) {
                        setState(() {
                          appBar = !appBar;
                        });
                      } else {
                        setState(() {
                          appBar = !appBar;
                        });
                      }
                    },
                    child: Container(
                      child: PhotoView(
                        heroAttributes: PhotoViewHeroAttributes(
                            tag: "hero${widget.gelenFoto}"),
                        filterQuality: FilterQuality.high,
                        loadFailedChild: CircularProgressIndicator(),
                        imageProvider: NetworkImage(widget.gelenFoto),
                      ),
                    ),
                  ),
                )
              : InternetYok();
        },
        child: Container(),
      ),
    );
  }
}
