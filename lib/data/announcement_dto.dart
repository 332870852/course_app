///send 公告
class AnnouncementDto {
  int announceId;
  String announceTitle;
  String announceBody;
  String annex;
  String courseId;


  @override
  String toString() {
    return 'AnnouncementDto{announceId: $announceId, announceTitle: $announceTitle, announceBody: $announceBody, annex: $annex, courseId: $courseId}';
  }

  AnnouncementDto(
      {this.announceId,
        this.announceTitle,
        this.announceBody,
        this.annex,
        this.courseId,});

  AnnouncementDto.fromJson(Map<String, dynamic> json) {
    announceId = json['announceId'];
    announceTitle = json['announceTitle'];
    announceBody = json['announceBody'];
    annex = json['annex'];
    courseId = json['courseId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['announceId'] = this.announceId;
    data['announceTitle'] = this.announceTitle;
    data['announceBody'] = this.announceBody;
    data['annex'] = this.annex;
    data['courseId'] = this.courseId;

    return data;
  }
}