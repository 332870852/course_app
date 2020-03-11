import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/data/announcement_vo.dart';
import 'package:course_app/data/user_model_vo.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/service/websocket_util.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/utils/notifications_util.dart';
import 'package:course_app/utils/websocket_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

///websocket
class WebSocketProvide with ChangeNotifier {
  Websocket websocket;
  num _id = 0;

  ///websockt重连次数
  int _tryCount = 0;

  ///设置重连时间
  num _contimeout = 1;
  dynamic message;

  Websocket create(String userId, {url, String token}) {
    if (websocket == null) {
      websocket = new Websocket();
    }
    websocket.initWebsocket(userId, connectUrl: url, token: '${token}');
    listenMessage();
    return websocket;
  }

  listenMessage({Function onError, bool cancelOnError}) {
    print('listen');
    websocket.receiveMessage((event) {
      message = event;
      // notifyListeners();
      print('websocket 来消息:  ${message}');
      doMessage(
        _id++,
      );
    }, onDone: () async {
      debugPrint("Socket is closed");
      //TODO  websocket超时重连
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        Future.delayed(Duration(seconds: _contimeout), () async {
          this.close();
          var token = await Application.sp.get('token');
          UserModel userModel =
              UserModel.fromJson(json.decode(await Application.sp.get('user')));
          create(userModel.userVo.userId.toString(), token: token);
          //listenMessage();
          print("aaa ${_tryCount}   ${_contimeout}");
          if (_tryCount < 6) {
            _contimeout *= 3;
          } else {
            _contimeout = 1;
          }
          _tryCount++;
        });
      }
    }, onError: onError, cancelOnError: cancelOnError);
  }

  sendMessage(message) {
    if (websocket != null) {
      websocket.sendMessage(message);
    }
  }

  Future<WebsocketMessage> doMessage(int id,
      {String payload,
      String groupKey,
      SelectNotificationCallback selectNotificationCallback}) async {
    WebsocketMessage websocketMessage =
        WebsocketMessage.fromJson(json.decode(message));
    if (websocketMessage.method == "createAnnouncement") {
      AnnouncementVo announcementVo =
          AnnouncementVo.fromJson(json.decode(websocketMessage.messageBody));
      websocketMessage.content = announcementVo.announceTitle;
      Application.eventBus.publish(announcementVo);
    } else if (websocketMessage.method == "teacher/createAttendance") {
    } else if (websocketMessage.method == "teacher/createAttendance/delayed") {
      List<dynamic> list = json.decode(websocketMessage.messageBody);
      List<AttendanceStudents> temp = [];
      list.forEach((item) {
        AttendanceStudents attendanceStudents =
            AttendanceStudents.fromJson(item);
        attendanceStudents.time = DateTime.fromMillisecondsSinceEpoch(
                int.parse(attendanceStudents.time))
            .toString();
        temp.add(attendanceStudents);
      });
      Application.eventBus.publish(temp);
    } else if (websocketMessage.code == 4) {
      AttendanceStudents attendanceStudents = AttendanceStudents.fromJson(
          json.decode(websocketMessage.messageBody));
      attendanceStudents.time = DateTime.fromMillisecondsSinceEpoch(
              int.parse(attendanceStudents.time))
          .toString();
      Application.eventBus.publish(attendanceStudents);
    }

    NotificationsUtil.show(
        notificationId: id++,
        title: '${websocketMessage.title}',
        content: '${websocketMessage.content}',
        payload: '${websocketMessage.method}',
        groupKey: groupKey,
        onSelectNotificationMy: (p) async {
          if (p == "teacher/createAttendance") {
            //Application.navigatorKey.currentState.pushReplacement(MaterialPageRoute(builder: (context)=>AttendanceStuPage()));

          } else if (p == "teacher/createAttendance/delayed") {}
        }); // selectNotificationCallback
    return websocketMessage;
  }
//            Future.delayed(Duration(seconds: 1), () {
//              NavigatorUtil.goAttendancePage(
//                  Application.navigatorKey.currentState.context,
//                  courseId: '10',
//                  studentNums: 5);
//            });
  void close() {
    print("关闭websocket");
    if (websocket != null) {
      websocket.getWebSocket().sink.close();
      websocket.close();
      websocket = null;
    }
  }
}
