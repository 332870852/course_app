import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';
///创建考勤状态管理
class ShowAttendProvide with ChangeNotifier{
  ///UI
  Duration timer = Duration(minutes: 5);
  int type = 0;

  ///0-数字考勤，1-gps考勤
  Location _location; //地点
  String address = '';
  LatLng latLng;
  bool addressBtn = true;
  num distance = 10;
  bool displaycreateBnt=false;
  changeDistance(num distance) {
    this.distance = distance;
    notifyListeners();
  }

  Future changAddressBtn(bool status) async{
    this.addressBtn = status;
    notifyListeners();
  }

  changeLocation(Location location) {
    this._location = location;
    notifyListeners();
  }

  Future changeAddress({String address, LatLng latLng}) async {
    this.address = address;
    this.latLng = latLng;
    notifyListeners();
  }

  changeDisplayTimer(Duration t) {
    this.timer = t;
    notifyListeners();
  }

  changeType(int num) {
    this.type = num;
    notifyListeners();
  }

  //////
  void initStatus() {
    ///UI
    this.timer = Duration(minutes: 5);
    this.type = 0;
    addressBtn = true;


    ///0-数字考勤，1-gps考勤
    this._location = null; //地点
    this.address = '';
    this.latLng = null;
    distance = 10;
    displaycreateBnt=false;
    //////////
    //counterTimegg = 60;
  }

  void changeCreateBtn(bool status) {
    displaycreateBnt=status;
    notifyListeners();
  }
}