import 'dart:convert';

import 'package:course_app/data/Attendance_student_vo.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/router/application.dart';
import 'package:flutter/material.dart';

class AttendStudentProvide with ChangeNotifier {
  List<AttendanceStudents> attendanceStuList = [];
  int absfrequency = 0;
  int latfrequency = 0;
  int leafrequency = 0;
  int attfrequency = 0;
  int takfrequency = 0;

  void initStatus() {
    this.absfrequency = 0;
    this.latfrequency = 0;
    this.leafrequency = 0;
    this.attfrequency = 0;
    this.takfrequency = 0;
    notifyListeners();
  }

  void saveAttendanceStuList(List<AttendanceStudents> list) {
    this.attendanceStuList = list;
    List<String> tempStr = [];
    list.forEach((item) {
      String str = json.encode(item);
      tempStr.add(str);
    });
    Application.sp.setStringList('AttendanceStudentVoList', tempStr);
    notifyListeners();
    //getAttendanceList();
  }

  Future<List<AttendanceStudents>> getAttendanceStuList() async {
    print(" getAttendanceStuList");
    List<String> tempStr =
        Application.sp.getStringList('AttendanceStudentVoList');
    List<AttendanceStudents> list = [];
    tempStr.forEach((item) {
      AttendanceStudents attendanceStudentVo =
          AttendanceStudents.fromJson(json.decode(item));
      list.add(attendanceStudentVo);
      if (attendanceStudentVo.status == 0) {
        this.absfrequency++;
      } else if (attendanceStudentVo.status == 1) {
        this.latfrequency++;
      } else if (attendanceStudentVo.status == 2) {
        this.leafrequency++;
      } else if (attendanceStudentVo.status == 3) {
        this.attfrequency++;
      } else if (attendanceStudentVo.status == 4) {
        this.takfrequency++;
      }
    });
    this.attendanceStuList = list;
    return list;
  }

  void updateStatus(int attendanceStudentId, int status) {
    int i = 0, index = 0;
    this.attendanceStuList.forEach((item) {
      if (attendanceStudentId == item.attendanceStudentId) {
        index = i;
      }
      i++;
    });
    this.attendanceStuList[index].status = status;
    saveAttendanceStuList(this.attendanceStuList);
  }

  //////////teracher//////
  Map<int, List<AttendanceStudents>> mapAtt = Map();
  void saveMapAtt(Map<int, List<AttendanceStudents>> m) {
    mapAtt = m;
    notifyListeners();
  }
}
