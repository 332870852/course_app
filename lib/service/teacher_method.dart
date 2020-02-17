import 'package:course_app/config/service_url.dart';
import 'package:course_app/data/announcement_dto.dart';
import 'package:course_app/data/announcement_vo.dart';
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
  static Future<Course> createCourse(BuildContext context,
      {@required CourseDo courseDo}) async {
    print(courseDo);
    ResponseModel responseModel = await post(context,
        method: teacherPath.servicePath['createCourse'],
        data: courseDo.toJson(),
        contentType: ContentType.json);
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        Course course = Course.fromJson(responseModel.data);
        return course;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///教师获取创建的课程
  static Future<ResponseModel> getCoursePage(BuildContext context,
      {@required String userId, num pageNo, num pageSize}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('pageNo', () => pageNo);
    map.putIfAbsent('pageSize', () => pageSize);
    print(userId);
    ResponseModel responseModel = await get(context,
        method: teacherPath.servicePath['getCreateCoursesPage'],
        queryParameters: map);
    print(responseModel);
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

  //TODO test
  ///老师修改课堂
  static Future<Course> updateCourse(BuildContext context,
      {String userId, @required CourseDo courseDo}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    ResponseModel responseModel = await post(context,
        method: teacherPath.servicePath['updateCourse'],
        requestmap: map,
        data: courseDo.toJson());
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        Course course = Course.fromJson(responseModel.data);
        return course;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  //TODO test
  ///删除课程
  static Future<bool> deleteCourse(BuildContext context,
      {String userId, @required String courseId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('courseId', () => courseId);
    ResponseModel responseModel = await post(context,
        method: teacherPath.servicePath['deleteCourse'], requestmap: map);
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return responseModel.data;
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///创建公告
  static Future<AnnouncementVo> createAnnouncement(BuildContext context,
      {String userId, @required AnnouncementDto announcementDto}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    ResponseModel responseModel = await post(context,
        method: teacherPath.servicePath['createAnnouncement'],
        requestmap: map,
        data: announcementDto.toJson());
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return AnnouncementVo.fromJson(responseModel.data);
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///删除公告
  static Future<bool> delAnnouncement(BuildContext context,
      {String userId, @required String announceId}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    map.putIfAbsent('announceId', () => announceId);
    ResponseModel responseModel = await post(
      context,
      method: teacherPath.servicePath['delAnnouncement'],
      requestmap: map,
    );
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return (responseModel.data);
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

  ///修改公告
  static Future<bool> updateAnnouncement(BuildContext context, String userId,
      {@required AnnouncementDto announcementDto}) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('userId', () => userId);
    ResponseModel responseModel = await post(context,
        method: teacherPath.servicePath['updateAnnouncement'],
        requestmap: map,
        data: announcementDto.toJson());
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return (responseModel.data);
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }


  ///获取课堂二维码
  static Future<String> getCourseQRcode(BuildContext context, String courseId,) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('courseId', () => courseId);
    ResponseModel responseModel = await post(context,
        method: teacherPath.servicePath['getCourseQRcode'],
        requestmap: map,);
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
        return (responseModel.data);
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }


  ///获取考勤记录
  static Future<String> getAttendanceList(BuildContext context, String courseId,) async {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('courseId', () => courseId);
    ResponseModel responseModel = await get(context,
      method: teacherPath.servicePath['getAttendanceList'],
      queryParameters: map,);
    print(responseModel);
    if (responseModel != null) {
      if (responseModel.code == 1) {
          List<dynamic>list=responseModel.data;
          list.forEach((item){

          });
      } else {
        throw responseModel.errors[0];
      }
    }
    return null;
  }

}
