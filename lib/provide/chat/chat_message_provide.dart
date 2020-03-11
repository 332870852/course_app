import 'package:common_utils/common_utils.dart';
import 'package:course_app/data/chat/chat_info.dart';
import 'package:course_app/data/chat/chat_model.dart';
import 'package:course_app/pages/chat/chat_details_page.dart';
import 'package:course_app/router/application.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

import '../user_provider.dart';
import 'chat_contact_provide.dart';
import 'conversationItem.dart';
import 'flush_bar_util.dart';

///聊天消息
class ChatMessageProvide with ChangeNotifier {
  Map<String, List<Chat>> msgMap = Map(); //没个人接收的消息
  List<ConversationItem> messageList = []; // 所有消息页面人员
  //List<Chat> historyMessage = []; //接收到哦的所有的历史消息
  String cureentFriendId; //当前正在打开的聊天页面

  //saveMsgList() {}

  clearAll() {
    debugPrint("clearAll");
    msgMap = Map();
    messageList = [];
    cureentFriendId = null;
    notifyListeners();
  }

  insertTalk(Chat chat) {
    print('insertTalk :${chat.content.toString()}');

    ///本地插入
    if (this.msgMap['${chat.friendId}'] != null) {
      this.msgMap['${chat.friendId}'].add(chat);
    } else {
      this.msgMap['${chat.friendId}'] = [chat];
    }
    insertMessageList(chat.friendId, chat.userName, chat.userHeadUrl,
        chat.content, chat.createAt,
        displayDot: false);
  }

  //插入消息列表
  insertMessageList(String friendId, String fiendNick, String fUrl,
      dynamic content, String time,
      {int unRead = 0, bool displayDot = false}) {
    ///消息列表
    int index = messageList.indexWhere((item) => item.friendId == friendId);
    //是否是当前打开的聊天页面
    bool displayDot = !(cureentFriendId == friendId);
    print('displayDot  ${displayDot}  ${friendId}');
    String msg = '';
    debugPrint('pic ${content is String}');
    if (content is String) {
      msg = content;
      int len = msg.length;
      if (len > 4) {
        if (msg.contains('.mp4', len - 4)) {
          msg = '[视频]';
        } else if (msg.contains('.png', len - 4) ||
            msg.contains('.jpg', len - 4)) {
          msg = '[图片]';
        }
      }
    } else {
      debugPrint('pic');
      //不是字符串的消息
      msg = '[图片]';
    }
    if (index != -1) {
      var temp = messageList[index];
//      temp.msg = msg;
//      temp.time = '${time}'; //.substring(11, 16)
//      temp.unRead += unRead;
//      temp.displayDot = displayDot;
      ConversationItem conversationItem=new ConversationItem(
        temp.friendId,
        fusername: temp.fusername,
        friendUrl: '${temp.friendUrl}',
        msg: msg,
        time: '${temp.time}',
        //.substring(11, 16)
        displayDot: displayDot,
        unRead: temp.unRead+1,
      );
      messageList.removeAt(index);
      messageList.add(conversationItem);
      print('insert 1 ${temp.fusername}  ${temp.msg}');
    } else {
      print('insert 0 ${friendId}  ${fiendNick}');
      messageList.insert(
          0,
          new ConversationItem(
            friendId,
            fusername: fiendNick,
            friendUrl: '${fUrl}',
            msg: msg,
            time: '${time}',
            //.substring(11, 16)
            displayDot: displayDot,
            unRead: unRead,
          ));
    }
    notifyListeners();
  }

  List<Chat> getFriendTalk(String friendId) {
    if (this.msgMap.containsKey(friendId)) {
      return this.msgMap[friendId];
    }
    return null;
  }

  ///修改成网络图片上传成功状态
  modifyImgTalk(String friendId, int imgId, userHeadImage) {
    debugPrint('modifyImgTalk  ${imgId} ');
    if (this.msgMap.containsKey(friendId)) {
      int i = 0, index = -1;
      this.msgMap[friendId].forEach((item) {
        print(' ${item.type}   ${item.content}    ');
        if (item.type == 3 && item.content.userId == imgId) {
          index = i;
        }
        i++;
      });

      debugPrint('modifyImg  ${index} ');
      if (index != -1) {
        this.msgMap[friendId][index].content = userHeadImage;
        notifyListeners();
      }
    }
  }

