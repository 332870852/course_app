import 'dart:convert';

import 'package:course_app/data/chat/request_friend.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/router/application.dart';
import 'package:flutter/material.dart';

class RequestFriendProvide with ChangeNotifier {
  ///联系人-好友请求
  List<RequestAddFriendModel> requestFriends = [];


  ///未读联系人数
  int unReadReq = 0;

  addRequestAddFriendModel(RequestAddFriendModel r) {
    bool flag=false;
    this.requestFriends.forEach((i){
       if(i.sid==r.sid) flag=true;
    });
    if(flag){
      return null;
    }
    this.requestFriends.add(r);
    if (unReadReq < 99) {
      unReadReq++;
    }
    notifyListeners();
    saveRequestAddFriendModel(this.requestFriends);
  }

  delUnReadReq() {
    if (unReadReq > 0) {
      unReadReq--;
      notifyListeners();
    }
  }

  saveRequestAddFriendModel(List<RequestAddFriendModel> list) {
    List<String> temp = [];
    list.forEach((item) {
      temp.add(json.encode(item));
    });
    String username='';
    if (Application.sp.containsKey('username')) {
      username = Application.sp.get('username');
    }
    Application.sp.setStringList('requestFriends:${username}', temp);
  }

  getRequestAddFriendModel() {
    String username='';
    if (Application.sp.containsKey('username')) {
      username = Application.sp.get('username');
    }
    List<String> temp = Application.sp.getStringList('requestFriends:${username}');
    List<RequestAddFriendModel> res = [];
    if(temp!=null){
      temp.forEach((item) {
        RequestAddFriendModel friendModel =
        RequestAddFriendModel.fromJson(json.decode(item));
        res.add(friendModel);
      });
    }
    this.requestFriends = res;
    this.unReadReq=res.length;
    notifyListeners();
  }

  Future<RequestAddFriendModel> getFriend(String fid) async {
    RequestAddFriendModel res;
    this.requestFriends.forEach((i) {
      if (i.sendUserId == fid) {
        res = i;
      }
    });
    return res;
  }

  Future<void> removeOneBySid(String sid) async{
     int i=0,del=0;
    this.requestFriends.forEach((item) {
      if (item.sid == sid) {
        del = i;
      }
      i++;
    });
    this.requestFriends.removeAt(del);
    if(unReadReq>0)unReadReq--;
     notifyListeners();
    saveRequestAddFriendModel(this.requestFriends);

  }
}
