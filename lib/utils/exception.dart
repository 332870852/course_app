import 'package:flutter/material.dart';
///
class ServerErrorException implements Exception{
  int code;
  String msg;
  dynamic extra;

  ServerErrorException({this.code, this.msg, this.extra});

  @override
  String toString() {
    return 'ServerErrorException{code: $code, msg: $msg, extra: $extra}';
  }

}