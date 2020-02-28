//netty

enum ActionEnum {
  CHAT, //聊天
  VIDEO_1V1, //1V1视频
}

class DataContent {
  num action; //消息类型
  dynamic data; //消息主体
  String extand;

  DataContent({this.action, this.data, this.extand});

  @override
  String toString() {
    return 'DataContent{action: $action, data: $data, extand: $extand}';
  }

  DataContent.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    data = json['data'];
    extand = json['extand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['data'] = this.data;
    data['extand'] = this.extand;
    return data;
  }
}
