import 'package:course_app/pages/home_page.dart';
import 'package:course_app/pages/join_course_page.dart';
import 'package:course_app/provide/bottom_tabBar_provide.dart';
import 'package:course_app/provide/classroom_notif_provide.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/create_course_provider.dart';
import 'package:course_app/provide/currentIndex_provide.dart';
import 'package:course_app/provide/teacher/course_teacher_provide.dart';
import 'package:course_app/provide/reply_list_provide.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/splash_page.dart';
import 'package:course_app/utils/notifications_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:provide/provide.dart';
import 'package:course_app/config/service_url.dart';

void main() {
  var providers = Providers();
  var currentIndexProvide = CurrentIndexProvide();

  ///控制当前页面
  //var joinCourseProvide = JoinCourseProvide();

  ///
  var userModelProvide = UserModelProvide();
  var bottomTabBarProvide = BottomTabBarProvide();
  var courseProvide = CourseProvide();
  var userProvide = UserProvide();
  var createCourseProvide = CreateCourseProvide();
  var courseTeacherProvide = CourseTeacherProvide();
  var replyListProvide = ReplyListProvide();
  var webSocketProvide = WebSocketProvide();
  var classRoomNotifProvide = ClassRoomNotifProvide();
  providers
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
    ..provide(Provider<BottomTabBarProvide>.value(bottomTabBarProvide))
    ..provide(Provider<UserProvide>.value(userProvide))
    ..provide(Provider<CreateCourseProvide>.value(createCourseProvide))
    ..provide(Provider<CourseTeacherProvide>.value(courseTeacherProvide))
    ..provide(Provider<ReplyListProvide>.value(replyListProvide))
    ..provide(Provider<WebSocketProvide>.value(webSocketProvide))
    ..provide(Provider<ClassRoomNotifProvide>.value(classRoomNotifProvide))
    ..provide(Provider<UserModelProvide>.value(userModelProvide))
    ..provide(Provider<CourseProvide>.value(courseProvide));
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    //_startupJpush();
    Routes.configureRoutes(router);
    Application.router = router;
//    String userId = (Provide.value<UserProvide>(context).userId = '123');
//    Provide.value<UserProvide>(context).role = 2;
    //Provide.value<CourseProvide>(context).student_getCoursePage(userId);
//    Provide.value<UserProvide>(context).getUserInfo(userId: userId);
//    Provide.value<WebSocketProvide>(context).create();
//    Provide.value<WebSocketProvide>(context).create();
    Provide.value<WebSocketProvide>(context).addListener(() {
      Provide.value<WebSocketProvide>(context).doMessage(1,selectNotificationCallback: (p){}).then((onValue) {});
    });

    return Container(
      child: MaterialApp(
        onGenerateRoute: Application.router.generator,
        title: '智慧课堂辅助App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blueAccent),
        home: SplashPage(), // HomePage() SplashPage()
      ),
    );
  }

//  void _startupJpush() async {
//    print("初始化jpush");
//    await FlutterJPush.startup();
//    print("初始化jpush成功");
//    // 获取 registrationID
//    var registrationID =await FlutterJPush.getRegistrationID();
//    print("id :${registrationID}");
//    // 注册接收和打开 Notification()
//    _initNotification();
//  }
//
//  void _initNotification() async {
//    FlutterJPush.addReceiveNotificationListener(
//            (JPushNotification notification) {
//          print("收到推送提醒: ${notification.content}");
//          print("收到推送提醒: ${notification.toString()}");
//        }
//    );
//    FlutterJPush.addReceiveOpenNotificationListener(
//            (JPushNotification notification) {
//          print("打开了推送提醒: $notification");
//          /// 打开了推送提醒
//
//        }
//    );
//  }
}
