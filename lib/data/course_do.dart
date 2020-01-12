class CourseDo extends Object {

  String courseId;
  String courseTitle;
  String number;
  int start;
  int end;
  int semester;
  String bgkColor;
  String bgkUrl;
  String teacherId;

  CourseDo({this.courseId, this.courseTitle, this.number, this.start, this.end,
    this.semester, this.bgkColor, this.bgkUrl, this.teacherId});

  @override
  String toString() {
    return 'CourseDo{courseId: $courseId, courseTitle: $courseTitle, number: $number, start: $start, end: $end, semester: $semester, bgkColor: $bgkColor, bgkUrl: $bgkUrl, teacherId: $teacherId}';
  }

  CourseDo.fromJson(Map<String, dynamic> json) {
    courseId=json['courseId'];
    courseTitle = json['courseTitle'];
    number = json['number'];
    start = json['start'];
    end = json['end'];
    semester = json['semester'];
    bgkColor = json['bgkColor'];
    bgkUrl = json['bgkUrl'];
    teacherId = json['teacherId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    data['courseTitle'] = this.courseTitle;
    data['number'] = this.number;
    data['start'] = this.start;
    data['end'] = this.end;
    data['semester'] = this.semester;
    data['bgkColor'] = this.bgkColor;
    data['bgkUrl'] = this.bgkUrl;
    data['teacherId'] = this.teacherId;
    return data;
  }
}