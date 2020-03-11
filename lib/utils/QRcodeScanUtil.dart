import 'package:course_app/config/service_url.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/pages/chat/chat_friend_info_page.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/service/user_method.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

class QRCodeScanUtil {
  static void doResult(BuildContext context, int type, dynamic data) async {
    if (type == 1) {
      Course course = Course.fromJson(data);
      Provide.value<CourseProvide>(context).insertCourse(course);
      NavigatorUtil.goClassRoomPage(context, course: course);
    } else if (type == 2) {
      UserInfoVo userInfoVo = UserInfoVo.fromJson(data);
      bool b =
          await UserMethod.IsMyFriend(context, userInfoVo.userId.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatFriendInfoPage(
                    friendInfo: userInfoVo,
                    action: (b) ? 0 : 1,
                  )));
    }
  }
}
