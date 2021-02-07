import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/pages/sadece.fotograf.dart';
import 'package:flutter/material.dart';

class ProfilGetir extends StatefulWidget {
  const ProfilGetir({
    Key key,
  }) : super(key: key);

  @override
  _ProfilGetirState createState() => _ProfilGetirState();
}

class _ProfilGetirState extends State<ProfilGetir> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 10,
      child: Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SadeceFotograf(
                          gelenFoto: kullaniciProfilFoto,
                        )));
          },
          child: Hero(
            tag: "hero$kullaniciProfilFoto",
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 2.0,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(70.0),
                image: kullaniciProfilFoto != null
                    ? DecorationImage(
                        image: NetworkImage(kullaniciProfilFoto),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
