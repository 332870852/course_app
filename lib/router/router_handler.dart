

import 'package:course_app/pages/classroom_page.dart';
import 'package:course_app/pages/join_course_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

Handler JoinCourseHanderl =Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    //String goodsId = params['id'].first;
    //print('index>details goodsID is ${goodsId}');
    return JoinCoursePage();
  }
);

Handler classRoomHanderl =Handler(
    handlerFunc: (BuildContext context,Map<String,List<String>> params){
      return ClassRoomPage();
    }
);




