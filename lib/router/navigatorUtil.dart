import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/provide/attendance_provide.dart';
import 'package:course_app/provide/attendance_student_provide.dart';
import 'package:course_app/provide/register_page_provide.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/service/student_method.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

class NavigatorUtil {
  static _navigateTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder,
      Function popCallBack}) {
    if (popCallBack != null) {
      Application.router
          .navigateTo(context, path,
              replace: replace,
              clearStack: clearStack,
              transitionDuration: transitionDuration,
              transitionBuilder: transitionBuilder,
              transition: TransitionType.material)
          .then((back) => popCallBack());
    } else {
      Application.router.navigateTo(context, path,
          replace: replace,
          clearStack: clearStack,
          transitionDuration: transitionDuration,
          transitionBuilder: transitionBuilder,
          transition: TransitionType.material);
    }
  }

  /// 首页
  static void goHomePage(BuildContext context) async {
    _navigateTo(context, Routes.homePage, clearStack: true,
        popCallBack: (value) {
      debugPrint("首页退出");
      Provide.value<WebSocketProvide>(context).close();
    });
    print("打开netty websocket");
    Application.nettyWebSocket.connect();
    print("打开websocket");
    var token = await Application.sp.get('token');
    String userId = Provide.value<UserProvide>(context).userId;
    Provide.value<WebSocketProvide>(context).create(userId, token: token);
    //todo
    /////////////////////////////////test
    Application.uid = userId;
    Application.sp.setString('uid', userId);
    ////////////////////////////
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
  static void goAttendanceStuPage(BuildContext context, String courseId) {
    //network
    StudentMethod.findAttendanceStudentScore(context, courseId: courseId)
        .then((onValue) {
      if (onValue != null) {
        Provide.value<AttendStudentProvide>(context).initStatus();
        Provide.value<AttendStudentProvide>(context)
            .saveAttendanceStuList(onValue);
      }
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
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
  static void goAttendancePage(BuildContext context,
      {@required String courseId, num studentNums = 0}) {
    TeacherMethod.getAttendanceList(context, courseId).then((onValue) {
      if (onValue != null) {
        Provide.value<AttendProvide>(context)
            .saveAttendanceList(context, onValue);
      }
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
    _navigateTo(
        context,
        Routes.attendancePagePage +
            '?studentNums=${studentNums}&courseId=${courseId}');
  }

  ///学生签到考勤页
  static void goAttendanceCheckPage(
    BuildContext context, {
    @required int attendanceStudentId,
    @required int type,
    @required String attendanceId,
    String address,
    String time,
  }) {
    _navigateTo(
        context,
        Routes.attendanceCheckPage +
            '?attendanceStudentId=${attendanceStudentId}'
                '&type=${type}&address=${Uri.encodeComponent('${address}')}&time=${time}&attendanceId=${attendanceId}');
  }

  static void goAttendDetailPage(BuildContext context, int index) {
    _navigateTo(context, Routes.attendDetailPage + '?index=${index}');
  }

  //about
  static void goAboutPage(BuildContext context) {
    _navigateTo(context, Routes.aboutPage);
  }

  ///search
  static void goSearchFriendPage(BuildContext context) {
    _navigateTo(context, Routes.searchFriendPage);
  }

  static void goChatHomePage(BuildContext context) {
    _navigateTo(context, Routes.chatHomePage);
  }

  ///预览图片
  static void goImageViewPage(BuildContext context, String urlPath,
      {String isNetUrl = 'false'}) {
    _navigateTo(
        context,
        Routes.imageViewPage +
            '?urlPath=${Uri.encodeComponent('${urlPath}')}&isNetUrl=${isNetUrl}');
  }

  ///观看视频
  static void goVideoViewPage(BuildContext context, String urlPath) {
    _navigateTo(context,
        Routes.videoViewPage + '?urlPath=${Uri.encodeComponent('${urlPath}')}');
  }

//  static void goSoftWarePage(BuildContext context,List list) {
//    _navigateTo(context,
//        Routes.softWarePage+'?list=${list}');
//  }
  ///资料页
  static void goDoucumentListPage(
      BuildContext context, String teacherId, String courseId) {
    _navigateTo(
        context,
        Routes.doucumentListPage +
            '?teacherId=${teacherId}&courseId=${courseId}');
  }

  ///话题页
  static void goTopicPage(
      BuildContext context, String teacherId, String courseId) {
    _navigateTo(context,
        Routes.topicPage + '?teacherId=${teacherId}&courseId=${courseId}');
  }
}
