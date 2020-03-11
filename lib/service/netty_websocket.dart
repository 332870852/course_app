import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:course_app/data/user_model_vo.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/chat_service.dart';
import 'package:course_app/service/rtc_1v1_signaling.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';


class NettyWebSocket {
  IOWebSocketChannel _channel; //websocket
  RTCSignaling _rtcSignaling; //webrtc
  ChatService _chatService; //chet_service
  String display; //展示名称
  final String serverUrl;
  var subject;
  //String userId;

  JsonDecoder _decoder = JsonDecoder();

  NettyWebSocket({@required this.serverUrl, this.display});

  _initChatAndVideo() {
    _rtcSignaling = RTCSignaling(_channel, display: this.display);
    _chatService = ChatService(_channel);
  }

  //切换网络重连
  reConnect() {
    debugPrint('reConnect');
    subject= Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result != ConnectivityResult.none&&_channel!=null) {
         connect();
      }
      if(_chatService!=null){
        _chatService.connecting=(result!=ConnectivityResult.none);
      }
    });
  }

  //socket 连接
  IOWebSocketChannel connect() {
    _channel = IOWebSocketChannel.connect(this.serverUrl,
        pingInterval: Duration(seconds: 15)); //60 s 客户端心跳
//    if (_rtcSignaling == null) {
//      //初始化webrtc
//      _rtcSignaling = RTCSignaling(_channel, display: this.display);
//    }
//    if (_chatService == null) {
//      //初始化chat
//      _chatService = ChatService(_channel);
//    }
    _initChatAndVideo();
    String s = Application.sp.getString('user');
    UserModel user = UserModel.fromJson(json.decode(s));

    ///连接chat
    _chatService.connect(user.userVo.userId.toString());
    print('listen...');
    _channel.stream.listen((msg) {
      print('收到的内容: $msg');
      onMessage(msg);
    }, onDone: () {
     debugPrint('netty by closed');
     _chatService.connecting=false;
      Future.delayed(Duration(seconds: 10), () {
        Connectivity().checkConnectivity().then((onValue){
          debugPrint('done');
            if(onValue!=ConnectivityResult.none){
              connect();
              _chatService.connect(user.userVo.userId.toString());
            }
        });
      });
    }, onError: (onError) {
      _chatService.connecting=false;
      print('onError by server  ${onError.toString()}');

    });
    _chatService.connecting=true;
    return _channel;
  }

  //返回webrtc
  RTCSignaling getRTCSignaling() {
    if (this._rtcSignaling == null) {
      _rtcSignaling = RTCSignaling(_channel, display: this.display);
    }
    return this._rtcSignaling;
  }

  //返回chat
  ChatService getChatService() {
    if (this._chatService == null) {
      //初始化chat
      this._chatService = ChatService(_channel);
    }
    print(_chatService == null);
    return this._chatService;
  }

  /*
    收到消息处理逻辑
 */
  void onMessage(message) async {
    Map mapData= _decoder.convert(message);
    _rtcSignaling.onMessage(mapData);
    _chatService.onMessage(mapData);
  }

  void close() async {
    debugPrint('close netty');
    if (_channel != null) {
      _chatService.sayBye();
      _channel.sink.close();
      _channel = null;
    }
    if(subject!=null){
      subject.dispose();
      subject=null;
    }
  }
}
