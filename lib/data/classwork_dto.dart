class ClassWorkDto {
  String title;
  String content;
  List<String> annex;
  int score;
  String createTime;
  num expireTime;
  String courseId;


  ClassWorkDto({this.title, this.content, this.annex, this.score,
    this.createTime, this.expireTime, this.courseId});


  @override
  String toString() {
    return 'ClassWorkDto{title: $title, content: $content, annex: $annex, score: $score, createTime: $createTime, expireTime: $expireTime, courseId: $courseId}';
  }

  ClassWorkDto.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    annex = json['annex'].cast<String>();
    createTime = json['createTime'];
    score = json['score'];
    expireTime = json['expireTime'];
    courseId = json['courseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['annex'] = this.annex;
    data['createTime'] = this.createTime;
    data['score'] = this.score;
    data['expireTime'] = this.expireTime;
    data['courseId'] = this.courseId;
    return data;
  }
}
