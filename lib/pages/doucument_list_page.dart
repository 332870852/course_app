import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///资料页面
class DoucumentListPage extends StatelessWidget {
  final courseId;
  final teacherId;

  DoucumentListPage(
      {Key key, @required this.courseId, @required this.teacherId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('资料'),
        elevation: 0.0,
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Center(
          child: Text('暂无数据'),
        ),
      ),
    );
  }
}
