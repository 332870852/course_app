import 'dart:io';

import 'package:course_app/config/service_url.dart';
import 'package:course_app/service/netty_websocket.dart';
import 'package:course_app/widget/cupertion_alert_dialog.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_event_bus/flutter_event_bus.dart';
class Application{
  static Router router;
  static SharedPreferences sp;
  static GlobalKey<NavigatorState> navigatorKey;
  static GlobalKey key;
  static NettyWebSocket nettyWebSocket;
  static final eventBus = EventBus();
  static initSp() async{
    sp = await SharedPreferences.getInstance();
  }
  static initGlobalKey() async{
    navigatorKey = GlobalKey();
    key= GlobalKey(debugLabel: 'globalkey_app');
  }
  static initNettyWebSocket(){
    //本地设备名称
    String _displayName =
        '${Platform.localeName.substring(0, 2)}+(${Platform.operatingSystem} )';
    nettyWebSocket=NettyWebSocket(serverUrl: nettyUrl,display: _displayName);
  }

  static String uid;
}