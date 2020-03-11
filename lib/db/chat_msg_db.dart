import 'dart:io';
import 'package:course_app/data/chat/chat_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class ChatMsgProvider {
  final String tableName = "ChatMsg"; //表名
  final String DbName;
  Database db;

  ChatMsgProvider({@required this.DbName});

  Future<String> get _dbPath async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DbName + ".db");
    return path;
  }



  Future open() async {
    final path = await _dbPath;
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('create table $tableName (msgId text,'
          'senderId text not null,'
          'receiverId text not null,'
          'msg text ,'
          'msgType num,'
          'createTime text,'
          'extand text,'
          ')');
    });
  }

  //插入
  Future<int> insert(ChatMessage chatMessage) async {
    db = await open();
    int id = await db.insert(tableName, chatMessage.toJson());
    return id;
  }
  
  Future close() async => db.close();
}
