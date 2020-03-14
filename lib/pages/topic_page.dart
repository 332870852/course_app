import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///话题
class TopicPage extends StatelessWidget {
  final courseId;
  final teacherId;

  TopicPage({Key key, @required this.courseId, @required this.teacherId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('话题'),
        elevation: 0.0,
      ),
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: Center(
          child: Text('暂无内容'),
        ),
      ),
    );
  }
}
