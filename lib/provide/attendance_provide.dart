import 'dart:async';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';

///考勤页管理
class AttendProvide with ChangeNotifier {
  ///UI
  Duration timer = Duration(minutes: 5);
  int type = 0;

  ///0-数字考勤，1-gps考勤
  Location _location; //地点
  String address = '';
  LatLng latLng;
  bool addressBtn = true;
  num distance = 10;

  changeDistance(num distance) {
    this.distance = distance;
    notifyListeners();
  }

  changAddressBtn(bool status) {
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

    //////////
    counterTimegg = 60;
  }

  ///////
  Timer timers;
  int counterTimegg = 0;
  double minutes=0;
  int second=0;

  startCountdownTimer(Duration d) {
    print('进来 ${d.inSeconds}');
    counterTimegg=d.inSeconds;
    minutes=counterTimegg/60;
    second=counterTimegg%60;
    var oneMinuute = Duration(seconds: 1);
    var callback = (Timer time) async{
      print(time.tick);
      if (counterTimegg < 1) {
        timers.cancel();
      } else {
        counterTimegg = counterTimegg-1;
        minutes=counterTimegg/60;
        second=counterTimegg%60;
      }
      notifyListeners();
    };
    timers = Timer.periodic(oneMinuute, callback);
  }
}
