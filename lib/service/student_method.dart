import 'package:course_app/config/service_url.dart';
import 'package:course_app/data/Attendance_student_dto.dart';
import 'package:course_app/data/Attendance_student_vo.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/service/service_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class StudentMethod {
  ///获取课程
  static Future<ResponseModel> getCoursePage(BuildContext context,
      {@required String userId, num pageNo, num pageSize}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('pageNo', () => pageNo);
    map.putIfAbsent('pageSize', () => pageSize);
    ResponseModel responseModel = await get(context,
        method: studentPath.servicePath['getCoursePage'], queryParameters: map);
    // print(respData.data);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        //print(responseModel.data);
        return responseModel;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///加课
  static Future<ResponseModel> JoinCode(
      BuildContext context, String userId, String joinCode) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('joinCode', () => joinCode);
    ResponseModel responseModel = await post(context,
        method: studentPath.servicePath['joinCourse'], requestmap: map);
    if (responseModel != null) {
      if (responseModel.code != 0) {
        return responseModel;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
//    try{
//      ResponseModel responseModel = ResponseModel.fromJson(respData.data);
//      if (responseModel.code != 0) {
//        return responseModel;
//      } else {
//        throw responseModel.errors[0];
//      }
//    }catch (e){
//      print("1111111111${e}");
//    }
  }

  ///学生退课
  static Future<bool> removeCourse(BuildContext context,
      {@required String userId, @required String courseId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('courseId', () => courseId);
    try {
      ResponseModel responseModel = await post(
        context,
        method: studentPath.servicePath['removeCourse'],
        requestmap: map,
      );
      if (responseModel != null) {
        if (responseModel.code == 1) {
          print(responseModel.data);
          return responseModel.data;
        } else {
          throw responseModel.errors[0];
        }
      }
    } catch (e) {
      print("removeCourse 系统错误");
    }
    return false;
  }

  ///考勤
  static Future<List<AttendanceStudents>> findAttendanceStudentScore(
      BuildContext context,
      {@required String courseId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('courseId', () => courseId);
    try {
      ResponseModel responseModel = await post(
        context,
        method: studentPath.servicePath['findAttendanceStudentScore'],
        requestmap: map,
      );
      if (responseModel != null) {
        if (responseModel.code == 1) {
          List<dynamic> list = responseModel.data;
          List<AttendanceStudents> temp = [];
          list.forEach((item) {
            AttendanceStudents attendanceStudentVo =
                AttendanceStudents.fromJson(item);
            temp.add(attendanceStudentVo);
          });
          return temp;
        } else {
          throw responseModel.errors[0];
        }
      }
    } catch (e) {
      print("findAttendanceStudentScore 系统错误");
    }
    return null;
  }

  ///考勤
  static Future<int> AttendanceStudentCheck(BuildContext context,
      {@required AttendanceStudentDto attendanceStudentDto}) async {
    print(attendanceStudentDto);
    ResponseModel responseModel = await post(
      context,
      method: studentPath.servicePath['AttendanceStudentCheck'],
      data: attendanceStudentDto.toJson(),
    );
    if (responseModel != null) {
      if (responseModel.code == 1) {
        //print(responseModel.data);
        return responseModel.data;
      } else {
        throw responseModel.errors[0];
      }
    }
    return -1;
  }

}
