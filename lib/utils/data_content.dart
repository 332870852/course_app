//netty

enum ActionEnum {
  CHAT, //聊天
  VIDEO_1V1, //1V1视频
  SOFT_ADMIN,
}

//enum ChatActionEnum {
//  none,
//  CONNECT, //第一次(或重连)初始化连接
//  CHAT, //聊天消息,
//  SIGNED, //消息签收
//  KEEPALIVE, //客户端保持心跳
//  PULL_FRIEND, //拉取好友
//}

class DataContent {
  num action; //消息类型
  dynamic data; //消息主体
  String extand;
  num subAction;

  DataContent({this.action, this.data, this.extand, this.subAction});

  @override
  String toString() {
    return 'DataContent{action: $action, data: $data, extand: $extand, subAction: $subAction}';
  }

  DataContent.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    data = json['data'];
    extand = json['extand'];
    subAction = json['subAction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['data'] = this.data;
    data['extand'] = this.extand;
    data['subAction'] = this.subAction;
    return data;
  }
}
