import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'router_handler.dart';


///配置路由
class Routes{
  static String root='/';
  static String joinCoursePage = '/join_course';
  static String classRoomPage='/class_room_Page';
  static String userInfoPage='/user_info_page';
  static void configureRoutes(Router router){
    router.notFoundHandler= new Handler(
        handlerFunc: (BuildContext context,Map<String,List<String>> params){
          print('ERROR====>ROUTE WAS NOT FONUND!!!');

        }
    );
    router.define(joinCoursePage,handler:JoinCourseHanderl);
    router.define(classRoomPage,handler:classRoomHanderl);
    router.define(userInfoPage, handler: userInfoHanderl);
  }

}