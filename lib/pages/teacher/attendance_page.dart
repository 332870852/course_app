import 'dart:async';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/data/Attendance_dto.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/pages/teacher/attendance_detail_page.dart';
import 'package:course_app/provide/attendance_provide.dart';
import 'package:course_app/provide/expire_timer_provide.dart';
import 'package:course_app/provide/showAttend_provide.dart';
import 'package:course_app/provide/teacher/attend_stu_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/router/navigatorUtil.dart';
import 'package:course_app/utils/permission_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

///教师考勤页

class AttendancePage extends StatefulWidget {
  num studentNums;
  final String courseId;

  AttendancePage({Key key, @required this.studentNums, @required this.courseId})
      : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  //Duration time;
  var seconds = 0;
  var subscription;
  var subscription1;

  //Timer countdownTimer;
  //LatLng latLng;
  int distance = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = Application.eventBus
        .respond<List<AttendanceStudents>>((List<AttendanceStudents> list) {
      debugPrint("event bus list AttendancePage");
      if (list.isNotEmpty) {
        Provide.value<AttendProvide>(context)
            .insertAttendanceStudents(context, list);
      }
    });
    subscription1 = Application.eventBus
        .respond<AttendanceStudents>((AttendanceStudents attendanceStudents) {
      debugPrint("event bus list AttendancePage");
      List<AttendanceStudents> list = [];
      list.add(attendanceStudents);
      Provide.value<AttendProvide>(context)
          .insertAttendanceStudents(context, list);
    });
  }

  @override
  void dispose() {
    subscription.dispose();
    subscription1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('考勤管理'),
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          onPressed: () {
            //todo 发布考勤任务
            Provide.value<ShowAttendProvide>(context).initStatus();
            showAttendOverlay(context);
          }),
      body: Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil.screenHeight,
          padding: EdgeInsets.only(top: 20),
          child: Provide<AttendProvide>(builder: (context, child, data) {
            if (data.attendanceVoList.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/img/nodata2.png'),
                  Text(
                    '暂无考勤记录',
                    style: TextStyle(color: Colors.blue.shade200),
                  ),
                ],
              );
            }
            return ListView.builder(
                itemCount: data.attendanceVoList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      //todo click
//                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
//                          AttendDetailPage(index:index,)));
                      NavigatorUtil.goAttendDetailPage(context,index);
                    },
                    child: AttendanceItem(data.attendanceVoList[index],
                        data: data),
                  );
                });
