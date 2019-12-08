import 'package:course_app/pages/chat_page.dart';
import 'package:course_app/pages/index_page.dart';
import 'package:course_app/pages/member_page.dart';
import 'package:course_app/pages/video_page.dart';
import 'package:course_app/provide/currentIndex_provide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1300)..init(context);

    return Provide<CurrentIndexProvide>(

        builder: (context,child,val){
          //------------关键代码----------start---------
          int currentIndex= Provide.value<CurrentIndexProvide>(context).currentIndex;
          // ----------关键代码-----------end ----------
          return Scaffold(
            backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
            bottomNavigationBar: BottomNavigationBar(
              type:BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              items:bottomTabs,
              onTap: (index){
                //------------关键代码----------start---------
                Provide.value<CurrentIndexProvide>(context).changeIndex(index);
                // ----------关键代码-----------end ----------
              },
            ),
            body: IndexedStack(
                index: currentIndex,
                children: tabBodies
            ),
          );
        }
    );
  }

  final List<Widget> tabBodies = [
    IndexPage(),
    ChatPage(),
    VideoPage(),
    MemberPage(),
  ];

  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
        icon:Icon(Icons.home),
        title:Text('课堂')
    ),
    BottomNavigationBarItem(
        icon:Icon(Icons.chat),
        title:Text('私信')
    ),
    BottomNavigationBarItem(
        icon:Icon(Icons.videocam),
        title:Text('视频')
    ),
    BottomNavigationBarItem(
        icon:Icon(Icons.account_circle),
        title:Text('我的')
    ),
  ];

}
