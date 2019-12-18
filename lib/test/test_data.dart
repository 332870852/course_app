
import 'package:course_app/model/Course.dart';

class TestData{

  static TestData _testData = new TestData._();


  List<Course> _courses=[];

  TestData._(){
    Course cou=Course();
    cou.title="2019秋 单片机原理与实验sssss44";
    cou.start=2018;
    cou.end=2019;
    cou.semester=1;
    cou.member=126;
    cou.courseNumber='1555';
    cou.courseId=11123;
    cou.joincode='459WSL';
    //cou.teacherName='李建刚';
    //cou.teacherUrl='http://pic31.nipic.com/20130730/789607_232633343194_2.jpg';
    cou.head_urls=[
      "http://pic31.nipic.com/20130730/789607_232633343194_2.jpg",
      "http://pic5.nipic.com/20100112/2373269_215502992772_2.jpg",
      "http://www.xingshitang.com.cn/pic1/201356968.jpg"
    ];
    Course cou2=Course();
    //cou2.teacherName='李建刚';
    cou2.title="2019秋 编译原理";
    cou2.courseNumber="188845";
    cou2.courseId=11123;
//    cou.start=2017;
//    cou.end=2018;
//    cou.semester=1;
    cou2.member=80;
    cou2.joincode='4s92SL';
    cou2.head_urls=[
      "http://pic31.nipic.com/20130730/789607_232633343194_2.jpg",
      "http://pic5.nipic.com/20100112/2373269_215502992772_2.jpg",
      "http://www.xingshitang.com.cn/pic1/201356968.jpg"
    ];
    _courses.add(cou);
    _courses.add(cou2);
  }
  static getInstance_Course(){
    return _testData._courses;
  }
}


