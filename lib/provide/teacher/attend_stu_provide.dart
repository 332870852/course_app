import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/data/user_info.dart';
import 'package:flutter/material.dart';

class AttendStuProvide with ChangeNotifier {
  Map<int, List<AttendanceStudents>> map = Map();
  List<UserInfoVo> userList=[];
  AttendStuProvide() {
    debugPrint("init AttendStuProvide");
    this.map.putIfAbsent(0, () => []);
    this.map.putIfAbsent(1, () => []);
    this.map.putIfAbsent(2, () => []);
    this.map.putIfAbsent(3, () => []);
    this.map.putIfAbsent(4, () => []);
  }

  initMap(){
    this.map.forEach((key,value){
        map[key].clear();
    });
    userList.clear();
  }

  void insertAttendanceStudents(context, List<AttendanceStudents> list) {
    debugPrint("insertAttendanceStudents");
    if (ObjectUtil.isNotEmpty(list)) {
       list.forEach((item){
          this.map[item.status].add(item);
       });
       notifyListeners();
    }
  }

  void saveItemList(List<UserInfoVo> onValue) {
    userList=onValue;
    //notifyListeners();
  }
}