  addOneMsg(BuildContext context, ChatMessage msg) async {
    String dateTime =
        DateTime.fromMillisecondsSinceEpoch(msg.createTime).toString(); //时间转换
    if (DateUtil.isToday(msg.createTime)) {
      dateTime = dateTime.substring(11, 16);
    }
    var my = Provide.value<UserProvide>(context).userInfoVo; //我
    var peer = await Provide.value<ChatContactProvide>(context)
        .searchFiend(context, msg.senderId); //好友
    print('peer :${peer}');
    Chat chat = new Chat(
      myUserId: '${peer.userId}',
      myName: '${my.nickname}',
      myHeadUrl: '${my.faceImage}',
      friendId: '${peer.userId}',
      userName: '${peer.nickname}',
      userHeadUrl: '${peer.faceImage}',
      content: msg.msg,
      type: msg.msgType,
      readAt: 0,
      createAt: dateTime,
    );

    ///每个人的历史消息
    if (this.msgMap.containsKey(msg.senderId)) {
      this.msgMap[msg.senderId].add(chat);
    } else {
      this.msgMap.putIfAbsent(msg.senderId, () => [chat]);
    }

    ///消息列表
    //int index = messageList.indexWhere((item) => item.friendId == msg.senderId);
    //是否是当前打开的聊天页面
    bool displayDot = !(cureentFriendId == msg.senderId);
    debugPrint('$cureentFriendId');
    insertMessageList(
        msg.senderId, peer.nickname, peer.faceImage, msg.msg, dateTime,
        displayDot: displayDot, unRead: 1);

    //todo 通知
    if(displayDot){
      Flushbar flushbar = FlushBarUtil.getFlushBar(Duration(seconds: 4),
          title: '${peer.nickname} 发来消息',
          message: '${msg.msg}',
          isDismissible: true, onTap: (value) {
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (context) => ChatDetailsPage(
//                      myUserId: '${my.userId}',
//                      friendId: '${peer.userId}',
//                      friendName: '${peer.nickname}',
//                      myHeadUrl: '${my.faceImage}',
//                      friendUrl: '${peer.faceImage}',
//                      myName: '${my.nickname}',
//                    )));
          });
      if (!flushbar.isShowing()) {

      }

  }
}

  ///跟新已读人数
  void updateUnRead(String friendId, int i) {
    debugPrint("updateUnRead");
    int index = messageList.indexWhere((item) => item.friendId == friendId);
    if (index != -1) {
      messageList[index].unRead = i;
      notifyListeners();
    }
  }


  ///拉取聊天记录
  saveMsgMap(BuildContext context,List<ChatMessage> history)async{
      this.msgMap.clear();
//
//      if(ObjectUtil.isNotEmpty(history)){
//        var my = Provide.value<UserProvide>(context).userInfoVo; //我
//
//        var peer = await Provide.value<ChatContactProvide>(context)
//            .searchFiend(context, history[0].senderId); //好友
//         history.forEach((f)async{
//           String dateTime =
//           DateTime.fromMillisecondsSinceEpoch(f.createTime).toString(); //时间转换
//           if (DateUtil.isToday(f.createTime)) {
//             dateTime = dateTime.substring(11, 16);
//           }
//           print('peer :${peer}');
//           Chat chat = new Chat(
//             myUserId: '${peer.userId}',
//             myName: '${my.nickname}',
//             myHeadUrl: '${my.faceImage}',
//             friendId: '${peer.userId}',
//             userName: '${peer.nickname}',
//             userHeadUrl: '${peer.faceImage}',
//             content: f.msg,
//             type: f.msgType,
//             readAt: 0,
//             createAt: dateTime,
//           );
//           if (this.msgMap.containsKey(f.senderId)) {
//             this.msgMap[f.senderId].add(chat);
//           } else {
//             this.msgMap.putIfAbsent(f.senderId, () => [chat]);
//           }
//
//         });
//      }
//
  }

}

