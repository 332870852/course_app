import 'package:course_app/model/Course.dart';
import 'package:course_app/pages/announcement_content_page.dart';
import 'package:course_app/pages/announcement_page.dart';
import 'package:course_app/pages/classroom_page.dart';
import 'package:course_app/pages/join_course_page.dart';
import 'package:course_app/pages/teacher/create_announce_page.dart';
import 'package:course_app/pages/teacher/create_course_page.dart';
import 'package:course_app/pages/user_info_page.dart';
import 'package:course_app/provide/reply_list_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/service/user_method.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

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
Handler userInfoHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  //String goodsId = params['id'].first;
  //print('index>details goodsID is ${goodsId}');
  return UserInfoPage();
});

///创建课程页
Handler createCourseHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  //String goodsId = params['id'].first;
  //print('index>details goodsID is ${goodsId}');
  var titlePage = params['titlePage'].first;
  //print("***********************${titlePage}");
  return CreateCoursePage(titlePage: titlePage.toString());
});

///公告页
Handler announcementHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  var courseId = (params['courseId'] != null) ? params['courseId'].first : '';
  var teacherId=(params['teacherId'] != null) ? params['teacherId'].first : '';
  ///dio
  UserMethod.getAnnouncementPage(
          userId: Provide.value<UserProvide>(context).userId,
          courseId: courseId)
      .then((value) {
    if (value != null) {
      print("saveAnnouncement : ${value}");
      Provide.value<ReplyListProvide>(context).saveAnnouncement(value);
    }
  });
  return AnnouncementPage(
    courseId: courseId,
    teacherId: teacherId,
  );
});

///公告详情页
Handler announcementContentHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  var announceId =
      (params['announceId'] != null) ? params['announceId'].first : '';
  var announceTitle = params['announceTitle'].first;
  var announceText = params['announceText'].first;
  var username = (params['username'] != null) ? params['username'].first : '';
  var annex =
      (params['annex'] != null && params['annex'].first.contains('http'))
          ? params['annex'].first
          : '';
  num readedNum =
      (params['readedNum'] != null && params['readedNum'].toString() != 'null')
          ? num.parse(params['readedNum'].first)
          : 0;
  num commentNum = (params['commentNum'] != null)
      ? num.parse(params['commentNum'].first)
      : 0;
  var date = (params['date'] != null) ? (params['date'].first) : '';
  return AnnouncementContentPage(
    announceId: announceId,
    announceTitle: announceTitle,
    username: username,
    announceText: announceText,
    annex: annex,
    readedNum: readedNum,
    commentNum: commentNum,
    date: date,
  );
});

///发布公告
Handler createAnnounceHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  var courseId = (params['courseId'] != null) ? params['courseId'].first : '';
  var pageTitle =
      (params['pageTitle'] != null) ? params['pageTitle'].first : '创建公告';
  bool isCreatePage = (params['isCreatePage'] != null)
      ? bool.fromEnvironment(params['isCreatePage'].first)
      : true;
  var announceTitle =
      (params['announceTitle'] != null) ? params['announceTitle'].first : '';
  var announceBody =
      (params['announceBody'] != null) ? params['announceBody'].first : '';
  var announceId =
      (params['announceId'] != null) ? params['announceId'].first : '';
  var fujian=(params['fujian']!=null)?params['fujian'].first:null;
  return CreateAnnouncePage(
    courseId: courseId,
    pageTitle: pageTitle,
    isCreatePage: isCreatePage,
    title: announceTitle,
    contextBody: announceBody,
    announceId: announceId,
    fujian: fujian,
  );
});
