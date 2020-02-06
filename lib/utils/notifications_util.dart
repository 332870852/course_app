import 'package:course_app/router/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///通知工具类
class NotificationsUtil {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin init(
      {SelectNotificationCallback onSelectNotificationMy}) {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    if (onSelectNotificationMy != null) {
      _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotificationMy);
    }
//    else{
//      _flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
//    }
    return _flutterLocalNotificationsPlugin;
  }

  //全局notifi
  static show(
      {@required int notificationId,
      String title,
      String content,
      String payload,
      String groupKey,
      SelectNotificationCallback onSelectNotificationMy}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'gloabel channel id', 'gloabel name', 'gloabelchannel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        groupKey: groupKey);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        NotificationsUtil()
            .init(onSelectNotificationMy: onSelectNotificationMy);
    await flutterLocalNotificationsPlugin.show(
        0, '${title}', '${content}', platformChannelSpecifics,
        payload: '${payload}');
  }

  static cancelAll() async {
    await NotificationsUtil()._flutterLocalNotificationsPlugin.cancelAll();
  }

  static cancel(int id) async {
    await NotificationsUtil()._flutterLocalNotificationsPlugin.cancel(id);
  }

  static FlutterLocalNotificationsPlugin createNewNotif(
      {AndroidInitializationSettings initIconSettingsAndroid,
      SelectNotificationCallback onSelectNotificationMy}) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    if (initIconSettingsAndroid != null) {
      initializationSettingsAndroid = initIconSettingsAndroid;
    }
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    if (onSelectNotificationMy != null) {
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotificationMy);
    }
    return flutterLocalNotificationsPlugin;
  }

  static newShow(FlutterLocalNotificationsPlugin notificationsPlugin,
      {@required int id,
        String groupKey,
      String title,
      String content,
      String payload,
      String channelId="grouped channel id",
      String channelName="grouped channel name",
      String channelDescription="grouped channel description"}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName, channelDescription,
        groupKey: groupKey,
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationsPlugin.show(
        id, '${title}', '${content}', platformChannelSpecifics,
        payload: '${payload}');
  }
}
