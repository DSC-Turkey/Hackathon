import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//if not exists
final String tableName = "Bilgiler";
// ignore: non_constant_identifier_names
final String Column_id = "ID";
// ignore: non_constant_identifier_names
final String Column_kullaniciID = "KullanıcıId";
// ignore: non_constant_identifier_names
final String Column_kullaniciMail = "KullanıcıMail";
// ignore: non_constant_identifier_names
final String Column_profilFoto = "KullanıcıProfilFoto";

class TaskModel {
  final String kullaniciID;
  final String kullaniciMail;
  final String kullaniciProfilFoto;
  int id;

  TaskModel({
    this.kullaniciID,
    this.kullaniciMail,
    this.kullaniciProfilFoto,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      Column_kullaniciID: this.kullaniciID,
      Column_kullaniciMail: this.kullaniciMail,
      Column_profilFoto: this.kullaniciProfilFoto,
    };
  }
}

class TodoHelper {
  Database db;

  TodoHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "database.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT, $Column_kullaniciID TEXT, $Column_kullaniciMail TEXT, $Column_profilFoto TEXT)");
    }, version: 1);
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      db.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      print(_);
    }
  }

  Future<void> delete() async {
    await deleteDatabase("database.db");
  }

  Future<List<TaskModel>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);

    return List.generate(tasks.length, (i) {
      return TaskModel(
        kullaniciID: tasks[i][Column_kullaniciID],
        kullaniciMail: tasks[i][Column_kullaniciMail],
        kullaniciProfilFoto: tasks[i][Column_profilFoto],
        id: tasks[i][Column_id],
      );
    });
  }
}
