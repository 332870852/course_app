import 'package:flutter/material.dart';

//添加好友 请求

class RequestAddFriendModel{

  String sid;
  String sendUserId;
  String requestDateTime;

  RequestAddFriendModel({this.sid, this.sendUserId, this.requestDateTime});

  @override
  String toString() {
    return 'RequestAddFriendModel{sid: $sid, sendUserId: $sendUserId, requestDateTime: $requestDateTime}';
  }

  RequestAddFriendModel.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    sendUserId = json['sendUserId'];
    requestDateTime = json['requestDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    data['sendUserId'] = this.sendUserId;
    data['requestDateTime'] = this.requestDateTime;
    return data;
  }
}