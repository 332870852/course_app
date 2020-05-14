class TopicDto {
  String tag;
  String content;
  List<String> annexes;
  String createTime;
  String publisher;
  String courseId;

  TopicDto({
    this.tag,
    this.content,
    this.annexes,
    this.createTime,
    this.publisher,
    this.courseId,
  });

  @override
  String toString() {
    return 'TopicDto{tag: $tag, content: $content, annexes: $annexes, createTime: $createTime, publisher: $publisher, courseId: $courseId}';
  }

  TopicDto.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    content = json['content'];
    annexes = json['annexes'].cast<String>();
    createTime = json['createTime'];
    publisher = json['publisher'];
    courseId = json['courseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    data['content'] = this.content;
    data['annexes'] = this.annexes;
    data['createTime'] = this.createTime;
    data['publisher'] = this.publisher;
    data['courseId'] = this.courseId;
    return data;
  }
}