//            return FutureBuilder(
//                future: data.getAttendanceList(context),
//                builder: (context, snapshot) {
//                  //print("hahhaha  ${snapshot.hasData}");
//                  if(snapshot.connectionState==ConnectionState.waiting){
//                    return CupertinoActivityIndicator();
//                  }else{
//                    List<AttendanceVo> attendanceVoList = snapshot.data;
//                    if(attendanceVoList.isEmpty){
//                      return Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Image.asset('assets/img/nodata2.png'),
//                          Text(
//                            '暂无考勤记录',
//                            style: TextStyle(color: Colors.blue.shade200),
//                          ),
//                        ],
//                      );
//                    }
//                    return ListView.builder(
//                        itemCount: attendanceVoList.length,
//                        itemBuilder: (context, index) {
//                          //print(attendanceVoList[index].map.length);
//                          return AttendanceItem(attendanceVoList[index],
//                              data: data);
//                        });
//                  }
//                });
          })),
    );
  }

  Widget AttendanceItem(AttendanceVo attendanceVo, {data}) {
    //todo
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0, 1)),
      ]),
      height: 215,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          titleRow(
              createtime: '${attendanceVo.createTime}',
              type: attendanceVo.type),
          Provide<ExpireTimerProvide>(
            builder: (context, child, data) {
              int id = attendanceVo.attendanceId;
              if (data.timeExpire[id] != null) {
                return attendCodeRow(
                    attendCode: '${attendanceVo.attendCode}',
                    time: data.timerMap[id],
                    m: data.timeExpire[id].minutes,
                    s: data.timeExpire[id].second);
              } else {
                // print('打印： ${data.timerMap[id]}');
                return attendCodeRow(
                    attendCode: '${attendanceVo.attendCode}',
                    time: data.timerMap[id],
                    m: 0,
                    s: 0);
              }
            },
          ),
          ///
          (attendanceVo.map.length < 1)
              ? diplayAccount(widget.studentNums,
                  attfrequency: 0,
                  leafrequency: 0,
                  latfrequency: 0,
                  absfrequency: 0,
                  takfrequency: 0)
              : diplayAccount(widget.studentNums,
                  attfrequency: attendanceVo.map[0].length,
                  leafrequency: attendanceVo.map[1].length,
                  latfrequency: attendanceVo.map[2].length,
                  absfrequency: attendanceVo.map[3].length,
                  takfrequency: attendanceVo.map[4].length),
          (attendanceVo.type == 1)
              ? bottomRow('${attendanceVo.address}')
              : SizedBox(),
        ],
      ),
    );
  }

  Widget bottomRow(String address) {
    return Flexible(
        flex: 2,
        child: Row(
          children: <Widget>[
            Icon(
              Icons.location_city,
              color: Colors.grey,
            ),
            Flexible(
              child: Text(
                ' ${address}',
                style: TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ));
  }

  Widget attendCodeRow(
      {@required attendCode, @required time, double m, int s}) {
    return Expanded(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('考勤码',
                  style: TextStyle(color: Colors.blue.withOpacity(0.6))),
              Container(
                width: 168,
                alignment: Alignment.bottomCenter,
                child: Text(
                  '${attendCode}',
                  style: TextStyle(
                      color: Colors.black, fontSize: ScreenUtil().setSp(55)),
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.alarm,
                    color: Colors.black26,
                  ),
                  (time != null)
                      ? Text(
                          '${m.toInt()}:${s}',
                          style: TextStyle(
                              color: Colors.black26,
                              fontSize: ScreenUtil().setSp(40)),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          '已结束',
                          style: TextStyle(color: Colors.black26),
                        ),
                ],
              ),
            ],
          ),
          //Text('考勤码'),
        ],
      ),
    );
  }

  Widget titleRow({@required String createtime, @required int type}) {
    String info = '';
    if (type == 0) {
      info = '数字考勤';
    } else if (type == 1) {
      info = 'gps考勤';
    }
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: Text(
              '${createtime}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${info}',
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  ///数据统计
  Widget diplayAccount(int total,
      {@required int attfrequency,
      @required int latfrequency,
      @required int leafrequency,
      @required int absfrequency,
      @required int takfrequency}) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 0),
        height: 90,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Color(Constants.DividerColor),
                    width: Constants.DividerWith))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            DataItem(label: '总人数', color: Colors.black, data: total),
            DataItem(label: '出勤', color: Colors.green, data: attfrequency),
            DataItem(
                label: '迟到', color: Colors.orangeAccent, data: latfrequency),
            DataItem(
                label: '早退', color: Colors.orangeAccent, data: leafrequency),
            DataItem(label: '旷课', color: Colors.red, data: absfrequency),
            DataItem(label: '请假', color: Colors.green, data: takfrequency),
          ],
        ),
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

  ///创建考勤
  void showAttendOverlay(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '发布考勤任务',
                  // style: TextStyle(),
                ),
                Flexible(
                  child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black26,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
            content:
                Provide<ShowAttendProvide>(builder: (context, child, data) {
              return Container(
                height: 320,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('选择考勤类型:'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                  value: 0,
                                  groupValue: data.type,
                                  onChanged: (T) {
                                    Provide.value<ShowAttendProvide>(context)
                                        .changeType(T);
                                  }),
                              Text('数字考勤'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Radio(
                                  value: 1,
                                  groupValue: data.type,
                                  onChanged: (T) {
                                    Provide.value<ShowAttendProvide>(context)
                                        .changeType(T);
                                  }),
                              Text('gps考勤'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    (data.type == 1)
                        ? Wrap(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  FlatButton.icon(
                                    onPressed: (data.addressBtn)
                                        ? () async {
                                            //todo 获取地点定位
                                            if (await PermissionUtil
                                                .requestAmapPermission()) {
                                              Provide.value<ShowAttendProvide>(
                                                      context)
                                                  .changAddressBtn(false);
                                              Provide.value<ShowAttendProvide>(
                                                  context).changeAddress(address: '获取中..');
                                              final location =
                                                  await AmapLocation
                                                      .fetchLocation();
                                              //print(location);
                                              //_location = location;
                                              Provide.value<ShowAttendProvide>(
                                                      context)
                                                  .changeAddress(
                                                      address: await location
                                                          .address,
                                                      latLng:
                                                          await location.latLng)
                                                  .whenComplete(() {
                                                Provide.value<
                                                            ShowAttendProvide>(
                                                        context)
                                                    .changAddressBtn(true);
                                              });
                                            }
                                          }
                                        : null,
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                    ),
                                    label: (data.addressBtn)
                                        ? Text('获取考勤定位')
                                        : Text('正在获取定位..'),
                                    color: Colors.green.withOpacity(0.2),
                                    disabledColor:
                                        Colors.grey.shade300.withOpacity(0.2),
                                    clipBehavior: Clip.antiAlias,
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      '${data.address}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text('设置考勤距离'),
                                  Flexible(
                                    child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Color(Constants.DividerColor),
                                              width: Constants.DividerWith),
                                        ),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                        ),
                                        margin: EdgeInsets.only(
                                            left: 5, right: 5, bottom: 5),
                                        child: FlatButton(
                                          onPressed: () {
                                            //todo 距离选择
                                            DistancePicker();
                                          },
                                          child: Text(
                                            '${data.distance}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 28),
                                          ),
                                        )),
                                  ),
                                  Text('米'),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(),
                    Row(
                      children: <Widget>[
                        Text('设置签到时间'),
                        Flexible(
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(Constants.DividerColor),
                                    width: Constants.DividerWith),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: FlatButton(
                                onPressed: () {
                                  //todo 时间选择
                                  TimerPicker();
                                },
                                child: Text(
                                  '${data.timer.inMinutes}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 40),
                                ),
                              )),
                        ),
                        Text('min'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '考勤码由系统自动生成',
                          style: TextStyle(color: Colors.black26),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CupertinoButton(
                            child: (data.displaycreateBnt)
                                ? CupertinoActivityIndicator()
                                : Text('发布'),
                            color: Colors.blue,
                            onPressed: (data.displaycreateBnt)
                                ? null
                                : () {
                                    //todo 发布
                                    Duration d =
                                        Provide.value<ShowAttendProvide>(
                                                context)
                                            .timer;
                                    print(d.inSeconds);
                                    int type = Provide.value<ShowAttendProvide>(
                                            context)
                                        .type;
                                    AttendanceDto attendance = AttendanceDto(
                                        courseId: '${widget.courseId}',
                                        expire: d.inSeconds,
                                        createTime:
                                            DateTime.now().toIso8601String(),
                                        type: type);
                                    if (type == 1) {
                                      //gps考勤
                                      LatLng latLng =
                                          Provide.value<ShowAttendProvide>(
                                                  context)
                                              .latLng;
                                      String address =
                                          Provide.value<ShowAttendProvide>(
                                                  context)
                                              .address;
                                      if (ObjectUtil.isEmpty(latLng)) {
                                        Fluttertoast.showToast(msg: '地点定位不能为空');
                                        return null;
                                      }
                                      attendance.latitude = latLng.latitude;
                                      attendance.longitude = latLng.longitude;
                                      attendance.address = address;
                                      attendance.distance =
                                          Provide.value<ShowAttendProvide>(
                                                  context)
                                              .distance;
                                     // print('${latLng}  ${address}');
                                    }

                                    ///禁用按钮，显示进度
                                    Provide.value<ShowAttendProvide>(context)
                                        .changeCreateBtn(true);
                                    TeacherMethod.createAttendance(
                                            context, attendance)
                                        .then((onValue) {
                                      if (ObjectUtil.isNotEmpty(onValue)) {
                                        Provide.value<AttendProvide>(context)
                                            .insertAtten(context, onValue);
                                      }
                                    }).whenComplete(() {
                                      //恢复按钮
                                      Provide.value<ShowAttendProvide>(context)
                                          .changeCreateBtn(false);
                                      Navigator.pop(context);
                                    });
                                  })
                      ],
                    ),
                  ],
                ),
              );
            }),
