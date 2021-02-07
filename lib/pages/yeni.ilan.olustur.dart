import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:Hackathon/main.dart';
import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/pages/profil.Foto.Sec.dart';
import 'package:Hackathon/yuklemeEkraniBekleme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

var sehirler;
var ilceler;
var secilenSehir;
String dropdownValueSehir = 'Seçiniz';
String dropdownValueIlce = 'Seçiniz';
String dropdownValueIlan = 'Seçiniz';
File _image;
String gelenKullaniciAdi;
String profilUrl;

class YeniIlanOlustur extends StatefulWidget {
  @override
  _YeniIlanOlusturState createState() => _YeniIlanOlusturState();
}

TextEditingController controller = TextEditingController();

class _YeniIlanOlusturState extends State<YeniIlanOlustur> {
  bool isLoaded = false;
  loadJson() async {
    String data = await rootBundle.loadString('asset/json/sehirler.json');
    sehirler = json.decode(data);
    String datailce = await rootBundle.loadString('asset/json/ilceler.json');
    ilceler = await json.decode(datailce);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    loadJson();
    dropdownValueSehir = 'Seçiniz';
    dropdownValueIlce = 'Seçiniz';
    dropdownValueIlan = 'Seçiniz';
    super.initState();
  }

  List<File> fotolar = [];
  List fotolarLink = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: genelSayfaTasarimi,
        child: !isLoaded
            ? Center(
                child: YuklemeBeklemeEkrani(
                gelenYazi: "Yükleme Tamamlanıyor. Bekleyiniz.",
              ))
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          onChanged: (value) {},
                          maxLines: 5,
                          minLines: 1,
                          showCursor: true,
                          textInputAction: TextInputAction.newline,
                          toolbarOptions: ToolbarOptions(
                              selectAll: true,
                              copy: true,
                              cut: true,
                              paste: true),
                          controller: controller,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              hintText: 'Bir mesaj yazın.',
                              border: InputBorder.none),
                        )),
                  ),
                  ExpansionTile(
                    onExpansionChanged: (a) {
                      FocusScope.of(context).unfocus();
                    },
                    backgroundColor: Colors.white,
                    subtitle: Text("Neredesiniz ?"),
                    leading: Icon(Icons.location_on),
                    title: Text(
                      "Konum Bilgileri",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DropdownButton<String>(
                            dropdownColor: Colors.lightBlueAccent,
                            value: dropdownValueSehir,
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.black,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.blue,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                if (dropdownValueSehir != "Seçiniz")
                                  dropdownValueIlce = "Seçiniz";
                                dropdownValueSehir = newValue;
                                for (var i = 0;
                                    i < sehirler[2]["data"].length;
                                    i++) {
                                  if (sehirler[2]["data"][i]["sehir_title"] ==
                                      dropdownValueSehir) {
                                    secilenSehir =
                                        sehirler[2]["data"][i]["sehir_key"];
                                  }
                                }
                                print(secilenSehir);
                              });
                            },
                            items: <String>[
                              'Seçiniz',
                              for (var i = 0;
                                  i < sehirler[2]["data"].length;
                                  i++)
                                sehirler[2]["data"][i]["sehir_title"],
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                          ),
                          dropdownValueSehir != "Seçiniz"
                              ? DropdownButton<String>(
                                  value: dropdownValueIlce,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.blue,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValueIlce = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Seçiniz',
                                    for (var i = 0;
                                        i < ilceler[2]["data"].length;
                                        i++)
                                      if (ilceler[2]["data"][i]
                                              ["ilce_sehirkey"] ==
                                          secilenSehir)
                                        ilceler[2]["data"][i]["ilce_title"]
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                ),
                        ],
                      )
                    ],
                  ),
                  ExpansionTile(
                    onExpansionChanged: (a) {
                      FocusScope.of(context).unfocus();
                    },
                    backgroundColor: Colors.white,
                    subtitle: Text("Neden bu ilanı veriyorsun?"),
                    leading: Icon(Icons.question_answer),
                    title: Text(
                      "İlan Çeşidi",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      DropdownButton<String>(
                        value: dropdownValueIlan,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValueIlan = newValue;
                          });
                        },
                        items: <String>[
                          'Seçiniz',
                          'Para Yardımı İstiyorum',
                          'Ürün Yardımı İstiyorum',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  ExpansionTile(
                    onExpansionChanged: (a) {
                      FocusScope.of(context).unfocus();
                    },
                    backgroundColor: Colors.white,
                    subtitle: Text("Fotoğraf yüklemek istersen yükle."),
                    leading: Icon(Icons.question_answer),
                    title: Text(
                      "Fotoğraf",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 5,
                        children: <Widget>[
                          fotolar.length > 0
                              ? buildContainer(gelenfile: fotolar[0])
                              : buildContainer(),
                          fotolar.length > 1
                              ? buildContainer(gelenfile: fotolar[1])
                              : buildContainer(),
                          fotolar.length > 2
                              ? buildContainer(gelenfile: fotolar[2])
                              : buildContainer(),
                          fotolar.length > 3
                              ? buildContainer(gelenfile: fotolar[3])
                              : buildContainer(),
                          fotolar.length > 4
                              ? buildContainer(gelenfile: fotolar[4])
                              : buildContainer(),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, right: 50, left: 200),
                    child: Container(
                      alignment: Alignment.bottomRight,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[300],
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                          ),
                        ],
                        color: fotolar.length > 0 ? Colors.white : Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FlatButton(
                        onPressed: fotolar.length > 0
                            ? () async {
                                showDialog(
                                    barrierDismissible: false,
                                    context: this.context,
                                    builder: (BuildContext context) {
                                      return BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 4.0,
                                            sigmaY: 4.0,
                                          ),
                                          child: AlertDialog(
                                            title: Row(
                                              children: [
                                                Text(
                                                  "İlan Oluşturuluyor.",
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                ),
                                                CircularProgressIndicator(),
                                              ],
                                            ),
                                          ));
                                    });
                                databaseReferance
                                    .collection("users")
                                    .doc(kullaniciID)
                                    .get()
                                    .then((value) {
                                  gelenKullaniciAdi =
                                      value.data()["kullanıcıAdı"];
                                });
                                for (var i = 0; i < fotolar.length; i++) {
                                  final _firebaseStorage =
                                      FirebaseStorage.instance;
                                  var fileName = basename(fotolar[i].path);
                                  var snapshot = await _firebaseStorage
                                      .ref()
                                      .child('uploads/$fileName')
                                      .putFile(fotolar[i]);
                                  var downloadUrl =
                                      await snapshot.ref.getDownloadURL();
                                  setState(() {
                                    profilUrl = downloadUrl;
                                    fotolarLink.add(profilUrl);
                                  });
                                }
                                databaseReferance.collection("ilanlar").add({
                                  "paylasanID": kullaniciID,
                                  "paslasanName":
                                      gelenKullaniciAdi.toLowerCase(),
                                  "fotograflar": fotolarLink,
                                  "sehir": dropdownValueSehir.toLowerCase(),
                                  "ilçe": dropdownValueIlce.toLowerCase(),
                                  "ilanKonusu": dropdownValueIlan.toLowerCase(),
                                  "ilanYazisi": controller.text.toLowerCase(),
                                  "begenenler": [],
                                }).whenComplete(() {
                                  setState(() {
                                    controller.clear();
                                  });
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'İlanı Gönder',
                              style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.lightBlueAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  GestureDetector buildContainer({File gelenfile}) {
    return GestureDetector(
        onTap: () {
          gelenfile != null ? deletePic(gelenfile) : secimEkrani();
        },
        child: Container(
          decoration: BoxDecoration(
            color: gelenfile == null ? Colors.blueAccent : Colors.grey[50],
            border: gelenfile == null ? Border.all(width: 2) : null,
          ),
          child: gelenfile != null
              ? Image.file(gelenfile)
              : Icon(Icons.camera_alt),
        ));
  }

  void secimEkrani() {
    showModalBottomSheet(
        context: this.context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: new Text('Galeri'),
                      onTap: () {
                        _imgFrom(
                          ImageSource.gallery,
                        );
                        Navigator.of(this.context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Kamera'),
                    onTap: () {
                      _imgFrom(
                        ImageSource.camera,
                      );
                      Navigator.of(this.context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFrom(dynamic nereden) async {
    File image =
        // ignore: deprecated_member_use
        await ImagePicker.pickImage(source: nereden, imageQuality: 50);
    if (image != null) {
      setState(() {
        _image = image;
      });
      _cropImage(_image);
    }
  }

  void deletePic(File gelen) {
    showDialog(
        barrierDismissible: false,
        context: this.context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: AlertDialog(
                title: Text(
                  "Fotoğrafı kaldırmak istediğine emin misin?",
                  style: TextStyle(fontSize: 17),
                ),
                actions: [
                  FlatButton(
                    color: Colors.deepOrange,
                    onPressed: () {
                      setState(() {
                        fotolar.remove(gelen);
                      });
                      Navigator.pop(context);
                      Toast.show("Fotoğraf Kaldırıldı", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    },
                    child: Text("Evet"),
                  ),
                  FlatButton(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Hayır"),
                  ),
                ],
              ));
        });
  }

  Future<Null> _cropImage(dynamic gelen) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: gelen.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          hideBottomControls: true,
          showCropGrid: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      cropImage = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
      fotolar.add(cropImage);
    }
  }
}
