import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:course_app/provide/attendance_provide.dart';
import 'package:course_app/provide/attendance_student_provide.dart';
import 'package:course_app/provide/bottom_tabBar_provide.dart';
import 'package:course_app/provide/chat/chat_contact_provide.dart';
import 'package:course_app/provide/chat/chat_detail_provide.dart';
import 'package:course_app/provide/chat/chat_message_provide.dart';
import 'package:course_app/provide/chat/chat_page_provide.dart';
import 'package:course_app/provide/classroom_notif_provide.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/create_course_provider.dart';
import 'package:course_app/provide/currentIndex_provide.dart';
import 'package:course_app/provide/doucument_page_provide.dart';
import 'package:course_app/provide/expire_timer_provide.dart';
import 'package:course_app/provide/file_opt_provide.dart';
import 'package:course_app/provide/register_page_provide.dart';
import 'package:course_app/provide/chat/request_friend_provide.dart';
import 'package:course_app/provide/showAttend_provide.dart';
import 'package:course_app/provide/soft_ware_provide.dart';
import 'package:course_app/provide/teacher/attend_stu_provide.dart';
import 'package:course_app/provide/teacher/course_teacher_provide.dart';
import 'package:course_app/provide/reply_list_provide.dart';
import 'package:course_app/provide/user_model_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/service/chat_service.dart';
import 'package:course_app/splash_page.dart';
import 'package:course_app/utils/notifications_util.dart';
import 'package:course_app/utils/permission_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:course_app/provide/topic_provide.dart';

void main() async {
  ///高德地图插件
  WidgetsFlutterBinding.ensureInitialized();
  await AmapCore.init('21f35eb097c0cd048f7668194525ba7a');

  ///状态管理
  var providers = Providers();
  var currentIndexProvide = CurrentIndexProvide();

  ///控制当前页面
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
  var registeProvide = RegisteProvide();
  var attendProvide = AttendProvide();
  var expireTimerProvide = ExpireTimerProvide();
  var showAttendProvide = ShowAttendProvide();
  var attendStudentProvide = AttendStudentProvide();
  var attendStuProvide = AttendStuProvide();
  var chatContactProvide = ChatContactProvide();
  var requestFriendProvide = RequestFriendProvide();
  var chatPageProvide = ChatPageProvide();
  var chatMessageProvide = ChatMessageProvide();
  var chatDetailProvide = ChatDetailProvide();
  var softWareProvide = SoftWareProvide();
  var doucumentPageProvide = DoucumentPageProvide();
  var fileOptProvide = FileOptProvide();
  var topicProvide = TopicProvide();

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
    ..provide(Provider<RegisteProvide>.value(registeProvide))
    ..provide(Provider<AttendProvide>.value(attendProvide))
    ..provide(Provider<ExpireTimerProvide>.value(expireTimerProvide))
    ..provide(Provider<ShowAttendProvide>.value(showAttendProvide))
    ..provide(Provider<AttendStudentProvide>.value(attendStudentProvide))
    ..provide(Provider<AttendStuProvide>.value(attendStuProvide))
    ..provide(Provider<ChatContactProvide>.value(chatContactProvide))
    ..provide(Provider<RequestFriendProvide>.value(requestFriendProvide))
    ..provide(Provider<ChatPageProvide>.value(chatPageProvide))
    ..provide(Provider<ChatMessageProvide>.value(chatMessageProvide))
    ..provide(Provider<ChatDetailProvide>.value(chatDetailProvide))
    ..provide(Provider<SoftWareProvide>.value(softWareProvide))
    ..provide(Provider<DoucumentPageProvide>.value(doucumentPageProvide))
    ..provide(Provider<FileOptProvide>.value(fileOptProvide))
    ..provide(Provider<CourseProvide>.value(courseProvide))
    ..provide(Provider<TopicProvide>.value(topicProvide));
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Application.initGlobalKey();
    Application.initNettyWebSocket();
    final router = Router();
    //_startupJpush();
    Routes.configureRoutes(router);
    Application.router = router;

    //do chat message
    ChatService.doReceiveNotf(context);
    //切换网络重连netty
    Application.nettyWebSocket.reConnect();
    //todo clear cache gif
    //VideoCompressUtil.clearCacheGif();

    Provide.value<WebSocketProvide>(context).addListener(() {
      print("websocket-----------");
      Provide.value<WebSocketProvide>(context).listenMessage();
    });

    return Container(
      child: MaterialApp(
        navigatorKey: Application.navigatorKey,
        key: Application.key,
//        navigatorObservers: [CustomNavigatorObserver.getInstance()],
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
