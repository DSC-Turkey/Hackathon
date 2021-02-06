import 'dart:io';

import 'package:Hackathon/ortak/ortak.dart';
import 'package:Hackathon/widget/textLogin.dart';
import 'package:Hackathon/widget/verticalText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../main.dart';

class ProfilFotoSec extends StatefulWidget {
  final mail;
  final sifre;
  final uid;
  final name;

  const ProfilFotoSec({
    Key key,
    this.mail,
    this.sifre,
    this.uid,
    this.name,
  }) : super(key: key);
  @override
  _ProfilFOtoSecState createState() => _ProfilFOtoSecState();
}

String profilUrl;
String uid;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
enum AppState {
  free,
  picked,
  cropped,
}
AppState state;
File _image;
File cropImage;

class _ProfilFOtoSecState extends State<ProfilFotoSec> {
  @override
  initState() {
    state = AppState.free;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: genelSayfaTasarimi,
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    VerticalText(
                      text: "Profil Fotoğrafı",
                    ),
                    TextLogin(
                      text:
                          "Profil fotoğrafın sayesinde insanlar seni daha iyi tanıyabilir.",
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 130,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xffFDCF09),
                        child: cropImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: Image.file(
                                  cropImage,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(200)),
                                width: 150,
                                height: 150,
                              ),
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.lightBlueAccent,
                      mini: true,
                      onPressed: () => cropImage == null
                          ? secimEkrani(context)
                          : _clearImage(),
                      child: cropImage == null
                          ? Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                    ),
                    Divider(
                      height: 15,
                      indent: 500.0,
                    ),
                    cropImage != null
                        ? Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: MediaQuery.of(context).size.width - 100,
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: FlatButton(
                              onPressed: () => uploadImagee(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Üyeliği Tamamla',
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
                          )
                        : Container(),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _imgFrom(dynamic nereden) async {
    File image =
        // ignore: deprecated_member_use
        await ImagePicker.pickImage(source: nereden, imageQuality: 50);
    if (image != null) {
      setState(() {
        _image = image;
        _cropImage();
      });
    }
  }

  void secimEkrani(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: Colors.blue,
                      ),
                      title: new Text('Galeri'),
                      onTap: () {
                        _imgFrom(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                      color: Colors.blue,
                    ),
                    title: Text('Kamera'),
                    onTap: () {
                      _imgFrom(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
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
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      cropImage = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    cropImage = null;
    setState(() {
      state = AppState.free;
    });
  }

  uploadImagee() async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: widget.mail, password: widget.sifre)
        .catchError((e) {
      print("Hata");
    }).then((value) => {
              uid = value.user.uid,
            });
    final newUser = await _firebaseAuth.signInWithEmailAndPassword(
        email: widget.mail, password: widget.sifre);
    newUser.user.sendEmailVerification();
    final _firebaseStorage = FirebaseStorage.instance;
    var fileName = basename(cropImage.path);
    var snapshot = await _firebaseStorage
        .ref()
        .child('uploads/$fileName')
        .putFile(cropImage);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      profilUrl = downloadUrl;
      print(profilUrl);
    });
    databaseReferance.collection("users").add({
      "uid": uid,
      "kullanıcıAdı": widget.name,
      "profilFoto": profilUrl,
      "mail": widget.mail
    }).whenComplete(() {
      Navigator.pop(this.context);
    });
  }
}
