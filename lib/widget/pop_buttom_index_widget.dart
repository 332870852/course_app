import 'package:course_app/config/constants.dart';
import 'package:course_app/model/Course.dart';
import 'package:course_app/provide/course_provide.dart';
import 'package:course_app/provide/create_course_provider.dart';
import 'package:course_app/provide/teacher/course_teacher_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

Widget Index_popButtom(context, {List<IndexBuildPopupMenuItem> list}) {
  return PopupMenuButton(
    offset: Offset(2, 100),
    color: Colors.white.withOpacity(0.5),
    itemBuilder: (BuildContext context) {
      return <PopupMenuItem<String>>[
        PopupMenuItem(
          child: IndexBuildPopupMenuItem(
            0xe602,
            "创建课程",
            color: Colors.blueAccent,
            fontFamily: Constants.IconFontFamily2,
          ),
          value: "create_course",
        ),
        PopupMenuItem(
          child:
              IndexBuildPopupMenuItem(0xe62f, "加入课程", color: Colors.blueAccent),
          value: "join_course",
        ),
        PopupMenuItem(
          child:
              IndexBuildPopupMenuItem(0xe606, "课程排序", color: Colors.blueAccent),
          value: "sort_course",
        ),
        PopupMenuItem(
          child:
              IndexBuildPopupMenuItem(0xe60a, "扫一扫", color: Colors.blueAccent),
          value: "saoyisao",
        ),
      ];
    },
    icon: Icon(Icons.add),
    //(Icons.add),
    onSelected: (String selected) {
      switch (selected) {
        case 'join_course':
          {///加课
            Provide.value<CourseProvide>(context).code = Codes.def;
            Application.router.navigateTo(context, Routes.joinCoursePage,
                transition: TransitionType.inFromRight);
            break;
          }
        case 'create_course':
          {//TODO 创建课程
            Provide.value<CreateCourseProvide>(context).InitStatus();///初始化创建页面的控件状态
            Application.router.navigateTo(context, Routes.createCoursePage+'?titlePage=${Uri.encodeComponent('创建课程')}').then((onValue){
              print("Routes.createCoursePage: ${onValue}");
              if(onValue!=null){
                 Course course=onValue;
                 Provide.value<CourseTeacherProvide>(context).addCourse(course);
              }
            });
            break;
          }
        case 'sort_course':
          {
            break;
          }
        case 'saoyisao':
          {
            break;
          }
      }
      print("点击的是$selected");
    },
  );
}

class IndexBuildPopupMenuItem extends StatelessWidget {
  final int iconName;
  final String title;
  final Color color;
  String fontFamily;

  IndexBuildPopupMenuItem(this.iconName, this.title,
      {Key key, this.color, this.fontFamily = Constants.IconFontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          child: Icon(
            IconData(iconName, fontFamily: fontFamily),
            color: color,
            size: ScreenUtil().setSp(40),
          ),
          maxRadius: ScreenUtil().setSp(30),
          backgroundColor: Colors.blue.shade100,
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(title)
      ],
    );
  }
}
