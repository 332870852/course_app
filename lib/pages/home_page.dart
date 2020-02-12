import 'package:course_app/pages/chat_page.dart';
import 'package:course_app/pages/index_page.dart';
import 'package:course_app/pages/member_page.dart';
import 'package:course_app/pages/video_page.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/currentIndex_provide.dart';
import 'package:course_app/provide/websocket_provide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class HomePage extends StatelessWidget {
//
  Future<bool> _popCallback() async{
    AndroidBackTop.backDeskTop(); //设置为返回不退出app
    return false;
  }

  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1300)..init(context);

    ///loading course
    return WillPopScope(
        child: Provide<CurrentIndexProvide>(builder: (context, child, val) {
          //------------关键代码----------start---------
          int currentIndex =
              Provide.value<CurrentIndexProvide>(context).currentIndex;
          // ----------关键代码-----------end ----------
          return Scaffold(
            backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              items: bottomTabs,
              onTap: (index) {
                //------------关键代码----------start---------
                Provide.value<CurrentIndexProvide>(context).changeIndex(index);
                // ----------关键代码-----------end ----------
              },
            ),
            body: IndexedStack(index: currentIndex, children: tabBodies),
          );
        }),
      onWillPop: _popCallback,);
  }

  final List<Widget> tabBodies = [
    IndexPage(),
    ChatPage(),
    VideoPage(),
    MemberPage(),
  ];

  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('课堂')),
    BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('私信')),
    BottomNavigationBarItem(icon: Icon(Icons.videocam), title: Text('视频')),
    BottomNavigationBarItem(
        icon: Icon(Icons.account_circle), title: Text('我的')),
  ];
}

class AndroidBackTop {
  //初始化通信管道-设置退出到手机桌面
  static const String CHANNEL = "android/back/desktop";
  //设置回退到手机桌面
  static Future<bool> backDeskTop() async {
    final platform = MethodChannel(CHANNEL);
    //通知安卓返回,到手机桌面
    try {
      final bool out = await platform.invokeMethod('backDesktop');
      if (out) debugPrint('返回到桌面');
    } on PlatformException catch (e) {
      debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
      print(e.toString());
    }
    return Future.value(false);
  }

}
