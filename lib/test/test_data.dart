
class TestData{

  static TestData _testData = new TestData._();


  List<Course> _courses=[];

  TestData._(){
    Course cou=Course();
    cou.title="2019秋 单片机原理与实验sssssssssssssssss";
    cou.start=2018;
    cou.end=2019;
    cou.semester=1;
    cou.nums=126;
    cou.course_id='555';
    cou.joincode='459WSL';
    cou.head_urls=[
      "http://pic31.nipic.com/20130730/789607_232633343194_2.jpg",
      "http://pic5.nipic.com/20100112/2373269_215502992772_2.jpg",
      "http://www.xingshitang.com.cn/pic1/201356968.jpg"
    ];
    Course cou2=Course();
    cou2.title="2019秋 编译原理";
    cou2.course_id="188845";
//    cou.start=2017;
//    cou.end=2018;
//    cou.semester=1;
    cou2.nums=80;
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


///课堂列表数据
///
class Course{
  String title ;//课堂标题
  String joincode;//加课码
  String course_id; //课号
  int start;
  int end;
  int semester;//学期
  int nums; //课程人数
  List<String> head_urls; ///随机三人url地址
}