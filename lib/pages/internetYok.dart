import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:settings_panel_android/settings_panel_android.dart';

class InternetYok extends StatelessWidget {
  const InternetYok({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Color.fromRGBO(27, 156, 252, 1),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(75),
                    bottomRight: Radius.circular(75),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "asdasdasd",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: Colors.grey,
                          fontSize: 18),
                    ),
                    buildDivider(),
                    Image.asset("asset/icon.png"),
                    buildDivider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Lütfen bağlantınızı tekrar kontrol edin veya kablosuz ağa bağlanın",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            color: Colors.blue,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(27, 156, 252, 1),
                ),
                child: Column(
                  children: [
                    buildDivider(),
                    buildFlatButton("Wi-Fi Ayarlarını Karavanda Aç"),
                    buildDivider(),
                    buildFlatButton("Wi-Fi Ayarlarına Git."),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  FlatButton buildFlatButton(String text) {
    return FlatButton(
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
      ),
      onPressed: () {
        if (text == "Wi-Fi Ayarlarını Karavanda Aç") {
          if (Platform.isAndroid) {
            SettingsPanel.display(SettingsPanelAction.wifi);
          }
        } else
          OpenSettings.openWIFISetting();
      },
    );
  }

  Divider buildDivider() {
    return Divider(
      height: 15,
      indent: 500.0,
    );
  }
}
