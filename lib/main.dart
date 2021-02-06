import 'package:Hackathon/pages/ana.ekran.dart';
import 'package:Hackathon/pages/ilk.ekran.dart';
import 'package:Hackathon/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

var databaseReferance = FirebaseFirestore.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final home = await dahaOnceGirisYaptiMi();
  runApp(home);
}

Future<dynamic> dahaOnceGirisYaptiMi() async {
  final TodoHelper _todoHelper = TodoHelper();
  await _todoHelper.initDatabase();
  List<TaskModel> list = await _todoHelper.getAllTask();
  if (list.isEmpty) {
    return MyApp();
  } else {
    return AnaEkran();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IlkEkran(),
      debugShowCheckedModeBanner: false,
    );
  }
}
