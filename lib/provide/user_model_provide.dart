import 'dart:convert';

import 'package:course_app/data/user_model_vo.dart';
import 'package:course_app/provide/user_provider.dart';
import 'package:course_app/router/application.dart';
import 'package:course_app/service/user_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

class UserModelProvide with ChangeNotifier {
  UserModel user;
  ///登录按钮
  int animationStatus = 0;

   ///初始化
  void initUser(BuildContext context) {
    if (Application.sp.containsKey('user')) {
      String s = Application.sp.getString('user');
      user = UserModel.fromJson(json.decode(s));
      Provide.value<UserProvide>(context).userId = user.userVo.userId.toString();
      Provide.value<UserProvide>(context).role=user.userVo.role;
    }
  }

  /// 登录
  Future<UserModel> login(String username, String pwd, int loginType) async {
    UserModel user = await UserMethod.userLogin(username, pwd, loginType)
        .catchError((onError) {
      Fluttertoast.showToast(msg: onError, toastLength: Toast.LENGTH_LONG);
      return null;
    });
    if (user != null && user.code == 1) {
      _saveUserInfo(user).whenComplete((){
        notifyListeners();
      });
    }
    return user;
  }

  /// 保存用户信息到 sp
  Future<void> _saveUserInfo(UserModel user) async{
    user = user;
    Application.sp.setString('user', json.encode(user.toJson()));
  }
}
