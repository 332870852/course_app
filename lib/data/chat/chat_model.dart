
class Chat{
  String id;
  String myUserId;
  String myName;
  String myHeadUrl;
  dynamic content;
  int type;
  String createAt;
  int readAt;
  String friendId;
  String userName;
  String userHeadUrl;


  Chat({this.id, this.myUserId, this.friendId, this.content, this.type,
    this.createAt, this.readAt, this.userName, this.userHeadUrl, this.myName,
    this.myHeadUrl});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    myUserId = json['myUserId'].toString();
    friendId = json['friendId'].toString();
    content = json['content'];
    type = json['type'];
    createAt = json['createAt'].toString();
    userName = json['userName'].toString();
    userHeadUrl = json['userHeadUrl'].toString();
    myName = json['myName'].toString();
    myHeadUrl = json['myHeadUrl'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['myUserId'] = this.myUserId;
    data['friendId'] = this.friendId;
    data['content'] = this.content;
    data['type'] = this.type;
    data['createAt'] = this.createAt;
    data['userName'] = this.userName;
    data['userHeadUrl'] = this.userHeadUrl;
    data['myName'] = this.myName;
    data['myHeadUrl'] = this.myHeadUrl;
    return data;
  }
}