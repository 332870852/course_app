import 'package:course_app/pages/home_page.dart';
import 'package:course_app/provide/bottom_tabBar_provide.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/create_course_provider.dart';
import 'package:course_app/provide/currentIndex_provide.dart';
import 'package:course_app/provide/teacher/course_teacher_provide.dart';
import 'package:course_app/provide/reply_list_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
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
  var bottomTabBarProvide = BottomTabBarProvide();
  var courseProvide = CourseProvide();
  var userProvide = UserProvide();
  var createCourseProvide = CreateCourseProvide();
  var courseTeacherProvide = CourseTeacherProvide();
  var replyListProvide = ReplyListProvide();
  providers
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
    ..provide(Provider<BottomTabBarProvide>.value(bottomTabBarProvide))
    ..provide(Provider<UserProvide>.value(userProvide))
    ..provide(Provider<CreateCourseProvide>.value(createCourseProvide))
    ..provide(Provider<CourseTeacherProvide>.value(courseTeacherProvide))
    ..provide(Provider<ReplyListProvide>.value(replyListProvide))
    ..provide(Provider<CourseProvide>.value(courseProvide));
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    String userId = (Provide.value<UserProvide>(context).userId = '123');
    Provide.value<UserProvide>(context).role = 2;
    Provide.value<CourseProvide>(context).student_getCoursePage(userId);
    Provide.value<UserProvide>(context).getUserInfo(userId: userId);

    return Container(
      child: MaterialApp(
        onGenerateRoute: Application.router.generator,
        title: '智慧课堂辅助App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blueAccent),
        home: HomePage(),
      ),
    );
  }
}
