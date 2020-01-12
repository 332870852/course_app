import 'package:course_app/model/Course.dart';
import 'package:course_app/service/student_method.dart';
import 'package:course_app/service/teacher_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:flutter/material.dart';

enum Code {
  def,
  loading,
  success,
  error,
}

class CourseTeacherProvide with ChangeNotifier {
  List<Course> courseList = [];

  ///加课返回状态码
  Code code = Code.def;
  ///加课返回消息
  String backMessage='';

  ///当前页
  Curssor curssor = Curssor(1, 1, 5);

  ///获取网络课程数据
  Future<List<Course>> teacher_getCoursePage(userId) async {
    ResponseModel responseModel = await TeacherMethod.getCoursePage(
      userId: userId,
    );
    if (responseModel.data != null) {
      print("网络");
      List<dynamic> list = responseModel.data;
      courseList = list
          .map((item) {
        return Course.fromJson(item);
      }).toList()
          .cast();
      curssor = responseModel.cursor;
      notifyListeners();
    }
    return courseList;
  }

  ///修改状态
  changeCode({@required Code codes}) {
    code = codes;
    notifyListeners();
  }


  ///加载更多
  Future<bool> getMoreCourseList(userId, {pageSize = 5}) async {
    ResponseModel responseModel = await TeacherMethod.getCoursePage(
        userId: userId, pageNo: curssor.offset, pageSize: pageSize);
    print(responseModel.data == '');
    List<dynamic> list = responseModel.data;
    if (list!=null&&list.isNotEmpty) {
      List<Course> more = list
          .map((item) {
        return Course.fromJson(item);
      })
          .toList()
          .cast();
      curssor = responseModel.cursor;
      courseList.addAll(more);
      notifyListeners();
      return true;
    }

    return false;
  }

  void increatePage() async {
    curssor.offset = curssor.offset + 1;
    //print("increatePage${curssor.offset}");
  }

  void decreatelPage() async {
    curssor.offset = curssor.offset - 1;
    //print("decreatelPage ${curssor.offset}");
  }
}