//            actions: <Widget>[],
          );
        });
  }

  ///time picker
  void TimerPicker() {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return Container(
              height: 200,
              color: CupertinoColors.white,
              child: Wrap(
                children: <Widget>[
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color(Constants.DividerColor),
                              width: Constants.DividerWith)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '取消',
                          ),
                          textColor: Colors.black26,
                        ),
                        FlatButton(
                          onPressed: () {
                            Provide.value<ShowAttendProvide>(context)
                                .changeDisplayTimer(
                                    Provide.value<ShowAttendProvide>(context)
                                        .timer);
                            Navigator.pop(context);
                          },
                          child: Text(
                            '确认',
                          ),
                          textColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  CupertinoTimerPicker(
                      alignment: Alignment.center,
                      initialTimerDuration: Duration(minutes: 5),
                      secondInterval: 60,
                      mode: CupertinoTimerPickerMode.ms,
                      onTimerDurationChanged: (Duration newTimer) {
                        Provide.value<ShowAttendProvide>(context).timer =
                            newTimer;
                        //seconds = time.inSeconds;
                        //print(seconds);
                      }),
                ],
              ));
        });
  }

  ///选择距离
  void DistancePicker() {
    num u = 50;
    List<Widget> items = List<Widget>.generate(u, (index) {
      return Text('${(index + 1) * 10} /米');
    }).cast();
    showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            color: CupertinoColors.white,
            child: Column(
              children: <Widget>[
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color(Constants.DividerColor),
                            width: Constants.DividerWith)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          '取消',
                        ),
                        textColor: Colors.black26,
                      ),
                      FlatButton(
                        onPressed: () {
                          Provide.value<ShowAttendProvide>(context)
                              .changeDistance(distance);
                          Navigator.pop(context);
                        },
                        child: Text(
                          '确认',
                        ),
                        textColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: CupertinoPicker(
                      itemExtent: 25,
                      backgroundColor: Colors.white,
                      //scrollController: ,
                      onSelectedItemChanged: (index) {
                        distance = (index + 1) * 10;
                      },
                      children: items),
                ),
              ],
            ),
          );
        });
  }
}
