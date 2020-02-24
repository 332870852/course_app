import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/provide/attendance_provide.dart';
import 'package:course_app/provide/attendance_student_provide.dart';
import 'package:course_app/provide/teacher/attend_stu_provide.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/cupertion_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'attend_detail_list.dart';

///考勤详情页
class AttendDetailPage extends StatefulWidget {
  //AttendanceVo attendanceVo;
  final int index;
  AttendDetailPage({Key key, @required this.index}) : super(key: key);

  @override
  _AttendDetailPageState createState() => _AttendDetailPageState();
}

class _AttendDetailPageState extends State<AttendDetailPage>
    with TickerProviderStateMixin {
  String typeStr = '';
  TabController _tabController;
  AttendanceVo _attendanceVo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    if (widget.attendanceVo.type == 0) {
//      typeStr = '数字考勤';
//    } else if (widget.attendanceVo.type == 1) {
//      typeStr = 'gps考勤';
//    }
    _tabController = new TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<AttendProvide>(
      builder: (context, child, data) {
        _attendanceVo = data.attendanceVoList[widget.index];
        Provide.value<AttendStudentProvide>(context).saveMapAtt(_attendanceVo.map);
        if (_attendanceVo.type == 0) {
          typeStr = '数字考勤';
        } else if (_attendanceVo.type == 1) {
          typeStr = 'gps考勤';
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('考勤详情管理'),
            elevation: 0.0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                }),
            actions: <Widget>[
              IconButton(
                  icon: Icon(CupertinoIcons.delete),
                  onPressed: () async {
                    //todo delete
                    var b = await showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertionDialog(
                            title: '确定删除该考勤任务吗?',
                            content: '',
                            onOk: () {
                              Navigator.pop(context, true);
                            },
                            onCancel: () {
                              Navigator.pop(context, false);
                            },
                            isLoding: false,
                          );
                        });
                    if (b) {
                      bool bs = await TeacherMethod.delAttendance(
                              context,
                          _attendanceVo.courseId,
                          _attendanceVo.attendanceId.toString())
                          .catchError((onError) {
                        Fluttertoast.showToast(msg: onError.toString());
                      });
                      if (bs) {
                        Provide.value<AttendProvide>(context)
                            .deleteAttend(_attendanceVo);
                        Navigator.pop(context);
                      }
                    }
                  })
            ],
          ),
          body: Container(
            width: ScreenUtil.screenWidth,
            height: ScreenUtil.screenHeight,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  //margin: EdgeInsets.all(10),
                  width: ScreenUtil.screenWidth,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Color(Constants.DividerColor),
                          width: Constants.DividerWith)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text('发布时间 ${_attendanceVo.createTime}'),
                            Text('${typeStr}'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${_attendanceVo.attendCode}',
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(50)),
                            ),
                          ],
                        ),
                        flex: 2,
                      ),
                      Navigattom(),
                    ],
                  ),
                ),
                Flexible(
                  child: TabBarView(controller: _tabController, children: [
                    DetailList(
                      //attendanceStudents: _attendanceVo.map[0],
                      index: 0,
                    ),
                    // ItemList(data.map[0]),
                    DetailList(
//                      attendanceStudents: _attendanceVo.map[1],
                      index: 1,
                    ),
                    DetailList(
//                      attendanceStudents:  _attendanceVo.map[2],
                      index: 2,
                    ),
                    DetailList(
//                      attendanceStudents:  _attendanceVo.map[3],
                      index: 3,
                    ),
                    DetailList(
//                      attendanceStudents:  _attendanceVo.map[4],
                      index: 4,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget Navigattom() {
    return Expanded(
      child: Container(
        //padding: EdgeInsets.only(left: 20, right: 20),
        child: TabBar(controller: _tabController, tabs: [
          Tab(
            child: Text(
              '出勤(${_attendanceVo.map[0].length})',
              style: TextStyle(color: Colors.green),
            ),
          ),
          Tab(
            child: Text(
              '迟到(${_attendanceVo.map[1].length})',
              style: TextStyle(color: Colors.orangeAccent),
            ),
          ),
          Tab(
            child: Text(
              '早退(${_attendanceVo.map[2].length})',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          Tab(
            child: Text(
              '旷课(${_attendanceVo.map[3].length})',
              style: TextStyle(color: Colors.red),
            ),
          ),
          Tab(
            child: Text(
              '请假(${_attendanceVo.map[4].length})',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ]),
//        child: Provide<AttendStuProvide>(
//          builder: (context, child, data) {
//            return TabBar(controller: _tabController, tabs: [
//              Tab(
//                child: Text(
//                  '出勤(${_attendanceVo.map[0].length})',
//                  style: TextStyle(color: Colors.green),
//                ),
//              ),
//              Tab(
//                child: Text(
//                  '迟到(${_attendanceVo.map[1].length})',
//                  style: TextStyle(color: Colors.orangeAccent),
//                ),
//              ),
//              Tab(
//                child: Text(
//                  '早退(${_attendanceVo.map[2].length})',
//                  style: TextStyle(color: Colors.orange),
//                ),
//              ),
//              Tab(
//                child: Text(
//                  '旷课(${_attendanceVo.map[3].length})',
//                  style: TextStyle(color: Colors.red),
//                ),
//              ),
//              Tab(
//                child: Text(
//                  '请假(${_attendanceVo.map[4].length})',
//                  style: TextStyle(color: Colors.green),
//                ),
//              ),
//            ]);
//          },
//        ),
      ),
      flex: 2,
    );
  }
}
