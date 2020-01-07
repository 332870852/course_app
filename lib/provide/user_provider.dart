import 'dart:convert';

import 'package:course_app/data/user_head_image.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvide with ChangeNotifier {
  List<UserHeadImage> userImageList = [];

  ///老师个人信息
  UserInfoVo tacherInfo;

  ///个人中心信息
  UserInfoVo userInfoVo;
  String userInfoString = "[]";

  ///修改的字段
  var modif='';
  ///
  int sex;

  ///获取课堂头像
  Future<List<UserHeadImage>> getUserHeadImage(List ids) async {
    ResponseModel responseModel;
    if (ids != null && ids.isEmpty == false && userImageList.length < 1) {
      print("wwwwwwwwww${ids}");
      responseModel = await UserMethod.getUserHeadImage(userId: ids);
      List<dynamic> list = responseModel.data;
      userImageList = list
          .map((image) {
            return UserHeadImage.fromJson(image);
          })
          .toList()
          .cast();
      return userImageList;
    }
    return userImageList;
  }

  ///获取老师信息
  Future<UserInfoVo> getTeacherInfo({@required teacherId}) async {
    ResponseModel responseModel;
    if (teacherId.toString().isNotEmpty && tacherInfo == null) {
      print("ttttttttt${teacherId}");
      responseModel = await UserMethod.getUserInfo(userId: teacherId);
      if (responseModel.data != null) {
        tacherInfo = UserInfoVo.fromJson(responseModel.data);
      }
    }
    return tacherInfo;
  }

  ///获取用户信息
  Future<UserInfoVo> getUserInfo({@required userId}) async {
    ResponseModel responseModel;
    if (userInfoVo.toString().isNotEmpty && userInfoVo == null) {
      print("ttttttttt${userId}");
      responseModel = await UserMethod.getUserInfo(userId: userId);
      if (responseModel.data != null) {
        userInfoVo = UserInfoVo.fromJson(responseModel.data);
      }
    }

    if(userInfoVo!=null){
      saveUserInfo(userInfoVo);
    }
    notifyListeners();
    return userInfoVo;
  }

  ///保存个人信息
  saveUserInfo(UserInfoVo newUserInfo) async {
    ///初始化SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ///把字符串进行encode操作，
    if(newUserInfo.nickname==null){
      newUserInfo.nickname="";
    }
    userInfoString= json.encode(newUserInfo).toString();
    userInfoVo=newUserInfo;

    prefs.setString('userInfo', userInfoString);//进行持久化
    notifyListeners();
  }

 ///get 个人信息
  getUserInfo_sp()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //获得购物车中的商品,这时候是一个字符串
    userInfoString=prefs.getString('userInfo');
    userInfoVo=UserInfoVo.fromJson(json.decode(userInfoString.toString()));
    print("save:  ${userInfoVo}");
    notifyListeners();
  }



}
