

import 'dart:async';

import 'package:flutter/material.dart';

class TimeExpire{
   int expire=0;
   double minutes = 0;
   int second = 0;

}

///倒计时器
class ExpireTimerProvide with ChangeNotifier{

  Map<int, Timer> timerMap = Map();
  Map<int, TimeExpire>  timeExpire=Map();
  ///////
  void init(){
    timerMap.clear();
    timeExpire.clear();

  }
  //开始计时方法
  startCountdownTimer(Duration d, int id) {
    int counterTime = d.inSeconds;
    print('进来 ${counterTime}');
    TimeExpire expireT=TimeExpire();
    expireT.expire=counterTime;
    expireT.minutes= counterTime / 60;
    expireT.second = counterTime % 60;
    timeExpire.putIfAbsent(id, ()=>expireT);
    var oneMinuute = Duration(seconds: 1);
    var callback = (Timer timer) async {
     // print(timer.tick);
      if (timeExpire[id].expire < 1) {
         timerMap[id].cancel();
        if (timerMap.containsKey(id)) {
          timerMap.remove(id);
        }
        print('remove :${timerMap}');
      } else {
        int temp=timeExpire[id].expire;
        timeExpire[id].expire =temp- 1;
        timeExpire[id].minutes = temp / 60;
        timeExpire[id].second = temp % 60;
      }
      notifyListeners();
    };
    timerMap.putIfAbsent(id, ()=>Timer.periodic(oneMinuute, callback));
  }

}