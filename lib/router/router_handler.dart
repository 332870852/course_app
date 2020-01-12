import 'package:course_app/model/Course.dart';
import 'package:course_app/pages/classroom_page.dart';
import 'package:course_app/pages/join_course_page.dart';
import 'package:course_app/pages/teacher/create_course_page.dart';
import 'package:course_app/pages/user_info_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

Handler JoinCourseHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  //String goodsId = params['id'].first;
  //print('index>details goodsID is ${goodsId}');
  return JoinCoursePage();
});

///课堂页
Handler classRoomHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  var studentNums = int.parse(params['studentNums'].first);
  var classtitle = params['classtitle'].first;
  var joinCode = params['joinCode'].first;
  var teacherId = params['teacherId'].first;
  var courseId = params['courseId'].first;
  var courseNumber = params['courseNumber'].first;
  print(studentNums);

  return ClassRoomPage(
    courseId,
    studentNums: studentNums,
    classtitle: classtitle,
    joinCode: joinCode,
    teacherId: teacherId,
    courseNumber: courseNumber,
  );
});

///用户资料页
Handler userInfoHanderl = Handler( handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  //String goodsId = params['id'].first;
  //print('index>details goodsID is ${goodsId}');
  return UserInfoPage();
});

///创建课程页
Handler createCourseHamderl=Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  //String goodsId = params['id'].first;
  //print('index>details goodsID is ${goodsId}');
  return CreateCoursePage();
});
