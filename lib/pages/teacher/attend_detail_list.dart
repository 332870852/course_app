import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:course_app/config/constants.dart';
import 'package:course_app/data/Attendance_vo.dart';
import 'package:course_app/provide/attendance_provide.dart';
import 'package:course_app/provide/attendance_student_provide.dart';
import 'package:course_app/provide/teacher/attend_stu_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/service/user_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:provide/provide.dart';

class DetailList extends StatefulWidget {
//   List<AttendanceStudents> attendanceStudents;
  final int index;

  DetailList({Key key, @required this.index}) : super(key: key);

  @override
  _DetailListState createState() => _DetailListState();
}

class _DetailListState extends State<DetailList>
    with AutomaticKeepAliveClientMixin {
  //
  List<AttendanceStudents> attendanceStudents;
  Map<String, dynamic> map;
  Map<String, dynamic> statusL;
  List<String> list;
  var subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    list = [];
//    map = Map();
//    statusL = Map();
//    attendanceStudents.forEach((id) {
//      list.add(id.studentId);
//    });
//    attendanceStudents.forEach((it) {
//      String time = it.time;
//      time = time.substring(10, time.length);
//      map.putIfAbsent(it.studentId, () => time);
//      statusL.putIfAbsent(it.studentId, () => it.status);
//    });
//    subscription = Application.eventBus.respond<String>((String event) {
//      debugPrint("event bus list gggg ${event}");
//      build(context);
//    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    attendanceStudents =
    Provide
        .value<AttendStudentProvide>(context)
        .mapAtt[widget.index];
    print('aa  ${widget.index} ${attendanceStudents}');
    list = [];
    map = Map();
    statusL = Map();

    attendanceStudents.forEach((id) {
      list.add(id.studentId);
    });
    attendanceStudents.forEach((it) {
      String time = it.time;
      time = time.substring(10, time.length);
      map.putIfAbsent(it.studentId, () => time);
      statusL.putIfAbsent(it.studentId, () => it.status);
    });
    return Provide<AttendStudentProvide>(
      builder: (context, child, data) {
        return Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil.screenHeight,
          child: FutureBuilder(
              future: UserMethod.getStudentInfo(context, list),
              builder: (context, sna) {
                if (sna.connectionState == ConnectionState.waiting) {
                  return CupertinoActivityIndicator();
                }
                if (sna.hasData) {
                  return ListView.builder(
                      itemCount: sna.data.length, //attendanceStudents.length,
                      itemBuilder: (context, index) {
                        String name = !ObjectUtil.isEmptyString(
                            sna.data[index].identityVo.realName)
                            ? sna.data[index].identityVo.realName
                            : sna.data[index].nickname;
                        return PersonItem(
                            index,
                            '${sna.data[index].faceImage}',
                            //http://pic5.nipic.com/20100112/2373269_215502992772_2.jpg
                            '${name}', //'李想',
                            '${sna.data[index].identityVo.stuId}',
                            time: '${map[sna.data[index].userId.toString()]}',
                            status: statusL[sna.data[index].userId.toString()]);
                      });
                } else {
                  return Center(
                    child: Wrap(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      direction: Axis.vertical,
                      children: <Widget>[
                        Image.asset('assets/img/nodata4.png'),
                        Text(
                          '暂无数据',
                          style: TextStyle(color: Colors.blue.shade200),
                        ),
                      ],
                    ),
                  );
                }
              }),
        );
      },
    );
  }

  Widget PersonItem(int index, String url, String username, String userId,
      {int status, String time}) {
    return Ink(
      child: ListTile(
        onTap: () {
          StatusPicker(index, status);
        },
        onLongPress: () {},
        leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider('$url',
                cacheManager: DefaultCacheManager())),
        title: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Wrap(
            runSpacing: 5,
            spacing: 5,
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                '${userId}',
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${username}',
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        trailing: Text('${time}'),
      ),
      decoration: BoxDecoration(color: Colors.white),
    );
  }

  Map<int, Widget> widgetSelect = {
    0: Text('出勤'),
    1: Text('迟到'),
    2: Text('早退'),
    3: Text('旷课'),
    4: Text('请假'),
  };

  void StatusPicker(int index, int status) {
    List<Widget> items = [];
    widgetSelect.forEach((i, v) {
      items.add(v);
    });
    items[status] = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widgetSelect[status],
        Icon(
          Icons.check,
          color: Colors.green,
        ),
      ],
    );
    int select = 0;
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
                        onPressed: () async {
                          print(select);
                          bool b = await TeacherMethod.updateAttendanceStudent(
                              context,
                              attendanceStudents[index]
                                  .attendanceStudentId
                                  .toString(),
                              attendanceStudents[index].attendanceId,
                              select);
                          print(b);
                          if (b) {
                            Provide.value<AttendProvide>(context)
                                .updateAttendanceStudents(
                                context, attendanceStudents[index], select);
                          }
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
                      //scrollController:
                      onSelectedItemChanged: (index) {
                        select = index;
                      },
                      children: items),
                ),
              ],
            ),
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

