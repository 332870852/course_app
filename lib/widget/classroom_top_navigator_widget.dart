import 'package:course_app/config/constants.dart';
import 'package:course_app/pages/statistics_page.dart';
import 'package:course_app/provide/reply_list_provide.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/router/routes.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/utils/toast_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

///顶部导航
class ClassRoomTopNavigatorWidget extends StatelessWidget {
  final String courseId;
  final String teacherId;
  final int studentNums;

  ClassRoomTopNavigatorWidget(
      {Key key,
      @required this.courseId,
      @required this.teacherId,
      this.studentNums})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 120, left: 20, right: 20, bottom: 5),
      padding: EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                spreadRadius: 1,
                offset: Offset(0, 1)),
          ]),
      height: 200,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),

        ///禁止上下拉动出现波纹
        crossAxisCount: 4,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item,
              backgroundColor: item['backgroundColor']);
        }).toList(),
      ),
    );
  }

  final List navigatorList = [
    {
      'id': 0,
      'image': 0xe63e,
      'itemname': "公告",
      'backgroundColor': Colors.lightBlue
    },
    {
      'id': 1,
      'image': 0xe604,
      'itemname': "资料",
      'backgroundColor': Colors.blueAccent
    },
    {
      'id': 2,
      'image': 0xe6c6,
      'itemname': "话题",
      'backgroundColor': Colors.lightBlueAccent
    },
    {
      'id': 3,
      'image': 0xe602,
      'itemname': "考勤",
      'backgroundColor': Colors.blue.withGreen(100)
    },
    {
      'id': 4,
      'image': 0xe6c4,
      'itemname': "作业",
      'backgroundColor': Colors.lightBlue.shade900
    },
    {
      'id': 5,
      'image': 0xe69d,
      'itemname': "测试",
      'backgroundColor': Colors.green.withOpacity(0.5)
    },
    {
      'id': 6,
      'image': 0xe61e,
      'itemname': "成绩",
      'backgroundColor': Colors.green.withBlue(200)
    },
  ];

  Widget _gridViewItemUI(BuildContext context, item, {Color backgroundColor}) {
    return InkWell(
      onTap: () {
        //TODO 处理公告页
        int type = item['id'];
        switch (type) {
          case 0:
            {
              Provide.value<ReplyListProvide>(context).changDisplay(true);
              Application.router.navigateTo(
                  context,
                  Routes.announcementPage +
                      '?courseId=${courseId}&teacherId=${teacherId}');
              break;
            }
          case 1:
            {
              print('courseId ：${courseId}');
              NavigatorUtil.goDoucumentListPage(context, teacherId, courseId);
              break;
            }
          case 2:
            {
              NavigatorUtil.goTopicPage(context, teacherId, courseId);
              break;
            }
          case 3:
            {
              if (Provide.value<UserProvide>(context).userId == teacherId) {
                ///教师
                NavigatorUtil.goAttendancePage(context,
                    courseId: courseId, studentNums: studentNums);
              } else {
                NavigatorUtil.goAttendanceStuPage(context, courseId);
              }
              break;
            }
          case 4:
            {
              //Fluttertoast.showToast(msg: '功能处于开发阶段..');
              if (Provide.value<UserProvide>(context).userId == teacherId) {
                NavigatorUtil.goClassworkPage(context,
                    courseId: courseId, teacherId: teacherId);
              } else {
                NavigatorUtil.goClassWorkStudentPage(context,
                    courseId: courseId,
                    teacherId: teacherId,
                    userId: Provide.value<UserProvide>(context).userId);
              }
              break;
            }
          case 5:
            {
              NavigatorUtil.goTestPage(context,
                  courseId: courseId, teacherId: teacherId);
              //Fluttertoast.showToast(msg: '功能处于开发阶段..');
              break;
            }
          case 6:
            {
              //Fluttertoast.showToast(msg: '功能处于开发阶段..');
              if (Provide.value<UserProvide>(context).userId == teacherId) {
                ToastWeb.showInfoTip(context, tip: '请使用网页版操作');
              } else {
                ToastWeb.showInfoTip(context, tip: '无权查看');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => StatisticsPage(
                              courseId: courseId,
                              userId:
                                  Provide.value<UserProvide>(context).userId,
                            )));
              }
              break;
            }
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: backgroundColor.withOpacity(0.6),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(1, 5))
            ], shape: BoxShape.circle),
            child: CircleAvatar(
              child: Icon(
                IconData(item['image'], fontFamily: Constants.IconFontFamily),
                size: ScreenUtil.textScaleFactory * 25,
              ),
              foregroundColor: Colors.white,
              backgroundColor: backgroundColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(item['itemname']),
          )
        ],
      ),
    );
  }
}
