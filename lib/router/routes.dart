import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'router_handler.dart';

///配置路由
class Routes {
  static String root = '/';
  static String loginPage = '/user_login_page';
  static String joinCoursePage = '/join_course_page';
  static String classRoomPage = '/class_room_page';
  static String userInfoPage = '/user_info_page';
  static String createCoursePage = '/create_course_page';
  static String announcementPage = '/ announcement_page';
  static String announcementContentPage = '/announcement_content_page';
  static String createAnnouncePage = '/create_announce_page';
  static String qrcodePage = 'qrcode_page';
  static String homePage = '/home_page';
  static String registerUserPage = '/registerUser_page';
  static String nextRegistPage = '/nextRegist_page';
  static String finalRegistePage = '/final_registe_page';
  static String resultRegistPage = '/result_regist_page';
  static String adminAccoutPage = '/admin_accout_page';
  static String pwdChangePgae = '/pwd_change_page';
  static String attendanceStuPage = '/attendanceStu_page';
  static String attendancePagePage = '/attendance_page';
  static String attendanceCheckPage = '/attendance_check_page';
  static String attendDetailPage = '/attend_detail_page';
  static String aboutPage = '/about_page';
  static String searchFriendPage = '/search_friend_page';
  static String chatHomePage = 'chat_home_page';
  static String imageViewPage = '/image_view_page';
  static String videoViewPage = '/video_view_page';

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('ERROR====>ROUTE WAS NOT FONUND!!!');
    });
    router.define(homePage, handler: homeHanderl);
    router.define(loginPage, handler: loginHanderl);
    router.define(joinCoursePage, handler: JoinCourseHanderl);
    router.define(classRoomPage, handler: classRoomHanderl);
    router.define(userInfoPage, handler: userInfoHanderl);
    router.define(createCoursePage, handler: createCourseHanderl);
    router.define(announcementPage, handler: announcementHanderl);
    router.define(announcementContentPage, handler: announcementContentHanderl);
    router.define(createAnnouncePage, handler: createAnnounceHanderl);
    router.define(qrcodePage, handler: qrcodeHanderl);
    router.define(registerUserPage, handler: registerUserHanderl);
    router.define(nextRegistPage, handler: nextRegistPageHanderl);
    router.define(finalRegistePage, handler: finalRegisteHanderl);
    router.define(resultRegistPage, handler: ResultRegistHanderl);
    router.define(adminAccoutPage, handler: adminAccoutHanderl);
    router.define(pwdChangePgae, handler: pwdChangeHanderl);
    router.define(attendanceStuPage, handler: attendanceStuHanderl);
    router.define(attendancePagePage, handler: attendancePageHanderl);
    router.define(attendanceCheckPage, handler: attendanceCheckHanderl);
    router.define(attendDetailPage, handler: attendDetailHanderl);
    router.define(aboutPage, handler: aboutHanderl);
    router.define(searchFriendPage, handler: searchFriendHanderl);
    router.define(chatHomePage, handler: chatHomeHanderl);
    router.define(imageViewPage, handler: imageViewHanderl);
    router.define(videoViewPage, handler: videoViewHanderl);
  }
}
