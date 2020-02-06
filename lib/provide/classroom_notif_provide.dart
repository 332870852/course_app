
import 'dart:convert';

import 'package:course_app/utils/websocket_message.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///房间消息通知
class ClassRoomNotifProvide with ChangeNotifier {

  List<WebsocketMessage> websocketMessage=[];

  saveUnReadMessage(WebsocketMessage message)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    websocketMessage.add(message);
    List<String> temp=[];
    websocketMessage.forEach((item){
      temp.add(json.encode(message));
    });
    prefs.setStringList("classroom_websocketMessage", temp);
    getReadMessage();
  }

  getReadMessage()async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     List<String> strs= prefs.getStringList("classroom_websocketMessage");
     List<WebsocketMessage> temp=[];
     strs.forEach((str){
        WebsocketMessage template=WebsocketMessage.fromJson(json.decode(str));
        temp.add(template);

     });
     websocketMessage=temp;
     notifyListeners();
  }

  deleteOneMessage(String method,String delId)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str= prefs.getString("classroom_websocketMessage");

    websocketMessage.forEach((message){
         switch(message.method){
           case 'createAnnouncement':{
               message.messageBody;
             break;
           }
         }
    });

  }

}