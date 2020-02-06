import 'package:flutter/material.dart';

class WebsocketMessage {
  int code;
  String content;
  int date;
  Object messageBody;
  String method;
  String title;
  int size;

  WebsocketMessage(
      {this.code,
        this.content,
        this.date,
        this.messageBody,
        this.method,
        this.title,
        this.size});

  @override
  String toString() {
    return 'WebsocketMessage{code: $code, content: $content, date: $date, messageBody: $messageBody, method: $method, title: $title, size: $size}';
  }

  WebsocketMessage.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    content = json['content'];
    date = json['date'];
    messageBody = json['messageBody'];
    method = json['method'];
    title = json['title'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['content'] = this.content;
    data['date'] = this.date;
    data['messageBody'] = this.messageBody;
    data['method'] = this.method;
    data['title'] = this.title;
    data['size'] = this.size;
    return data;
  }
}