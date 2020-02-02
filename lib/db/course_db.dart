import 'dart:io';

import 'package:course_app/provide/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provide/provide.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
class CourseInfoProvider {
  final String tableName = "CourseInfo"; //表名
  final String DbName;
  Database db;
  CourseInfoProvider({@required this.DbName});
  Future<String> get _dbPath async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DbName+".db");
    return path;
  }

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'create table $tableName (_id integer primary key autoincrement, '
                  'joincode text not null,'
                  'courseNumber text ,'
                  'start num ,'
                  'end num, '
                  'semester num,'
                  'member num,'
                  'bgkColor text,'
                  'bgkUrl text,'
                  ' teacherId text not null, cid text, )');
        });
  }
}
