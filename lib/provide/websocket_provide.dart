import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:course_app/data/announcement_vo.dart';
import 'package:course_app/provide/classroom_notif_provide.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/websocket_util.dart';
import 'package:course_app/utils/notifications_util.dart';
import 'package:course_app/utils/websocket_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

///websocket
class WebSocketProvide with ChangeNotifier {
  Websocket websocket;

  ///websockt重连次数
  int _tryCount = 0;

  ///设置重连时间
  num _contimeout = 1;
  dynamic message;

  create({url, String token}) {
    if (websocket == null) {
      websocket = new Websocket();
    }
    websocket.initWebsocket(connectUrl: url, token: '${token}');
    listenMessage();
  }

  listenMessage({Function onError, bool cancelOnError}) {
    //int i = 1;
    websocket.receiveMessage((event) {
      message = event;
      notifyListeners();
      print('websocket 来消息:  ${message}');
      // doMessage(i, body: message);
    }, onDone: () async {
      debugPrint("Socket is closed");
      //TODO  websocket超时重连
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        Future.delayed(Duration(seconds: _contimeout), () async {
          this.close();
          var token = await Application.sp.get('token');
          create(token: token);
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
    }
    NotificationsUtil.show(
        notificationId: id++,
        title: '${websocketMessage.title}',
        content: '${websocketMessage.content}',
        payload: '${payload}',
        groupKey: groupKey,
        onSelectNotificationMy: selectNotificationCallback);
    return websocketMessage;
  }

  void close() {
    print("关闭websocket");
    if (websocket != null) {
      websocket.getWebSocket().sink.close();
      websocket.close();
      websocket = null;
    }
  }
}
