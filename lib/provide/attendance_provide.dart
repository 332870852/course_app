import 'dart:async';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/provide/expire_timer_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

///考勤页管理
class AttendProvide with ChangeNotifier {
  List<AttendanceVo> attendanceVoList = [];

  void saveAttendanceList(context, List<AttendanceVo> list) {
    print("saveAttendanceList : ${list}");
    this.attendanceVoList = list;
    List<String> tempStr = [];
    list.forEach((item) {
      String str = json.encode(item);
      tempStr.add(str);
//       item.map
    });
    Application.sp.setStringList('AttendanceVoList', tempStr);
    //notifyListeners();
    getAttendanceList(context);
  }

  Future<List<AttendanceVo>> getAttendanceList(BuildContext context,
      {bool isNoti = false}) async {
    List<String> tempStr = Application.sp.getStringList('AttendanceVoList');
    List<AttendanceVo> list = [];
    //todo 有待改进算法
    tempStr.forEach((item) {
      AttendanceVo attendanceVo = AttendanceVo.fromJson(json.decode(item));
      attendanceVo.map.putIfAbsent(0, () => []);
      attendanceVo.map.putIfAbsent(1, () => []);
      attendanceVo.map.putIfAbsent(2, () => []);
      attendanceVo.map.putIfAbsent(3, () => []);
      attendanceVo.map.putIfAbsent(4, () => []);
      if (ObjectUtil.isNotEmpty(attendanceVo.attendanceStudents)) {
        attendanceVo.attendanceStudents.forEach((it) {
          List<AttendanceStudents> list = attendanceVo.map[it.status];
          if(list!=null){
            list.add(it);
          }
          attendanceVo.map.putIfAbsent(it.status, () => list);
        });
      }
      list.add(attendanceVo);
      print('剩余时间计时  ${attendanceVo.expire}');
      if (attendanceVo.expire > 0 &&
          Provide.value<ExpireTimerProvide>(context)
                  .timerMap[attendanceVo.attendanceId] ==
              null) {
        ///剩余时间计时
        Provide.value<ExpireTimerProvide>(context).startCountdownTimer(
            Duration(seconds: attendanceVo.expire), attendanceVo.attendanceId);
      }
    });
    this.attendanceVoList = list;
    notifyListeners();
//    if (isNoti) {
//      notifyListeners();
//    }
    return list;
  }

  ///插入一条新数据
  void insertAtten(context, AttendanceVo onValue) {
    attendanceVoList.insert(0, onValue);
    saveAttendanceList(context, attendanceVoList);
  }

  void insertAttendanceStudents(context,List<AttendanceStudents> list) {
    debugPrint("insertAttendanceStudents");
    int i=0,index=0;
    this.attendanceVoList.forEach((item){
        if(item.attendanceId.toString()==list[0].attendanceId){
          index=i;
          print(i);
        }
        i++;
    });
   // print(attendanceVoList[index]);
    this.attendanceVoList[index].attendanceStudents.addAll(list);
    saveAttendanceList(context, attendanceVoList);
  }

  bool deleteAttend(AttendanceVo attendance) {
    bool b= this.attendanceVoList.remove(attendance);
    if(b){
      notifyListeners();
    }
    return b;
  }

  Future updateAttendanceStudents(BuildContext context, AttendanceStudents attendanceStudents,int status) async{

    int i=0,index=0;
    this.attendanceVoList.forEach((item){
      if(item.attendanceId.toString()==attendanceStudents.attendanceId){
        index=i;
      }
      i++;
    });
    this.attendanceVoList[index].attendanceStudents.remove(attendanceStudents);
    attendanceStudents.status=status;
    this.attendanceVoList[index].attendanceStudents.add(attendanceStudents);
    saveAttendanceList(context, this.attendanceVoList);
  }
}
