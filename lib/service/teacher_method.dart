import 'package:course_app/config/service_url.dart';
import 'package:course_app/data/course_do.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/service/service_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class TeacherMethod {
  ///创建课程
  static Future<Course> createCourse(
      {@required CourseDo courseDo}) async {
    print(courseDo);
      Response respData = await post(
          method: teacherPath.servicePath['createCourse'], data:  courseDo.toJson(),contentType: ContentType.json);
      print(respData);
      ResponseModel responseModel = ResponseModel.fromJson(respData.data);
      if(responseModel.code==1){
        Course course=Course.fromJson(responseModel.data);
        return course;
      }else{
         throw responseModel.errors[0];
      }
  }

  ///教师获取创建的课程
  static Future<ResponseModel> getCoursePage(
      {@required String userId, num pageNo, num pageSize}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('pageNo', () => pageNo);
    map.putIfAbsent('pageSize', () => pageSize);
    print(userId);
    Response respData = await get(
        method: teacherPath.servicePath['getCreateCoursesPage'], queryParameters:map);
    print(respData);
    ResponseModel responseModel = ResponseModel.fromJson(respData.data);
    if (responseModel.code == 1) {
      //print(responseModel.data);
      return responseModel;
    } else {
      throw responseModel.errors[0];
    }
  }

  //TODO test
  ///老师修改课堂
  static Future<Course> updateCourse({String userId,@required CourseDo courseDo})async{
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    Response respData = await post(
        method: teacherPath.servicePath['updateCourse'], requestmap:map,data: courseDo.toJson());
    print(respData);
    ResponseModel responseModel = ResponseModel.fromJson(respData.data);
    if (responseModel.code == 1) {
      Course course= Course.fromJson(responseModel.data);
      return course;
    } else {
      throw responseModel.errors[0];
    }
  }

  //TODO test
  ///删除课程
  static Future<bool> deleteCourse({String userId,@required String courseId})async{
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('courseId', () => courseId);
    Response respData = await post(
        method: teacherPath.servicePath['deleteCourse'], requestmap:map);
    print(respData);
    ResponseModel responseModel = ResponseModel.fromJson(respData.data);
    if (responseModel.code == 1) {
      return responseModel.data;
    } else {
      throw responseModel.errors[0];
    }
  }

}
