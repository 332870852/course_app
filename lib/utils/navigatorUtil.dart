import 'package:course_app/model/Course.dart';
import 'package:course_app/provide/register_page_provide.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:provide/provide.dart';

class NavigatorUtil {
  static _navigateTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder,
      Function popCallBack}) {
    Application.router
        .navigateTo(context, path,
            replace: replace,
            clearStack: clearStack,
            transitionDuration: transitionDuration,
            transitionBuilder: transitionBuilder,
            transition: TransitionType.material)
        .then((back) => popCallBack());
  }

  /// 首页
  static void goHomePage(BuildContext context) async {
    _navigateTo(context, Routes.homePage, clearStack: true,
        popCallBack: (value) {
      Provide.value<WebSocketProvide>(context).close();
    });
    print("打开websocket");
    var token = await Application.sp.get('token');
    Provide.value<WebSocketProvide>(context).create(token: token);
  }

  ///登录页
  static void goLoginPage(BuildContext context,
      {String username = '', String pwd = ''}) {
    _navigateTo(
      context,
      Routes.loginPage +
          '?username=${Uri.encodeComponent('$username')}&pwd=${pwd}',
      clearStack: true,
    );
  }

  ///注册页
  static void goRegisterPage(BuildContext context) {
    ///初始化页面参数
    Provide.value<RegisteProvide>(context).init();
    _navigateTo(
      context,
      Routes.registerUserPage,
    );
  }

  ///注册页2
  static void goNextRegisterPage(BuildContext context) {
    _navigateTo(context, Routes.nextRegistPage);
  }

  ///注册页3
  static void goFinalRegisterPage(BuildContext context) {
    _navigateTo(context, Routes.finalRegistePage);
  }

  ///注册页结果
  static void goResultRegisterPage(BuildContext context,
      {bool isSuccess, String username}) {
    print('sss  ${isSuccess} ${username}');
    _navigateTo(
        context,
        Routes.resultRegistPage +
            '?isSuccess=${isSuccess}&'
                'username=${Uri.encodeComponent('${username}')}',
        popCallBack: () {
      goLoginPage(context, username: username);
    });
  }

  ///账号安全
  static void goAdminAccoutPage(BuildContext context) {
    _navigateTo(context, Routes.adminAccoutPage);
  }

  ///密码设置页
  static void goPwdChangePgae(BuildContext context,
      {@required String username}) {
    _navigateTo(
        context,
        Routes.pwdChangePgae +
            '?username=${Uri.encodeComponent('${username}')}');
  }

  ///学生考勤页面
  static void goAttendanceStuPage(BuildContext context) {
    _navigateTo(context, Routes.attendanceStuPage);
  }

  ///classroom页面
  static void goClassRoomPage(BuildContext context, {@required Course course}) {
    _navigateTo(
        context,
        Routes.classRoomPage +
            '?' +
            'studentNums=${course.member}'
                '&classtitle=${Uri.encodeComponent(course.title)}'
                '&courseNumber=${course.courseNumber}'
                '&joinCode=${course.joincode}'
                '&teacherId=${course.teacherId}'
                '&courseId=${course.courseId}&cid=${Uri.encodeComponent(course.cid)}');
  }

  ///教师考勤管理页面
  static void goAttendancePage(BuildContext context) {
    _navigateTo(context, Routes.attendancePagePage);
  }
}
