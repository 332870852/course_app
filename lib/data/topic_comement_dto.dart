class TopicCommentDto {
  String topicId;
  String content;
  String createTime;
  String replayId;
  String publisher;


  TopicCommentDto({this.topicId, this.content, this.createTime, this.replayId,
    this.publisher});

  TopicCommentDto.fromJson(Map<String, dynamic> json) {
    topicId = json['topicId'];
    content = json['content'];
    createTime = json['createTime'];
    replayId = json['replayId'];
    publisher = json['publisher'];
  }

  @override
  String toString() {
    return 'TopicCommentDto{topicId: $topicId, content: $content, createTime: $createTime, replayId: $replayId, publisher: $publisher}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topicId'] = this.topicId;
    data['content'] = this.content;
    data['createTime'] = this.createTime;
    data['replayId'] = this.replayId;
    data['publisher'] = this.publisher;
    return data;
  }
}
