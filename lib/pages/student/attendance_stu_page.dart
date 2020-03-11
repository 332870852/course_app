import 'package:course_app/config/constants.dart';
import 'package:course_app/data/Attendance_student_vo.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/provide/attendance_student_provide.dart';
import 'package:course_app/provide/showAttend_provide.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter/cupertino.dart';

///学生考勤页面
class AttendanceStuPage extends StatefulWidget {
  AttendanceStuPage({Key key}) : super(key: key);

  @override
  _AttendanceStuPageState createState() => _AttendanceStuPageState();
}

class _AttendanceStuPageState extends State<AttendanceStuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('考勤'),
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Provide<AttendStudentProvide>(
        builder: (context, child, data) {
          return FutureBuilder(
            future: Provide.value<AttendStudentProvide>(context)
                .getAttendanceStuList(),
            builder: (context, sna) {
              if (sna.connectionState == ConnectionState.waiting) {
                return CupertinoActivityIndicator();
              }
              if (sna.hasData) {
                List<AttendanceStudents> attendanceStuList = sna.data;
                return Container(
                  width: ScreenUtil.screenWidth,
                  height: ScreenUtil.screenHeight,
                  child: Column(
                    children: <Widget>[
                      diplayAccount(
                          chuqin: data.absfrequency,
                          chidao: data.latfrequency,
                          zaotui: data.leafrequency,
                          kuangke: data.attfrequency,
                          qingjia: data.takfrequency),
                      (attendanceStuList.isNotEmpty)
                          ? Flexible(
                              child: myListRecord(attendanceStuList),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset('assets/img/nodata2.png'),
                                  Text(
                                    '暂无数据',
                                    style:
                                        TextStyle(color: Colors.blue.shade200),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text('暂无数据'),
                );
              }
            },
          );
        },
      ),
    );
  }

  ///记录列表
  Widget myListRecord(List<AttendanceStudents> list) {
    return ListView.builder(
        itemCount: list.length, //list.length,
        itemBuilder: (context, index) {
          return everyItem(data: list[index]);
        });
  }

  Widget everyItem({@required AttendanceStudents data}) {
    //assert(ktype>-1&&ktype<2);
    //assert(status>-1&&status<6);
    var time = data.time;
    var status = data.status;
    String dateTitle = time.substring(0, 11);
    String dateSub = time.substring(10, time.length);
    String tip = (data.type == 1) ? 'gps考勤' : '数字考勤';
    String statusMsg = '';
    Color color = Colors.green;
    if (status == 0) {
      statusMsg = '出勤';
    } else if (status == 1) {
      statusMsg = '迟到';
      color = Colors.orangeAccent;
    } else if (status == 2) {
      statusMsg = '早退';
      color = Colors.orangeAccent;
    } else if (status == 3) {
      statusMsg = '旷课';
      color = Colors.red;
    } else if (status == 4) {
      statusMsg = '请假';
    }
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color(Constants.DividerColor),
                  width: Constants.DividerWith))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('${dateTitle}'),
              Text(
                '${dateSub} ${tip}',
                style: TextStyle(color: Colors.black26),
              ),
            ],
          ),
          (status == -1)
              ? FlatButton(
                  onPressed: () {
                    //todo
                    Provide.value<ShowAttendProvide>(context).initStatus();
                    NavigatorUtil.goAttendanceCheckPage(context,
                        attendanceStudentId: data.attendanceStudentId,
                        attendanceId: data.attendanceId,
                        type: data.type,address: data.address,time: time);
                  },
                  child: Text('考勤签到'),
                  color: Colors.green,
                  textColor: Colors.white,
                )
              : Text(
                  '${statusMsg}',
                  style: TextStyle(color: color),
                ),
        ],
      ),
    );
  }

  ///数据统计
  Widget diplayAccount(
      {@required int chuqin,
      @required int chidao,
      @required int zaotui,
      @required int kuangke,
      @required int qingjia}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      height: 100,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color(Constants.DividerColor),
                  width: Constants.DividerWith))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          DataItem(label: '出勤', color: Colors.green, data: chuqin),
          DataItem(label: '迟到', color: Colors.orangeAccent, data: chidao),
          DataItem(label: '早退', color: Colors.orangeAccent, data: zaotui),
          DataItem(label: '旷课', color: Colors.red, data: kuangke),
          DataItem(label: '请假', color: Colors.green, data: qingjia),
        ],
      ),
    );
  }

  Widget DataItem(
      {@required String label,
      @required int data,
      Color color = Colors.green}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${data}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            '${label}',
            style: TextStyle(color: color),
          )
        ],
      ),
    );
  }
}
