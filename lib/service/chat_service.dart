import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:course_app/data/chat/agree_req.dart';
import 'package:course_app/data/chat/chat_info.dart';
import 'package:course_app/data/chat/request_friend.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/provide/chat/chat_contact_provide.dart';
import 'package:course_app/provide/chat/chat_message_provide.dart';
import 'package:course_app/provide/currentIndex_provide.dart';
import 'package:course_app/provide/chat/request_friend_provide.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/utils/data_content.dart';
import 'package:course_app/utils/notifications_util.dart';
import 'package:provide/provide.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';

enum ChatActionEnum {
  KEEPALIVE, //客户端保持心跳
  CONNECT, //第一次(或重连)初始化连接
  CHAT, //聊天消息,
  SIGNED, //消息签收
  PULL_FRIEND, //拉取好友
  REQUEST_FRIEND, //请求添加好友
  AGREEFRIEND, //同意加好友
  SAYBYE, //下线
}

class ChatService {
  IOWebSocketChannel _channel;
  JsonEncoder _encoder = JsonEncoder();
  var connecting = false; //websocket连接状态

  ChatService(
    this._channel,
  );

  void onMessage(Map mapData) async {
    connecting = true;
    var data = mapData['data'];
    print(mapData['type']);
    switch (mapData['type']) {
      case 'req_addfriend':
        {
          String sid = data['sid'];
          String sendUserId = data['sendUserId'];
          String requestDateTime = data['requestDateTime'];
          print('$sid $sendUserId  $requestDateTime');
          RequestAddFriendModel addFriendModel = RequestAddFriendModel(
              sid: sid,
              sendUserId: sendUserId,
              requestDateTime: requestDateTime);
          Application.eventBus.publish(addFriendModel); //推送
          //todo 通知
          break;
        }
      case 'agreefriend':
        {
          String sid = data['sid'];
          String friendId = data['friendId'];
          bool agree = data['agree'];
          String requestDateTime = data['requestDateTime'];
          AgreeReq agreeReq = AgreeReq(
              sid: sid,
              friendId: friendId,
              agree: agree,
              requestDateTime: requestDateTime);
          Application.eventBus.publish(agreeReq);
          // print(agree);
          break;
        }
      case 'chat':
        {
          //todo 接收聊天消息
          if (data is List) {
            List<dynamic> list = data;
            list.forEach((data) {
              ChatMessage chatMessage = ChatMessage.fromJson(data);
              print('        ${chatMessage}');
              if (chatMessage != null) {
                Application.eventBus.publish(chatMessage); //事件总线发送消息
              }
            });
          } else {
            ChatMessage chatMessage = ChatMessage.fromJson(data);
            print('        ${chatMessage}');
            if (chatMessage != null) {
              Application.eventBus.publish(chatMessage); //事件总线发送消息
            }
          }

//          ChatMessage chatMessage = ChatMessage.fromJson(data);
//          print('        ${chatMessage}');
//          if (chatMessage != null) {
//            Application.eventBus.publish(chatMessage); //事件总线发送消息
//          }
          break;
        }
      case 'keepalive':
        {
          debugPrint('接收到心跳包');
          break;
        }
      case 'syabye':
        {
          print('saybye : $data');
          if (data) {
            //  _channel.sink.close();
          }
          break;
        }
    }
  }

  void connect(String myUserId) {
    send(ChatActionEnum.CONNECT, {'myUserId': myUserId});
  }

  //添加好友
  void addFrined({String myUserId, String friendId}) {
    String date = DateTime.now().toIso8601String();
    send(
      ChatActionEnum.REQUEST_FRIEND,
      {'myUserId': myUserId, 'friendId': friendId, 'requestDateTime': date},
    );
  }

  //同意请求
  Future agreefriend(String sid,
      {@required bool agree,
      @required String myUserId,
      @required String friendId}) async {
    send(
      ChatActionEnum.AGREEFRIEND,
      {'sid': sid, 'myUserId': myUserId, 'friendId': friendId, 'agree': agree},
    );
  }

  //下线
  void sayBye() {
    //String myUserId
    send(
      ChatActionEnum.SAYBYE,
      null,
    );
  }

  /*
  消息发送
 */
  Future<bool> send(ChatActionEnum action, data) async {
    print('send/// ${_channel.closeCode} ${_channel.closeReason} ');
    DataContent dataContent = DataContent(
        action: ActionEnum.CHAT.index, subAction: action.index, data: data);
    _channel?.sink.add(_encoder.convert(dataContent));
    _channel.sink.done.then((onValue) {
      debugPrint('chat sink  ${onValue.toString()}');
    }).catchError((onError) {
      debugPrint('chat sink  errir ${onError.toString()}');
    }).timeout(Duration(seconds: 10), onTimeout: () {
      debugPrint('chat sink timeout');
    });
    return connecting == true;
  }

  static doReceiveNotf(BuildContext context) {
    Application.eventBus
        .respond<RequestAddFriendModel>((RequestAddFriendModel req) {
      ///好友请求
      Provide.value<RequestFriendProvide>(context)
          .addRequestAddFriendModel(req);
      NotificationsUtil.show(
          notificationId: 10,
          title: '好友添加请求',
          content: '${req.sendUserId}请求添加好友',
          payload: 'friend',
          groupKey: 'friend',
          onSelectNotificationMy: (p) async {
            if (p == "friend") {
              Provide.value<CurrentIndexProvide>(context).changeIndex(1);
            }
          });
    })
          ..respond<AgreeReq>(((AgreeReq agreeReq) async {
            String title = '';
            String content = '';
            List<String> friendIds = [];
            friendIds.add(agreeReq.friendId);
            List<UserInfoVo> friendsInfo =
                await UserMethod.getFriendsUserInfo(context, friendIds);
            //do agree
            if (agreeReq.agree) {
              title = '好友同意添加请求';
              content =
                  '${friendsInfo[0].nickname} 同意了你的好友请求! ${agreeReq.requestDateTime}';
              print('好友同意添加请求 ${friendsInfo[0]}');
              Provide.value<ChatContactProvide>(context)
                  .insertMyFriendsInfo(context, friendsInfo[0]);
            } else {
              title = '好友拒绝添加请求';
              content =
                  '${friendsInfo[0].nickname} 拒绝了你的好友请求! ${agreeReq.requestDateTime}';
            }
            NotificationsUtil.show(
                notificationId: 10,
                title: '$title',
                content: '$content',
                payload: 'agreeReq',
                groupKey: 'agreeReq',
                onSelectNotificationMy: (p) async {
                  if (p == "agreeReq") {
                    Provide.value<CurrentIndexProvide>(context).changeIndex(1);
                  }
                });
          }))
          ..respond<ChatMessage>((ChatMessage msg) {
            //todo 处理接收到的聊天消息
            // debugPrint('处理接收到的聊天消息');
            Provide.value<ChatMessageProvide>(context).addOneMsg(context, msg);
          });
  }
}
