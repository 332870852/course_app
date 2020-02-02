//receiver
///评论
class ReplyList {
  int commentAnnId;
  String userId;
  String commentBody;
  String date;
  String announceId;
  int parentId;
  List<ReplyList> replyList;

  ReplyList(
      {this.commentAnnId,
        this.userId,
        this.commentBody,
        this.date,
        this.announceId,
        this.parentId,
        this.replyList});


  @override
  String toString() {
    return 'ReplyList{commentAnnId: $commentAnnId, userId: $userId, commentBody: $commentBody, date: $date, announceId: $announceId, parentId: $parentId, replyList: $replyList}';
  }

  ReplyList.fromJson(Map<String, dynamic> json) {
    commentAnnId = json['commentAnnId'];
    userId = json['userId'];
    commentBody = json['commentBody'];
    date = json['date'];
    announceId = json['announceId'];
    parentId = json['parentId'];
    if (json['replyList'] != null) {
      replyList = new List<ReplyList>();
      json['replyList'].forEach((v) {
        replyList.add(new ReplyList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentAnnId'] = this.commentAnnId;
    data['userId'] = this.userId;
    data['commentBody'] = this.commentBody;
    data['date'] = this.date;
    data['announceId'] = this.announceId;
    data['parentId'] = this.parentId;
    if (this.replyList != null) {
      data['replyList'] = this.replyList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}