import 'package:course_app/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Column(
          children: <Widget>[
            diplayAccount(
                absfrequency: 33,
                latfrequency: 0,
                leafrequency: 1,
                attfrequency: 5,
                takfrequency: 0),
            Flexible(
              child: myListRecord(testlist),
            )
          ],
        ),
      ),
    );
  }

  List testlist = [
    {'date': '${DateTime.now().toString()}', 'kTyoe': 0, 'status': 0},
    {'date': '${DateTime.now().toString()}', 'kTyoe': 1, 'status': 4},
    {'date': '${DateTime.now().toString()}', 'kTyoe': 0, 'status': 2},
    {'date': '${DateTime.now().toString()}', 'kTyoe': 0, 'status': 1},
    {'date': '${DateTime.now().toString()}', 'kTyoe': 0, 'status': 1},
    {'date': '${DateTime.now().toString()}', 'kTyoe': 1, 'status': 3},
  ];

  ///记录列表
  Widget myListRecord(List list) {
    return ListView.builder(
        itemCount: list.length, //list.length,
        itemBuilder: (context, index) {
          return everyItem(
              date: list[index]['date'],
              ktype: list[index]['ktype'],
              status: list[index]['status']);
        });
  }

  Widget everyItem({@required String date, int ktype = 0, int status = 0}) {
    //assert(ktype>-1&&ktype<2);
    //assert(status>-1&&status<6);
    String dateTitle = date.substring(0, 10);
    String dateSub = date.substring(10, date.length - 1);
    String tip = (ktype == 0) ? 'gps考勤' : '数字考勤';
    String statusMsg = '';
    Color color = Colors.green;
    if (status == 1) {
      statusMsg = '出勤';
    } else if (status == 2) {
      statusMsg = '迟到';
      color = Colors.orangeAccent;
    } else if (status == 3) {
      statusMsg = '早退';
      color = Colors.orangeAccent;
    } else if (status == 4) {
      statusMsg = '旷课';
      color = Colors.red;
    } else if (status == 5) {
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
          (status == 0)
              ? FlatButton(
                  onPressed: () {},
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
      {@required int attfrequency,
      @required int latfrequency,
      @required int leafrequency,
      @required int absfrequency,
      @required int takfrequency}) {
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
          DataItem(label: '出勤', color: Colors.green, data: attfrequency),
          DataItem(label: '迟到', color: Colors.orangeAccent, data: latfrequency),
          DataItem(label: '早退', color: Colors.orangeAccent, data: leafrequency),
          DataItem(label: '旷课', color: Colors.red, data: absfrequency),
          DataItem(label: '请假', color: Colors.green, data: takfrequency),
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
