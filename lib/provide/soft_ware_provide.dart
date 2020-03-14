import 'package:flutter/material.dart';

class SoftWareProvide with ChangeNotifier {
  ///选择网络
  String groupValue = 'wifi';

  ///模式
  String mod = '';

  ///log
  List<String> logs = [];

  ///强制发起权限
  bool permission = false;

  ///获取图片数量
  num size = 20;

  ///获取全部
  bool all = false;

  String gpsAddr = '';

  changeGroupValue(String value) {
    this.groupValue = value;
    notifyListeners();
  }

  changeMod(String value) {
    this.mod = value;
    notifyListeners();
  }

  changeGpsAddr(String value) {
    this.gpsAddr = value;
    notifyListeners();
  }

  insertLogs(String insert) {
    this.logs.add(insert);
    notifyListeners();
  }

  clearLogs() {
    this.logs.clear();
    notifyListeners();
  }

  changePermission(bool per) {
    this.permission = per;
    notifyListeners();
  }

  changePhotoSize(int size) {
    this.size = size;
    notifyListeners();
  }

  changeGetAll(bool type) {
    this.all = type;
    notifyListeners();
  }
}
