import 'package:course_app/model/Course.dart';
import 'package:course_app/test/test_data.dart';
import 'package:flutter/material.dart';

//class JoinCourseProvide with ChangeNotifier{
//
//   List<Course> courses = TestData.getInstance_Course();
//   Code code=Code.def; ///加课返回状态码
//
//   ///修改状态
//   changeCode({@required Code codes}){
//     code=codes;
//     notifyListeners();
//   }
//
//   ///加课post请求
//   Future<bool> postJoinCode(String joincode)async{
//     //模拟
//     await Future.delayed(Duration(seconds: 2),(){
//       if(joincode=='123456'){
//         code=Code.success;
//       }else{
//         code=Code.error;
//       }
//       notifyListeners();
//
//     });
//
//     return (code==Code.success?true:false);
//   }
//
//   ///获取课程列表
//   getCourseList()async{
//
//   }
//
//   getMoreCourseList()async{
//     Course cou2=Course();
//     cou2.courseId=111;
//     cou2.title="2019秋 编译原理";
//     cou2.courseNumber="188845";
//    // cou2.teacherName='李建刚';
////    cou.start=2017;
////    cou.end=2018;
////    cou.semester=1;
//     cou2.member=80;
//     cou2.joincode='4s92SL';
//     cou2.head_urls=[
//       "http://pic31.nipic.com/20130730/789607_232633343194_2.jpg",
//       "http://pic5.nipic.com/20100112/2373269_215502992772_2.jpg",
//       "http://www.xingshitang.com.cn/pic1/201356968.jpg"
//     ];
//     courses.add(cou2);
//     notifyListeners();
//   }
//}
//
//enum Code{
//  def,
//  loading,
//  success,
//  error,
//}