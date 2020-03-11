import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/widget/person_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';

///课堂学生列表
class ClassStuListPgae extends StatefulWidget {
  final courseId;

  ClassStuListPgae({Key key, @required this.courseId}) : super(key: key);

  @override
  _ClassStuListPgaeState createState() => _ClassStuListPgaeState();
}

class _ClassStuListPgaeState extends State<ClassStuListPgae> {
  List<String> studentIds = [];
  AsyncMemoizer<List<UserInfoVo>> _memoizer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _memoizer=new AsyncMemoizer();
//    TeacherMethod.getStudentListId(context, widget.courseId).then((onValue) {
//      if (ObjectUtil.isNotEmpty(onValue)) {
//        setState(() {
//          studentIds = onValue;
//        });
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('同学'),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        child: FutureBuilder<List<UserInfoVo>>(
            future: _memoizer.runOnce(()async{
              studentIds=await TeacherMethod.getStudentListId(context, widget.courseId);
               debugPrint('_memoizer ${studentIds}');
               return await UserMethod.getStudentInfo(context, studentIds);
            }),
            builder: (_, data) {
              if (data.connectionState == ConnectionState.waiting) {
                return CupertinoActivityIndicator();
              }

              List<UserInfoVo> list = data.data;
              if (!data.hasData || list.isEmpty) {
                return NoDataWidget(path: 'assets/img/nodata4.png');
              }
              return ListView.builder(
                  itemCount: list.length, //attendanceStudents.length,
                  itemBuilder: (context, index) {
                    return PersonItem('${list[index].userId}',
                        userInfoVo: list[index],
                        headUrl: '${list[index].faceImage}',
                        username: '${list[index].nickname}',
                        action: 0,
                        state: 0);
                  });
            }),
      ),
    );
  }
}
