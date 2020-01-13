import 'package:course_app/model/Course.dart';
import 'package:course_app/service/student_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:flutter/material.dart';

enum Codes {
  def,
  loading,
  success,
  error,
}

class CourseProvide with ChangeNotifier {
  List<Course> courseList = [];

  ///加课返回状态码
  Codes code = Codes.def;

  ///加课返回消息
  String backMessage = '';

  ///当前页
  Curssor curssor = Curssor(1, 1, 5);

  ///获取网络课程数据
  Future<List<Course>> student_getCoursePage(userId) async {
    ResponseModel responseModel = await StudentMethod.getCoursePage(
      userId: userId,
    );
    if (responseModel.data != null) {
      print("网络");
      List<dynamic> list = responseModel.data;
      courseList = list
          .map((item) {
            return Course.fromJson(item);
          })
          .toList()
          .cast();
      curssor = responseModel.cursor;
      notifyListeners();
    }
    return courseList;
  }

  ///修改状态
  changeCode({@required Codes codes}) {
    code = codes;
    notifyListeners();
  }

  ///加课post请求
  Future<Course> postJoinCode(userId, String joincode) async {
    ResponseModel responseModel =
        await StudentMethod.JoinCode(userId, joincode);
    Course course;
    if (responseModel.data != null) {
      course = Course.fromJson(responseModel.data);
      courseList.insert(0, course);
      code = Codes.success;
      backMessage = '';
    } else {
      code = Codes.error;
      backMessage = responseModel.result;
    }
    notifyListeners();
    return course;
  }

  ///加载更多
  Future<bool> getMoreCourseList(userId, {pageSize = 5}) async {
    print(curssor);
    ResponseModel responseModel = await StudentMethod.getCoursePage(
        userId: userId, pageNo: curssor.offset, pageSize: pageSize);
    print(responseModel.data == '');
    List<dynamic> list = responseModel.data;
    if (list != null && list.isNotEmpty) {
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

  ///退课
  bool removeCourse(String courseId) {
    int index = -1;
    for (int i = 0; i < courseList.length; i++) {
      if (courseList[i].courseId == num.parse(courseId)) {
        index = i;
        break;
      }
    }
    if (index >= 0) {
      courseList.removeAt(index);
      notifyListeners();
      return true;
    } else {
      return false;
    }
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
