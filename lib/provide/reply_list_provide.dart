import 'dart:convert';

import 'package:course_app/data/announcement_vo.dart';
import 'package:course_app/data/comment_vo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///评论
class ReplyListProvide with ChangeNotifier {
  ///评论内容
  List<ReplyList> replyList = [];
  ///公告数
  List<AnnouncementVo> announceList = [];
  //List<String> announceListStr=[];

  bool display=true;
  void changDisplay(bool state) {
    display=state;
    notifyListeners();
  }

  ///存储string

  saveReplyList({@required List<ReplyList> reply}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = [];
    reply.forEach((item) {
      list.add(json.encode(item).toString());
    });
    prefs.setStringList('replyList', list);
  }

  getReplyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('replyList');
    List<ReplyList> tempList = [];
    list.forEach((item) {
      tempList.add(ReplyList.fromJson(json.decode(item)));
    });
    replyList=tempList;
    notifyListeners();
  }

  saveAnnouncement(List<AnnouncementVo> source)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = [];
    source.forEach((item) {
      list.add(json.encode(item).toString());
    });
    prefs.setStringList('AnnouncementVoList', list).whenComplete((){
       getAnnouncement(update: true);
    });

  }

  insertAnnouncement(AnnouncementVo source)async{
    announceList.insert(1,source);
    await saveAnnouncement(announceList);
  }

  removeAnnouncement(String announceId)async{
    print("removeAnnouncement**********${announceId}");
    int i=0,del=-1;
    print(announceList.length);
     announceList.forEach((item){
        if(item.announceId.toString()==announceId){
          del=i;
        }
        i++;
     });
     print(del);
    announceList.removeAt(del);
    print(announceList);
    saveAnnouncement(announceList);
  }

  ///修改公告
  updateAnnouncement({@required int announceId,String announceTitle,String body,String annex})async{
    int index=-1,i=0;
    announceList.forEach((item){
      if(item.announceId==announceId){
        index=i;
      }
      i++;
    });
    AnnouncementVo announcementVo=announceList[index];
    announcementVo.announceTitle=announceTitle;
    announcementVo.announceBody=body;
    announcementVo.annex=annex;
    announceList[index]=announcementVo;
    saveAnnouncement(announceList);
  }

//Future<List<AnnouncementVo>>
   getAnnouncement({bool update=false})async{
     print("getAnnouncement------------");
//announceList.isNotEmpty&&announceList.length>1&&
    if(!update)
      return announceList;
    print("tttttttt");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('AnnouncementVoList');
    List<AnnouncementVo> tempList = [];
    list.forEach((item) {
      tempList.add(AnnouncementVo.fromJson(json.decode(item)));
    });
    announceList=tempList;
    notifyListeners();
    return announceList;
  }
}
