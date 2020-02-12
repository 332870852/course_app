import 'dart:convert';

import 'package:course_app/data/user_head_image.dart';
import 'package:course_app/data/user_info.dart';
import 'package:course_app/data/user_model_vo.dart';
import 'package:course_app/service/user_method.dart';
import 'package:course_app/utils/ResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvide with ChangeNotifier {
  UserModel user;

  List<UserHeadImage> userImageList = [];

  /////////////////////////
  ///userId
  String userId;
  int role = 3; // 2-教师，3-学生

  void updateUserId({@required String newUserId}) {
    userId = newUserId;
    notifyListeners();
  }

  void updateRole({@required int newRole}) {
    role = newRole;
    notifyListeners();
  }

  ///刷新按钮
   bool refreshBtn=false;
   changeRefreshBtn(bool status){
     this.refreshBtn=status;
     notifyListeners();
   }

  /////////////////////////
  ///老师个人信息
  UserInfoVo tacherInfo;

  ///个人中心信息
  UserInfoVo userInfoVo;
  String userInfoString = "[]";

  ///修改的字段
  var modif = '';

  /// 性别
  int sex;

  ///////////////控件/////////////
  ///对话框确认按钮的状态
  int dialogState = 0; //0-默认值,1-加载中，2-失败

  void ChangeDialogState(int state) {
    dialogState = state;
    notifyListeners();
  }

  ///////////////////////////////

  ///获取课堂头像
  Future<List<UserHeadImage>> getUserHeadImage(
      BuildContext context, List ids) async {
    ResponseModel responseModel;
    if (ids != null && ids.isEmpty == false && userImageList.length < 1) {
      print("wwwwwwwwww${ids}");
      responseModel = await UserMethod.getUserHeadImage(context, userId: ids);
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
  Future<UserInfoVo> getTeacherInfo(BuildContext context,
      {@required teacherId}) async {
    if (teacherId.toString().isNotEmpty && tacherInfo == null) {
      print("ttttttttt${teacherId}");
      tacherInfo = await UserMethod.getUserInfo(context, userId: teacherId);
    }
    return tacherInfo;
  }

//  ///获取用户信息
//  Future<UserInfoVo> getUserInfo(BuildContext context,{@required userId}) async {
//    print("UserProvide.getUserInfo");
//    ResponseModel responseModel;
//    if (userInfoVo.toString().isNotEmpty && userInfoVo == null) {
//      //print("ttttttttt${userId}");
//      responseModel = await UserMethod.getUserInfo(context,userId: userId);
//      if (responseModel.data != null) {
//        userInfoVo = UserInfoVo.fromJson(responseModel.data);
//      }
//    }
//    if(userInfoVo!=null){
//      role=userInfoVo.role;
//      saveUserInfo(userInfoVo);
//    }
//   // notifyListeners();
//    return userInfoVo;
//  }

  ///获取用户信息
  Future<UserInfoVo> getUserInfo() async {
    print("UserProvide.getUserInfo");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userInfoString = prefs.getString('userInfo');
    UserInfoVo temp = UserInfoVo.fromJson(json.decode(userInfoString));
    userInfoVo = temp;
    notifyListeners();
    return userInfoVo;
  }

  ///保存个人信息
  saveUserInfo(UserInfoVo newUserInfo) async {
    ///初始化SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ///把字符串进行encode操作，
    if (newUserInfo.nickname == null) {
      newUserInfo.nickname = "";
    }
    userInfoString = json.encode(newUserInfo).toString();
    //userInfoVo=newUserInfo;
    prefs.setString('userInfo', userInfoString); //进行持久化
    getUserInfo();
    //notifyListeners();
  }

  ///get 个人信息
//  getUserInfo_sp()async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    userInfoString=prefs.getString('userInfo');
//    userInfoVo=UserInfoVo.fromJson(json.decode(userInfoString.toString()));
//    print("save:  ${userInfoVo}");
//    notifyListeners();
//  }

  void InitUser(UserModel userModel) {
    user = userModel;
    notifyListeners();
  }
}
