import 'package:course_app/provide/bottom_tabBar_provide.dart';
import 'package:course_app/widget/bottomTabBar_widget.dart';
import 'package:course_app/widget/class_room_title_widget.dart';
import 'package:course_app/widget/classroom_top_navigator_widget.dart';
import 'package:course_app/widget/teacher_image_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

///课堂主界面

class ClassRoomPage extends StatefulWidget {
  final String id;

  ClassRoomPage({Key key, this.id}) : super(key: key);

  @override
  _ClassRoomPageState createState() => _ClassRoomPageState();
}

class _ClassRoomPageState extends State<ClassRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        body: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(45)),
                  child: Container(
                    height: ScreenUtil().setHeight(420),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withGreen(222),
                            Theme.of(context).primaryColor.withOpacity(0.50),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                  //Image.asset("assets/bg_swiper.png")
                ), // Image.asset("assets/brg/head.jpg")
              ],
            ),
            Positioned(
              child: TeacherImageInfoWidget(
                  url:
                      'http://pic31.nipic.com/20130730/789607_232633343194_2.jpg',
                  teacherName: '李建刚'),
              top: 40,
              right: 10,
            ),
            ClassRoomTitleWidget(),
//            SingleChildScrollView(
//              child: Column(
//                children: <Widget>[
//                  ClassRoomTitleWidget(),
//                ],
//              ),
//            ),
            ClassRoomTopNavigatorWidget(),
//            Column(
//              children: <Widget>[
//                ClassRoomTopNavigatorWidget(),
//              ],
//            ),
            BottomTabBarWidget(),

          ],
        ));
  }
}
