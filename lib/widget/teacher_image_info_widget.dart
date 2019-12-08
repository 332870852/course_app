import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///房主头像信息
class TeacherImageInfoWidget extends StatelessWidget {
  final url;
  final teacherName;

  TeacherImageInfoWidget(
      {Key key, @required this.url, @required this.teacherName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _teacherImageInfo(url: url, teacherName: teacherName);
  }

  ///房主头像信息
  Widget _teacherImageInfo({@required url, @required teacherName}) {
    return Container(
      padding: EdgeInsets.only(left: 50),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CircleAvatar(
            minRadius: ScreenUtil().setSp(30),
            maxRadius: ScreenUtil().setSp(30),
            backgroundImage: NetworkImage(url),
          ),
          Text(
            teacherName,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
