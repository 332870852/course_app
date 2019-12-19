import 'package:json_annotation/json_annotation.dart';
part 'Course.g.dart';

@JsonSerializable()
///课堂列表数据
class Course extends Object{//with $CourseSerializerMixin
  num courseId;
  String title ;//课堂标题
  String joincode;//加课码
  String courseNumber; //课号
  num start;
  num end;
  num semester;//学期
  int member; //课程人数
  String bgkColor; //背景颜色
  String bgkUrl; //背景图片
  String teacherId;
  String cid;//加课二维码
  List<String> head_urls;
  DateTime createTime;
  List<num> userIdSet;
  Course();


  @override
  String toString() {
    return 'Course{courseId: $courseId, title: $title, joincode: $joincode, courseNumber: $courseNumber, start: $start, end: $end, semester: $semester, member: $member, bgkColor: $bgkColor, bgkUrl: $bgkUrl, teacherId: $teacherId, cid: $cid, head_urls: $head_urls, createTime: $createTime, userIdSet: $userIdSet}';
  }

  factory Course.fromJson(Map<String, dynamic> json) =>
      _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);

}


class Data {
  int courseId;
  String courseTitle;
  String number;
  String code;
  int member;
  int start;
  int end;
  int semester;
  String createTime;
  String cid;
  String bgkColor;
  String bgkUrl;
  List<String> headUrls;
  String teacherId;

  Data(
      {this.courseId,
        this.courseTitle,
        this.number,
        this.code,
        this.member,
        this.start,
        this.end,
        this.semester,
        this.createTime,
        this.cid,
        this.bgkColor,
        this.bgkUrl,
        this.headUrls,
        this.teacherId});

  Data.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    courseTitle = json['courseTitle'];
    number = json['number'];
    code = json['code'];
    member = json['member'];
    start = json['start'];
    end = json['end'];
    semester = json['semester'];
    createTime = json['createTime'];
    cid = json['cid'];
    bgkColor = json['bgkColor'];
    bgkUrl = json['bgkUrl'];
    headUrls = json['head_urls'].cast<String>();
    teacherId = json['teacherId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    data['courseTitle'] = this.courseTitle;
    data['number'] = this.number;
    data['code'] = this.code;
    data['member'] = this.member;
    data['start'] = this.start;
    data['end'] = this.end;
    data['semester'] = this.semester;
    data['createTime'] = this.createTime;
    data['cid'] = this.cid;
    data['bgkColor'] = this.bgkColor;
    data['bgkUrl'] = this.bgkUrl;
    data['head_urls'] = this.headUrls;
    data['teacherId'] = this.teacherId;
    return data;
  }
}