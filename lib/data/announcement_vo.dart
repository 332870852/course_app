///receiver
///公告
class AnnouncementVo {
  int announceId;
  String announceTitle;
  String announceBody;
  String annex;
  String date;
  String publisherId;
  String courseId;
  List<String> readeds;
  int replyNums;


  @override
  String toString() {
    return 'AnnouncementVo{announceId: $announceId, announceTitle: $announceTitle, announceBody: $announceBody, annex: $annex, date: $date, publisherId: $publisherId, courseId: $courseId, readeds: $readeds, replyNums: $replyNums}';
  }

  AnnouncementVo(
      {this.announceId,
        this.announceTitle,
        this.announceBody,
        this.annex,
        this.date,
        this.publisherId,
        this.courseId,
        this.readeds,
        this.replyNums});

  AnnouncementVo.fromJson(Map<String, dynamic> json) {
    announceId = json['announceId'];
    announceTitle = json['announceTitle'];
    announceBody = json['announceBody'];
    annex = json['annex'];
    date = json['date'];
    publisherId = json['publisherId'];
    courseId = json['courseId'];
    readeds = json['readeds'].cast<String>();
    replyNums = json['replyNums'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['announceId'] = this.announceId;
    data['announceTitle'] = this.announceTitle;
    data['announceBody'] = this.announceBody;
    data['annex'] = this.annex;
    data['date'] = this.date;
    data['publisherId'] = this.publisherId;
    data['courseId'] = this.courseId;
    data['readeds'] = this.readeds;
    data['replyNums'] = this.replyNums;
    return data;
  }
}