//class DetailList extends StatelessWidget {//with AutomaticKeepAliveClientMixin
//  final List<AttendanceStudents> attendanceStudents;
//
//  DetailList({Key key, @required this.attendanceStudents}) : super(key: key);
//  Map<String, dynamic> map = Map();
//
//  @override
//  Widget build(BuildContext context) {
//    List<String> list = [];
//    attendanceStudents.forEach((id) {
//      list.add(id.studentId);
//    });
//    attendanceStudents.forEach((it){
//       String time = it.time;
//       time = time.substring(10, time.length);
//      map.putIfAbsent(it.studentId, ()=>time);
//    });
//
//    return Container(
//      width: ScreenUtil.screenWidth,
//      height: ScreenUtil.screenHeight,
//      //decoration: BoxDecoration(color: Colors.black26),
//      child: FutureBuilder(
//          future:
//              (list.isEmpty) ? null : UserMethod.getStudentInfo(context, list),
//          builder: (context, sna) {
//            if(sna.connectionState==ConnectionState.waiting){
//              return CupertinoActivityIndicator();
//            }
//            if (sna.hasData) {
//              return ListView.builder(
//                  //controller: scrollController,
//                  itemCount: sna.data.length, //attendanceStudents.length,
//                  itemBuilder: (context, index) {
//
//                    return PersonItem(
//                        '${sna.data[index].faceImage}',
//                        //http://pic5.nipic.com/20100112/2373269_215502992772_2.jpg
//                        '${sna.data[index].nickname}', //'李想',
//                        '${sna.data[index].identityVo.stuId}',
//                        time: '${map[sna.data[index].userId.toString()]}');
//                  });
//            } else {
//              return Center(
//                child: Wrap(
//                  //mainAxisAlignment: MainAxisAlignment.center,
//                  direction: Axis.vertical,
//                  children: <Widget>[
//                    Image.asset('assets/img/nodata4.png'),
//                    Text(
//                      '暂无数据',
//                      style: TextStyle(color: Colors.blue.shade200),
//                    ),
//                  ],
//                ),
//              );
//            }
//          }),
//    );
//  }
//
//  Widget PersonItem(String url, String username, String userId, {String time}) {
//    return Ink(
//      child: ListTile(
//        onTap: () {},
//        onLongPress: () {
////          showMenu(
////              context: context,
////              position: RelativeRect.fromLTRB(500, 450, 550, 600),
////              items: [
////                PopupMenuItem(child: Text('编辑')),
////              ]);
//        },
//        leading: CircleAvatar(
//            backgroundImage: CachedNetworkImageProvider('$url',
//                cacheManager: DefaultCacheManager())),
//        title: Padding(
//          padding: EdgeInsets.only(left: 5),
//          child: Wrap(
//            runSpacing: 5,
//            spacing: 5,
//            direction: Axis.vertical,
//            children: <Widget>[
//              Text(
//                '${userId}',
//                overflow: TextOverflow.ellipsis,
//              ),
//              Text(
//                '${username}',
//                overflow: TextOverflow.ellipsis,
//              )
//            ],
//          ),
//        ),
//        trailing: Text('${time}'),
//      ),
//      decoration: BoxDecoration(color: Colors.white),
//    );
//  }
//}
