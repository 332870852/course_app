import 'package:course_app/config/service_url.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/service/service_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class StudentMethod {
  ///获取课程
  static Future<ResponseModel> getCoursePage(
      {@required String userId, num pageNo, num pageSize}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('pageNo', () => pageNo);
    map.putIfAbsent('pageSize', () => pageSize);
    Response respData = await get(
        method: studentPath.servicePath['getCoursePage'], queryParameters: map);
    // print(respData.data);
    ResponseModel responseModel = ResponseModel.fromJson(respData.data);
    if (responseModel.code == 1) {
      //print(responseModel.data);
      return responseModel;
    } else {
      throw responseModel.errors[0];
    }
  }

  ///加课
  static Future<ResponseModel> JoinCode(String userId, String joinCode) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('joinCode', () => joinCode);
    Response respData = await post(
        method: studentPath.servicePath['joinCourse'], requestmap: map);
    ResponseModel responseModel = ResponseModel.fromJson(respData.data);
    if (responseModel.code != 0) {
      return responseModel;
    } else {
      throw responseModel.errors[0];
    }
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
  static Future<bool> removeCourse(
      {@required String userId, @required String courseId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('courseId', () => courseId);
    try {
      Response respData = await post(
        method: studentPath.servicePath['removeCourse'],
        requestmap: map,
      );
      ResponseModel responseModel = ResponseModel.fromJson(respData.data);
      if (responseModel.code == 1) {
        print(responseModel.data);
        return responseModel.data;
      } else {
        throw responseModel.errors[0];
      }
    } catch (e) {
      print("removeCourse 系统错误");
    }
    return false;
  }
}
