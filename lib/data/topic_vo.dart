class TopicVo {
  String id;
  String tag;
  String content;
  List<String> annexes;
  String createTime;
  List<String> likeNums;
  String publisher;
  String courseId;
  int commentNums;

  TopicVo(
      {this.id,
      this.tag,
      this.content,
      this.annexes,
      this.createTime,
      this.likeNums,
      this.publisher,
      this.courseId,
      this.commentNums});

  TopicVo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    content = json['content'];
    annexes = json['annexes'].cast<String>();
    createTime = json['createTime'];
    likeNums = json['likeNums'].cast<String>();
    publisher = json['publisher'];
    courseId = json['courseId'];
    commentNums=json['commentNums'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag'] = this.tag;
    data['content'] = this.content;
    data['annexes'] = this.annexes;
    data['createTime'] = this.createTime;
    data['likeNums'] = this.likeNums;
    data['publisher'] = this.publisher;
    data['courseId'] = this.courseId;
    data['commentNums']=this.commentNums;
    return data;
  }
}
