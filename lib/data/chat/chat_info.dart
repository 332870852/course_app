//用于发送的聊天消息
class ChatMessage {
  String msgId;
  String senderId; //发送者
  String receiverId; //接收者
  String msg; //内容
  int msgType; // '类型 1：文字；47：emoji；43：音频；436207665：红包；49：文件；48：位置；2：图片',
  dynamic createTime;
  String extand;

  ChatMessage({this.msgId, this.senderId, this.receiverId, this.msg,
    this.msgType, this.createTime, this.extand}); //签收的id

  ChatMessage.fromJson(Map<String, dynamic> json) {
    msgId = json['msgId'].toString();
    senderId = json['senderId'].toString();
    receiverId = json['receiverId'].toString();
    msg = json['msg'].toString();
    msgType = json['msgType'];
    extand = json['extand'].toString();
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msgId'] = this.msgId;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['msg'] = this.msg;
    data['msgType'] = this.msgType;
    data['extand'] = this.extand;
    data['createTime'] = this.createTime;
    return data;
  }
}
