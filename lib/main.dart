import 'package:course_app/pages/home_page.dart';
import 'package:course_app/provide/bottom_tabBar_provide.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/currentIndex_provide.dart';
import 'package:course_app/provide/joincourse_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

void main() {
  var providers = Providers();
  var currentIndexProvide = CurrentIndexProvide();

  ///控制当前页面
  //var joinCourseProvide = JoinCourseProvide();

  ///
  var bottomTabBarProvide = BottomTabBarProvide();
  var courseProvide = CourseProvide();
  providers
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
    //..provide(Provider<JoinCourseProvide>.value(joinCourseProvide))
    ..provide(Provider<BottomTabBarProvide>.value(bottomTabBarProvide))
    ..provide(Provider<CourseProvide>.value(courseProvide));

  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    Provide.value<CourseProvide>(context).student_getCoursePage('2');

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