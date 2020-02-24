import 'package:course_app/config/service_url.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class Websocket {
  IOWebSocketChannel _channel;

  initWebsocket(String userId,{String connectUrl,String token}) {
    Map<String,dynamic> head=Map();
    head.putIfAbsent('token', ()=>token);
    if (connectUrl != null && connectUrl.trim().isNotEmpty) {
      _channel = IOWebSocketChannel.connect('${connectUrl}',headers: head);
    } else {
      _channel = IOWebSocketChannel.connect('${webSocketUrl}${userId}',headers: head);
      debugPrint('${webSocketUrl}${userId}');
    }
  }

  void sendMessage(message) {
    debugPrint('sendMessage   ：${message}');
    _channel.sink.add(message);
  }

  ///监听来自服务器的消息
  receiveMessage(void onData(event),
      {Function onError, void onDone(), bool cancelOnError}) {
    _channel.stream.listen(onData,
        onDone: onDone, onError: onError, cancelOnError: cancelOnError);
  }


  close({closeCode,closeReason}) {
    if (_channel != null) {
      _channel.sink.close(closeCode);
      _channel = null;
    }
  }

  IOWebSocketChannel getWebSocket(){
    return _channel;
  }

//  static final Websocket _websocket = Websocket._();
//
//  Websocket._() {
//    _channel = IOWebSocketChannel.connect('${webSocketUrl}');
//  }
//
//  static Websocket getWebsocket({}) {
//    return _websocket;
//  }
//
//  static closeWebsocket() {
//

}
