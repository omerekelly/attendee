import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "attendace.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate
        // await db.execute("CREATE TABLE attendUsers ("
        //     "id INTEGER PRIMARY KEY,"
        //     "att_id INTEGER,"
        //     "name_stud TEXT,"
        //     "matno TEXT,"
        //     "department TEXT"
        //     ")");
        );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE attendances ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "date TEXT"
        ")");
  }

  Future insertAttendance(Attendance attendance) async {
    Database db = await instance.database;
    await db.insert("attendances", attendance.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Attendance>> getAttendances() async {
    Database db = await instance.database;
    var groceries = await db.query('groceries', orderBy: 'name');
    List<Attendance> attendaceList = groceries.isNotEmpty
        ? groceries.map((c) => Attendance.fromMap(c)).toList()
        : [];
    return attendaceList;
  }

  Future insertAttendUser(AttendUser attendUser) async {
    Database db = await instance.database;
    await db.insert("attendUsers", attendUser.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AttendUser>> getAttendUsers() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query("attendUsers", where: 'att_id = ?', whereArgs: [1]);
    return List.generate(maps.length, (i) {
      return AttendUser(
        id: maps[i]['id'],
        attend_id: maps[i]['att_id'],
        name_stud: maps[i]['name_stud'],
        matno: maps[i]['matno'],
        department: maps[i]['department'],
      );
    });
  }
}

class Attendance {
  final int? id;
  final String name;
  final String date;

  Attendance({this.id, required this.name, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
    };
  }

  Attendance.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        date = map['date'];
}

class AttendUser {
  final int id;
  final int attend_id;
  final String name_stud;
  final String matno;
  final String department;

  AttendUser(
      {required this.id,
      required this.attend_id,
      required this.name_stud,
      required this.matno,
      required this.department});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'att_id': attend_id,
      'name_stud': name_stud,
      'matno': matno,
      'department': department,
    };
  }
}
